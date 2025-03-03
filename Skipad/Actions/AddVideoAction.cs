using System;
using System.IO;
using System.Linq;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Common.Errors;
using Inqwise.Skipad.Dal;
using Inqwise.Skipad.Managers;
using Inqwise.Skipad.SystemFramework;
using Inqwise.Skipad.SystemFramework.FileTypeDetective;
using Inqwise.Skipad.SystemFramework.VideoEncoder;
using NLog;

namespace Inqwise.Skipad.Actions
{
    public class AddVideoAction : AddResourceFileAction
    {
        private static readonly Logger Log = LogManager.GetCurrentClassLogger();
        private string _fileName;
        
        public AddVideoAction(ResourceFileInfo file)
            : base(file)
        {
            
        }

        protected override void IdentifyDetails(ResourceFileInfo fileInfo)
        {
            var videoFile = new VideoFile(fileInfo.FilePath);
            Encoder.GetVideoInfo(videoFile);
            if (String.Empty == videoFile.VideoFormat)
            {
                fileInfo.Error = SkipadErrors.InvalidFormat;
            }
            else
            {
                fileInfo.Duration = videoFile.Duration;
                fileInfo.Width = videoFile.Width;
                fileInfo.Height = videoFile.Height;
                fileInfo.Format = videoFile.VideoFormat;
                fileInfo.BitRate = videoFile.BitRate;

                var fileMimeInfo = Detective.GetFileType(fileInfo.FilePath);
                if (null == fileMimeInfo || fileMimeInfo.MimeType != MimeType.Video)
                {
                    fileInfo.Error = SkipadErrors.InvalidFormat;
                }
                else
                {
                    fileInfo.ContentType = fileMimeInfo.Mime;
                    if (fileInfo.IsInternalHosting)
                    {
                        _fileName = GenerateFileName(fileInfo.Extension);
                    }
                    else
                    {
                        _fileName = GenerateFileName((System.IO.Path.GetExtension(fileInfo.FilePath) ?? "").TrimStart('.'));
                    }
                }
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
            return string.Format(VideoProcess.FILENAME_FORMAT, "v", FileInfo.Width, FileInfo.Height,
                                      FileInfo.BitRate, DateTime.Now.Ticks, extension);
        }

        private struct CreateResourceFileRequest : ICreateResourceFileRequest
        {
            public long? ResourceFileId { get; set; }
            public bool IsThumbnail { get; set; }
            public string Path { get; set; }
            public string ContentType { get; set; }
            public string Extension { get; set; }
            public int? Width { get; set; }
            public int? Height { get; set; }
            public double? Bitrate { get; set; }
            public ResourceFilePathType PathType { get; set; }
            public string Name { get; set; }
        }

        protected override void CollectAndSave(string username)
        {
            base.CollectAndSave(username);

            if (null == FileInfo.Error)
            {
                var thumbnailVideoFileName = FileName + Encoder.THUMBNAIL_SUFFIX;
                var thumbnailVideoFilePath = System.IO.Path.Combine(ResourcesManager.ResourcesFolder,
                                                                    Subfolder, thumbnailVideoFileName);

                // Create thumbnail
                var videoFile = new VideoFile(FileInfo.FilePath);
                Encoder.GetVideoThumbnail(videoFile, thumbnailVideoFilePath);

                // Save thumbnail to S3
                S3.Upload(File.OpenRead(thumbnailVideoFilePath), GetPath(Subfolder, thumbnailVideoFileName),
                          ImageProcess.JPEG_CONTENT_TYPE);

                var videoThumbnailFileResource = new CreateResourceFileRequest
                    {
                        ContentType = ImageProcess.JPEG_CONTENT_TYPE,
                        Extension = ImageProcess.JPEG_EXTENSION_NAME,
                        Path = GetPath(Subfolder, thumbnailVideoFileName),
                        PathType = ResourceFilePathType.Relative,
                        Height = FileInfo.Height.Value,
                        Width = FileInfo.Width.Value,
                        IsThumbnail = true,
                        ResourceFileId = FileInfo.ResourceFileId,
                        Name = FileInfo.Name,
                    };

                // Add file to exist resource;
                FileInfo.ResourceFileId = ResourcesDataAccess.AddFile(videoThumbnailFileResource,
                                                                               FileInfo.ResourceId.Value,
                                                                               username);

                FileInfo.ThumbnailUrl = ResourcesManager.GetResourceUrl(GetPath(Subfolder, thumbnailVideoFileName),
                                                                   ResourceFilePathType.Relative);
            }
        }
    }
}