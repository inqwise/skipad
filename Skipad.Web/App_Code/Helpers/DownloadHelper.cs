using System;
using System.IO;
using System.Linq;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Common.Errors;
using Inqwise.Skipad.SystemFramework;

namespace Helpers
{
    public class DownloadHelper
    {
        public string FileNamePrefix { get; private set; }
        public string DownloadDir { get; set; }
        public int MaxFileSize { get; set; }
        public int MinFileSize { get; set; }

        public DownloadHelper(string downloadDir)
        {
            this.FileNamePrefix = string.Format("{0:x2}", DateTime.Now.Ticks);
            DownloadDir = downloadDir;

            this.MaxFileSize = -1;
            this.MinFileSize = 1;
        }

        
        public bool Validate(ResourceFileInfo file)
        {
            if (String.IsNullOrEmpty(file.Name))
            {
                file.Error = SkipadErrors.MissingFileName;
                return false;
            }

            if (file.Name.IndexOfAny(Path.GetInvalidFileNameChars()) != -1)
            {
                file.Error = SkipadErrors.InvalidFileName;
                return false;
            }

            if (this.MaxFileSize > 0 && (file.Size > this.MaxFileSize))
            {
                file.Error = SkipadErrors.MaxFileSize;
                return false;
            }

            if (this.MinFileSize > 1 && (file.Size < this.MinFileSize))
            {
                file.Error = SkipadErrors.MinFileSize;
                return false;
            }

            return true;
        }

        public void FileUploadHandle(ResourceFileInfo file)
        {
            var uri = new Uri(file.Url);
            var name = uri.Segments.Last();
            file.Name = name;
            file.FilePath = DownloadDir + FileNamePrefix + name;
            
            long bytesReceived;
            if (HttpUtils.DownloadFile(file.Url, file.FilePath, out bytesReceived))
            {
                file.Size = bytesReceived;
            }
            else
            {
                file.Error = SkipadErrors.InvalidUrl;
            }

            if (!file.HasError)
            {
                Validate(file);
            }

            if (file.HasError && File.Exists(file.FilePath))
            {
                try
                {
                    File.Delete(file.FilePath);
                }
                catch (Exception)
                {}
            }
        }
    }
}