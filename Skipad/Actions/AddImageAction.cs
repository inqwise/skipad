using System;
using System.Drawing;
using System.Drawing.Imaging;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Common.Errors;
using Inqwise.Skipad.SystemFramework;

namespace Inqwise.Skipad.Actions
{
    public class AddImageAction : AddResourceFileAction
    {
        private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();

        private string _fileName;

        public AddImageAction(ResourceFileInfo file) : base(file)
        {
            
        }

        protected override void IdentifyDetails(ResourceFileInfo fileInfo)
        {
            try
            {
                using (Image image = Image.FromFile(fileInfo.FilePath))
                {
                    fileInfo.Width = image.Width;
                    fileInfo.Height = image.Height;
                    fileInfo.Format = GetMimeType(image);
                    fileInfo.ContentType = ImageProcess.JPEG_CONTENT_TYPE;
                }

            }
            catch (Exception ex)
            {
                Log.ErrorException("IdentifyImageDetails : Unexpected error occured", ex);
                fileInfo.Error = SkipadErrors.InvalidFormat;
            }
        }

        protected override string FileName
        {
            get
            {
                if (null == _fileName)
                {
                    _fileName = string.Format(ImageProcess.FILENAME_FORMAT, "i", FileInfo.Width, FileInfo.Height, DateTime.Now.Ticks, ImageProcess.JPEG_EXTENSION_NAME);
                }

                return _fileName;
            }
        }

        public static string GetMimeType(Image i)
        {
            var imgguid = i.RawFormat.Guid;
            foreach (ImageCodecInfo codec in ImageCodecInfo.GetImageDecoders())
            {
                if (codec.FormatID == imgguid)
                    return codec.MimeType;
            }
            return "image/unknown";
        }

        protected override void CollectAndSave(string username)
        {
            base.CollectAndSave(username);
            FileInfo.ThumbnailUrl = FileInfo.Url;
        }
    }
}