using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using ExcelLibrary.SpreadSheet;
using Jayrock.Json;
using Inqwise.Skipad.Common.Errors;

namespace Handlers
{
    public abstract class BaseHandler<TOutput> : IHttpHandler
    {
        public enum ContentDefType
        {
            Json,
            Xls,
        }

        public class ContentDef
        {
            public static readonly ContentDef Json = new ContentDef { Name = ContentDefType.Json, ContentType = "application/json", Extention = "json" };
            public static readonly ContentDef Xls = new ContentDef { Name = ContentDefType.Xls, ContentType = "application/vnd.ms-excel", Extention = "xls" };
            public static Dictionary<ContentDefType, ContentDef> Map = new Dictionary<ContentDefType, ContentDef>
                {
                    {Json.Name, Json},
                    {Xls.Name, Xls}
                };
            
            public string ContentType { get; private set; }
            public ContentDefType Name { get; private set; }
            public string Extention { get; set; }
            private ContentDef()
            {}
        }

        protected const string LIST_PARAM_NAME = "list";
        protected const string TOP_ARG_NAME = "top";
        private static readonly ContentDef[] DEFAULT_IMPEMENTED_OUTPUT_TYPE = new[] { ContentDef.Json };

        protected ContentDef OutputArgs { get; private set; }
        protected string DownloadFilePath { get; set; }

        protected virtual ContentDef[] ImplementedOutputTypes
        {
            get { return DEFAULT_IMPEMENTED_OUTPUT_TYPE; }
        }

        private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();
        public void ProcessRequest(HttpContext context)
        {
            object output;
            string requestQuery = null;
            try
            {
                requestQuery = context.Request["rq"];

                // Identify output type
                ContentDef outputType;

                string otpStr = context.Request["otp"];
                var otp = ContentDefType.Json;
                if (null != otpStr)
                {
                    otp = (ContentDefType) Enum.Parse(typeof (ContentDefType), otpStr, true);
                }

                if (ContentDef.Map.TryGetValue(otp, out outputType))
                {
                    if (!ImplementedOutputTypes.Contains(outputType))
                    {
                        Log.Error("Requested OutputType '{0}' not implemented. Changed to default '{1}'", outputType.ContentType, ImplementedOutputTypes.First().ContentType);
                        outputType = ImplementedOutputTypes.First();
                    }
                }
                else
                {
                    outputType = ImplementedOutputTypes.First();
                }
                OutputArgs = outputType;
                // END:Identify output type

                string fileName = context.Request["name"];
                if (null != fileName)
                {
                    context.Response.AddHeader("Content-Disposition", "attachment;filename=\"" + fileName + "." + OutputArgs.Extention + "\"");
                }
                
                var requestJson = Jayrock.Json.Conversion.JsonConvert.Import<JsonObject>(requestQuery);
                var method = requestJson.First<JsonMember>();
                UserName = context.User.Identity.Name;
                output = Process(method.Name, (JsonObject)method.Value);
                context.Response.ContentType = OutputArgs.ContentType;


            }
            catch (Exception ex)
            {
                Log.ErrorException(string.Format("ProcessRequest: Unexpected error occured, rawRequest: '{0}'", requestQuery), ex);
                output = GetGeneralErrorString(ex.ToString());
            }

            if (null == output && null != DownloadFilePath)
            {
                context.Response.WriteFile(DownloadFilePath);
                //context.Response.Flush();
                //context.Response.Close();
            }
            else
            {
                context.Response.Output.Write(output);
            }
        }

        protected abstract TOutput Process(string methodName, JsonObject args); 

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        public string GetGeneralErrorString(string description)
        {
            return GetErrorJson(SkipadErrors.GeneralError, description).ToString();
        }

        public JsonObject GetMethodNotFoundJson(string methodName)
        {
            return GetErrorJson(SkipadErrors.MethodNotFound, methodName);
        }

        protected string UserName { get; private set; }

        protected JsonObject GetErrorJson(SkipadErrors errorCode, string details = null)
        {
            var errJo = new JsonObject();
            errJo.Put("error", errorCode);
            errJo.Put("description", details);
            return errJo;
        }

        protected JsonObject GetJsonOk()
        {
            var jo = new JsonObject();
            jo.Put("result", "success");
            return jo;
        }

        protected bool ExactOne(params object[] args)
        {
            bool flag = false;
            foreach (var o in args)
            {
                if (null != o)
                {
                    if (flag)
                    {
                        flag = false;
                        break;
                    }
                    flag = true;
                }
            }

            return flag;
        }

        protected static string GetTimeFormat(long seconds)
        {
            long minutes = seconds / 60;
            seconds -= minutes * 60;
            long hours = minutes / 60;
            minutes -= hours * 60;

            return string.Format("{0:00}:{1:00}:{2:00}", hours, minutes, seconds);
        }

        public const string DATE_FORMAT = "yyyy-MM-dd";
        public const string DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm";

        public static void CreateWorkbook(String filePath, DataSet dataset)
        {
            if (dataset.Tables.Count == 0)
                throw new ArgumentException("DataSet needs to have at least one DataTable", "dataset");

            var workbook = new Workbook();
            foreach (DataTable dt in dataset.Tables)
            {
                var worksheet = new Worksheet(dt.TableName);
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    // Add column header
                    worksheet.Cells[0, i] = new Cell(dt.Columns[i].ColumnName);

                    // Populate row data
                    for (int j = 0; j < dt.Rows.Count; j++)
                        worksheet.Cells[j + 1, i] = CreateCell(dt, j, i);

                    //if (0 == i)
                    {

                        // Append cells to 100
                        for (int j = dt.Rows.Count; j < 100; j++)
                            worksheet.Cells[j + 1, i] = new Cell("");
                    }
                }

                workbook.Worksheets.Add(worksheet);
            }
            workbook.Save(filePath);
        }

        private static Cell CreateCell(DataTable dt, int j, int i)
        {
            return new Cell(dt.Rows[j][i] == DBNull.Value ? "" : GetCellValue(dt, j, i));
        }

        private static object GetCellValue(DataTable dt, int j, int i)
        {
            object result = dt.Rows[j][i];
            if (result is long)
            {
                return result.ToString();
            }

            return result;
        }
    }
}