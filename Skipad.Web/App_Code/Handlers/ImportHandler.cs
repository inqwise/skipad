using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Web;
using Helpers;
using Jayrock.Json;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Managers;

namespace Handlers
{
    public class ImportHandler : IHttpHandler
    {
        private HttpRequest _request;
        private HttpResponse _response;
        private HttpServerUtility _server;
        static readonly string TempFolderPath = ConfigurationManager.AppSettings["TempUploadFolder"];
        
        public void ProcessRequest(HttpContext context)
        {
            _request = context.Request;
            _response = context.Response;
            _server = context.Server;
            
            
            _response.Clear();
            _response.AddHeader("Pragma", "no-cache");
            _response.AddHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            _response.AddHeader("Content-Disposition", "inline; filename=\"files.json\"");
            _response.AddHeader("X-Content-Type-Options", "nosniff");
            _response.AddHeader("Access-Control-Allow-Origin", "*");
            _response.AddHeader("Access-Control-Allow-Methods", "POST");
            _response.AddHeader("Access-Control-Allow-Headers", "X-FileInfo-Name, X-FileInfo-Type, X-FileInfo-Size");
            var username = context.User.Identity.Name;

            int resourceTypeId;
            int tmpResourceId;
            int tmpResourceRoleId;
            
            int.TryParse(_request["resourceTypeId"], out resourceTypeId);
            
            string resourceUrl = _request["resourceUrl"];
            var fileInfo = new ResourceFileInfo();

            if (int.TryParse(_request["resourceId"], out tmpResourceId))
            {
                fileInfo.ResourceId = tmpResourceId;
            }

            fileInfo.ResourceRole = ResourceRole.Undefined;
            if (int.TryParse(_request["resourceRoleId"], out tmpResourceRoleId))
            {
                if (Enum.IsDefined(typeof (ResourceRole), tmpResourceRoleId))
                {
                    fileInfo.ResourceRole = (ResourceRole)tmpResourceRoleId;
                }                
            }

            fileInfo.ResourceType = (ResourceType)resourceTypeId;
            fileInfo.Url = resourceUrl;
            fileInfo.IsInternalHosting = (fileInfo.ResourceType == ResourceType.Image || fileInfo.ResourceType == ResourceType.Audio);

            if (string.IsNullOrEmpty(resourceUrl))
            {
                UploadFile(fileInfo);
            }
            else
            {
                DownloadFile(fileInfo);
            }

            _response.Clear();
            _response.AddHeader("Vary", "Accept");

            if (!fileInfo.HasError)
            {
                ResourcesManager.AddFile(fileInfo, username);
            }

            var ja = new JsonArray();
            var jo = new JsonObject();

            if (fileInfo.HasError)
            {
                jo.Put("error", fileInfo.Error);
            }
            else
            {
                jo.Put("name", fileInfo.Name);
                jo.Put("width", fileInfo.Width);
                jo.Put("height", fileInfo.Height);
                jo.Put("thumbnailUrl", fileInfo.ThumbnailUrl);
                jo.Put("url", fileInfo.Url);
                jo.Put("resourceId", fileInfo.ResourceId);
                jo.Put("resourceFileId", fileInfo.ResourceFileId);
                jo.Put("contentType", fileInfo.ContentType);
            }
            ja.Push(jo);


            string redirect = null;
            if (_request["redirect"] != null)
            {
                redirect = _request["Redirect"];
            }
            if (redirect != null)
            {
                _response.AddHeader("Location,", String.Format(redirect, _server.UrlEncode(ja.ToString())));
                _response.End();
            }
            if(_request.ServerVariables["HTTP_ACCEPT"] != null && _request.ServerVariables["HTTP_ACCEPT"].IndexOf("application/json") >= 0)
            {
                _response.AddHeader("Content-type","application/json");
            }
            else
            {
                _response.AddHeader("Content-type", "text/plain");
            }

            _response.Write(ja);
            _response.End();
        }

        private void DownloadFile(ResourceFileInfo fileInfo)
        {
            var downloadHelper = new DownloadHelper(TempFolderPath);
            downloadHelper.FileUploadHandle(fileInfo);
        }

        private void UploadFile(ResourceFileInfo fileInfo)
        {
            var uploadHelper = new UploadHelper(TempFolderPath);
            HttpFileCollection upload = _request.Files;

            for (int i = 0; i < upload.Count; i++)
            {
                HttpPostedFile file = upload[i];
                //fileInfo.type = (Path.GetExtension(file.FileName) ?? String.Empty).ToLower();
                fileInfo.Name = Path.GetFileName(file.FileName);
                fileInfo.Size = file.InputStream.Length;

                //fileInfo.ResourceType = ;
                if (_request.Headers["X-FileInfo-Size"] != null)
                {
                    fileInfo.Size = long.Parse(_request.Headers["X-FileInfo-Size"]);
                }

                uploadHelper.FileUploadHandle(file, fileInfo);
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}