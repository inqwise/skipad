using System;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Common.Errors;
using Inqwise.Skipad.SystemFramework.FileTypeDetective;
using Inqwise.Skipad.SystemFramework.VideoEncoder;

namespace Inqwise.Skipad.Actions
{
    public class AddAudioAction : AddResourceFileAction
    {
        public const string FILENAME_FORMAT = "{0}_{1}x{2:x2}.{3}"; //{namePrefix}_{bitrate}x{timestamp}.{extension}
        public const string MP3_EXTENSION_NAME = "mp3";
        public const string MP3_CONTENT_TYPE = "audio/mpeg";

        private string _fileName;

        public AddAudioAction(ResourceFileInfo file) : base(file)
        {
        }

        protected override void IdentifyDetails(ResourceFileInfo fileInfo)
        {
            var audioFile = new AudioFile(fileInfo.FilePath);
            Encoder.GetAudioInfo(audioFile);
            if (String.Empty == audioFile.AudioFormat)
            {
                fileInfo.Error = SkipadErrors.InvalidFormat;
            }
            else
            {
                fileInfo.Duration = audioFile.Duration;
                fileInfo.Format = audioFile.AudioFormat;
                fileInfo.BitRate = audioFile.BitRate;

                /*
                var fileMimeInfo = Detective.GetFileType(fileInfo.FilePath);
                if (null == fileMimeInfo || fileMimeInfo.MimeType != MimeType.Audio)
                {
                    fileInfo.Error = SkipadErrors.InvalidFormat;
                }
                else
                {*/
                    //fileInfo.ContentType = fileMimeInfo.Mime;
                    fileInfo.ContentType = MP3_CONTENT_TYPE;
                    if (fileInfo.IsInternalHosting)
                    {
                        _fileName = GenerateFileName(fileInfo.Extension.TrimStart('.'));
                    }
                    else
                    {
                        _fileName = GenerateFileName((System.IO.Path.GetExtension(fileInfo.FilePath) ?? "").TrimStart('.'));
                    }
                //}
            }
        }

        protected override string FileName
        {
            get
            {
                if (null == _fileName)
                {
                    throw new InvalidOperationException("Filename not generated");
                }

                return _fileName;
            }
        }

        private string GenerateFileName(string extension)
        {
            return string.Format(FILENAME_FORMAT, "a", FileInfo.BitRate, DateTime.Now.Ticks, extension);
        }
    }
}