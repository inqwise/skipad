using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using Inqwise.Skipad.Actions;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Dal;
using Inqwise.Skipad.Entities;
using Inqwise.Skipad.SystemFramework;

namespace Inqwise.Skipad.Managers
{
    public class ResourcesManager
    {
        private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();

        private static AmazonHelper S3 = new AmazonHelper();
        
        private static readonly Lazy<IEnumerable<Tuple<int,int,int>>> _transforms = new Lazy<IEnumerable<Tuple<int,int,int>>>(GetTransformsConfig);

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

        public static string GetResourceUrl(string path, ResourceFilePathType pathType)
        {
            return ResourceFile.GetResourceUrl(path, pathType);
        }

        private static IEnumerable<Tuple<int, int, int>> GetTransformsConfig()
        {
            string[] strTransformsArr = ConfigurationManager.AppSettings["Transforms"].Split(';');
            var list = new List<Tuple<int, int, int>>();
            foreach (var strTransform in strTransformsArr)
            {
                string[] strTransformItems = strTransform.Split('x');
                int width = int.Parse(strTransformItems[0]);
                int height = int.Parse(strTransformItems[1]);
                int bitrate = int.Parse(strTransformItems[2]);

                list.Add(new Tuple<int, int, int>(width, height, bitrate));
            }

            return list;
        }

        public static IEnumerable<Tuple<int, int, int>> Transforms
        {
            get { return _transforms.Value; }
        }

        public static string ResourcesFolder
        {
            get { return ResourceFile.ResourcesFolder; }
        }

        private static readonly Lazy<string> _skipRollPreviewUrl = new Lazy<string>(() => ConfigurationManager.AppSettings["SkipRollPreviewUrl"]);

        public static string SkipRollPreviewUrl
        {
            get { return _skipRollPreviewUrl.Value; }
        }

        private static readonly Lazy<string> _skipRollMraidPreviewUrl = new Lazy<string>(() => ConfigurationManager.AppSettings["SkipRollMraidPreviewUrl"]);

        public static string SkipRollMraidPreviewUrl
        {
            get { return _skipRollMraidPreviewUrl.Value; }
        }


        public static List<IResource> GetMeny(string username, ResourceType? resourceType = null)
        {
            var reader = ResourcesDataAccess.GetMenyDataReader(username, resourceType);
            var list = new List<IResource>();
            var resourcesSet = new Dictionary<long, Resource>();

            while (reader.Read())
            {
                var resource = new Resource(reader);
                list.Add(resource);
                resourcesSet.Add(resource.Id, resource);
            }

            // resourceFiles
            if (reader.NextResult())
            {
                while (reader.Read())
                {
                    var resourceFile = new ResourceFile(reader);
                    try
                    {
                        resourcesSet[resourceFile.ResourceId].AddResourceFile(resourceFile);
                    }
                    catch (Exception ex)
                    {
                        throw new Exception(string.Format("GetMeny: Failed to add resourceFile #{0} to resource #{1}", resourceFile.Id, resourceFile.ResourceId), ex);
                    }
                }
            }

            return list;
        }

        public static void Delete(long id, string username)
        {
            ResourcesDataAccess.Delete(id, username);
        }

        public static void Modify(long id, string name, string description, string username)
        {
            ResourcesDataAccess.Update(id, name, description, username);
        }

        /*
        public static long GenerateAndCreateImage(string resourceName, string filePath, string username, string outputFolder, string subfolder)
        {
            var imageProcess = new ImageProcess(filePath, "i");
            imageProcess.Crop();

            var resourceFileRequests = new List<ICreateResourceFileRequest>();
            foreach (var transform in Transforms)
            {
                var processResult = imageProcess.ConvertAndSaveAsJpeg(transform, Path.Combine(outputFolder, subfolder));
                var createResourceFileRequest = new CreateResourceFileRequest
                    {
                        ContentType = processResult.ContentType,
                        Extension = processResult.Extension,
                        Path = GetPath(subfolder, processResult.FileName),
                        Height = processResult.Height,
                        Width = processResult.Width,
                        PathType = ResourceFilePathType.Relative,
                        IsThumbnail = false,
                        Name = processResult.FileName, 
                    };
                resourceFileRequests.Add(createResourceFileRequest);

                // Save to S3
                S3.Upload(File.OpenRead(processResult.Path), createResourceFileRequest.Path, processResult.ContentType);
            }

            // create in db
            return Create(resourceName, null, username, ResourceType.Image, null, resourceFileRequests, subfolder);
        }

        public static long CreateVideoResource(string username, string tempFolder, string outputFolder, string subfolder, IEnumerable<string> urls, out long thumbnailResourceId)
        {
            var videoFileRequests = new List<ICreateResourceFileRequest>();
            var thumbFileRequests = new List<ICreateResourceFileRequest>();
            var enc = VideoProcess.GetEncoder();
            TimeSpan? duration = null;
            String originalFileName = null;

            foreach (var url in urls)
            {
                var localTmpFilePath = Path.Combine(tempFolder, Guid.NewGuid().ToString() + "." + VideoProcess.MP4_EXTENSION_NAME);
                long size;
                if (HttpUtils.DownloadFile(url, localTmpFilePath, out size) && size > 0)
                {
                    try
                    {
                        if (null == originalFileName)
                        {
                            var uri = new Uri(url);
                            originalFileName = uri.Segments.Last();
                        }

                        var videoFile = new VideoFile(localTmpFilePath);
                        enc.GetVideoInfo(videoFile);

                        if (videoFile.VideoFormat == string.Empty)
                        {
                            throw new InvalidOperationException("Unsupported video file");
                        }

                        var videoFileName = string.Format(VideoProcess.FILENAME_FORMAT, "v", videoFile.Width, videoFile.Height, videoFile.BitRate, DateTime.Now.Ticks, VideoProcess.MP4_EXTENSION_NAME);
                        var videoFilePath = Path.Combine(outputFolder, subfolder, videoFileName);
                        // Copy video
                        File.Move(localTmpFilePath, videoFilePath);

                        var thumbnailVideoFileName = videoFileName + Encoder.THUMBNAIL_SUFFIX;
                        var thumbnailVideoFilePath = Path.Combine(outputFolder, subfolder, thumbnailVideoFileName);

                        // Create thumbnail
                        videoFile.Path = videoFilePath;
                        enc.GetVideoThumbnail(videoFile, thumbnailVideoFilePath);

                        // Save thumbnail to S3
                        S3.Upload(File.OpenRead(thumbnailVideoFilePath), GetPath(subfolder, thumbnailVideoFileName), ImageProcess.JPEG_CONTENT_TYPE);

                        if (null == duration)
                        {
                            duration = videoFile.Duration;
                        }

                        videoFileRequests.Add(new CreateResourceFileRequest
                        {
                            ContentType = VideoProcess.MP4_CONTENT_TYPE,
                            Extension = VideoProcess.MP4_EXTENSION_NAME,
                            Path = url,
                            PathType = ResourceFilePathType.Absolute,
                            Height = videoFile.Height,
                            Width = videoFile.Width,
                            Bitrate = Convert.ToInt32(videoFile.BitRate),
                        });

                        // Thumbnail
                        thumbFileRequests.Add(new CreateResourceFileRequest
                        {
                            ContentType = ImageProcess.JPEG_CONTENT_TYPE,
                            Extension = ImageProcess.JPEG_EXTENSION_NAME,
                            Path = GetPath(subfolder, thumbnailVideoFileName),
                            PathType = ResourceFilePathType.Relative,
                            Height = videoFile.Height,
                            Width = videoFile.Width,
                        });
                    }
                    finally
                    {
                        // Delete the temporary file
                        try
                        {
                            if (File.Exists(localTmpFilePath))
                            {
                                File.Delete(localTmpFilePath); 
                            }
                        }
                        catch{}
                    }
                }
            }

            // Create video thumbnail Resource
            thumbnailResourceId = Create(originalFileName + Encoder.THUMBNAIL_SUFFIX, null, username, ResourceType.VideoThumbnail, null, thumbFileRequests, subfolder);

            // Create video Resource
            return Create(originalFileName, null, username, ResourceType.Video, duration, videoFileRequests, subfolder);
        }
        
        public static long GenerateAndCreateVideo(string resourceName, string filePath, string username, string outputFolder, string subfolder, out long thumbnailResourceId)
        {
            var videoProcess = new VideoProcess(filePath, "v");

            var videoResourceFileRequests = new List<ICreateResourceFileRequest>();
            var thumbnailResourceFileRequests = new List<ICreateResourceFileRequest>();

            TimeSpan? duration = null;

            foreach (var transform in Transforms)
            {
                var transformResult = videoProcess.ConvertAndSaveMp4(transform, Path.Combine(outputFolder, subfolder));

                if (null == duration)
                {
                    duration = transformResult.Duration;
                }

                var videoFileResource = new CreateResourceFileRequest
                    {
                        ContentType = transformResult.ContentType,
                        Extension = transformResult.Extension,
                        Path = GetPath(subfolder, transformResult.FileName),
                        PathType = ResourceFilePathType.Relative,
                        Height = transformResult.Height,
                        Width = transformResult.Width,
                        Bitrate = transformResult.Bitrate,
                    };

                videoResourceFileRequests.Add(videoFileResource);

                // Save video to S3
                S3.Upload(File.OpenRead(transformResult.Path), videoFileResource.Path, VideoProcess.MP4_CONTENT_TYPE);

                var videoThumbnailFileResurce = new CreateResourceFileRequest
                    {
                        ContentType = ImageProcess.JPEG_CONTENT_TYPE,
                        Extension = ImageProcess.JPEG_EXTENSION_NAME,
                        Path = GetPath(subfolder, Path.GetFileName(transformResult.ThumbnailPath)),
                        PathType = ResourceFilePathType.Relative,
                        Height = transformResult.Height,
                        Width = transformResult.Width,
                    };

                thumbnailResourceFileRequests.Add(videoThumbnailFileResurce);

                // Save thumbnail to S3
                S3.Upload(File.OpenRead(transformResult.ThumbnailPath), videoThumbnailFileResurce.Path, ImageProcess.JPEG_CONTENT_TYPE);
            }

            // create video thumbnail resource in db
            thumbnailResourceId = Create(resourceName, null, username, ResourceType.VideoThumbnail, null, thumbnailResourceFileRequests, subfolder);

            // create video resource in db
            return Create(resourceName, null, username, ResourceType.Video, duration, videoResourceFileRequests, subfolder);
        }
        */

        private static string GetPath(string subfolder, string fileName)
        {
            return subfolder + "/" + fileName;
        }

        /*
        public static long Create(string name, string description, string username, ResourceType resourceType, TimeSpan? duration, IEnumerable<ICreateResourceFileRequest> resourceFiles, string workFolder)
        {
            return ResourcesDataAccess.Insert(name, description, username, resourceType, duration, resourceFiles, workFolder);
        }
         */

        public static IResource Get(long id, string username)
        {
            var reader = ResourcesDataAccess.GetDataReader(id, username);
            Resource resource = null;

            if (reader.Read())
            {
                resource = new Resource(reader);
            }

            // resourceFiles
            if (reader.NextResult())
            {
                while (reader.Read())
                {
                    var resourceFile = new ResourceFile(reader);
                    resource.AddResourceFile(resourceFile);
                }
            }

            return resource;
        }

        public static string GetResourceUrl(IResourceFile resourceFile)
        {
            if (null == resourceFile) return null;

            return ResourceFile.GetResourceUrl(resourceFile.Path, resourceFile.PathType);
        }

        public static string GetResourceThumbUrl(IResourceFile resourceFile)
        {
            IResourceFile thumb = null;
            if (null != resourceFile && null != resourceFile.Resource && resourceFile.Resource.Any())
            {
                var firstOrDefault = resourceFile.Resource.FirstOrDefault(f => null != f.Thumbnail);
                if (firstOrDefault != null)
                {
                    thumb = (firstOrDefault.Thumbnail);
                }
            }

            if (null == thumb)
            {
                return null;
            }
            return GetResourceUrl(thumb);
        }

        private static readonly Lazy<string> TagBaseUrl = new Lazy<string>(() => ConfigurationManager.AppSettings["TagUrl"]);

        public static string GetTagUrl(string auid, OutputType outputType = OutputType.Vast, string version = null)
        {
            var sb = new StringBuilder();
            sb.AppendFormat("{0}?auid={1}&otp={2}", TagBaseUrl.Value, auid, outputType.ToString().ToLower());
            if (null != version)
            {
                sb.AppendFormat("&ver={0}", version);
            }
            return sb.ToString();
        }

        public static void AddFile(ResourceFileInfo fileInfo, string username)
        {
            var action = AddResourceFileAction.GetAction(fileInfo);
            action.Process(username);
        }

        public static void DeleteFiles(IEnumerable<long> ids, string userName)
        {
            var pathList = ResourcesDataAccess.DeleteFiles(ids, userName);
            foreach (var releaivePath in pathList)
            {
                var internalPath = Path.Combine(ResourcesFolder, releaivePath);
                try
                {
                    if (File.Exists(internalPath)) File.Delete(internalPath);
                }
                catch (Exception ex)
                {
                    Log.WarnException("DeleteFiles: Failed to delete local file " + internalPath, ex);
                }

                try
                {
                    S3.Delete(releaivePath);
                }
                catch (Exception ex)
                {
                    Log.WarnException("DeleteFiles: Failed to delete S3 file " + releaivePath, ex);
                }
            }
        }

        public static void MakeVariousSizes(long resourceId, string username, long? sizeFromResourceId)
        {
            var resource = Get(resourceId, username);
            var sizeFromResource = (null == sizeFromResourceId ? null : Get(sizeFromResourceId.Value, username));
            if (null != resource)
            {
                switch (resource.ResourceType)
                {
                    case ResourceType.Image:
                        MakeVariousSizesImage(resource, username, sizeFromResource);
                        break;
                    default:
                        throw new ArgumentOutOfRangeException();
                }
            }
            
        }

        private static void MakeVariousSizesImage(IResource resource, string usernsame, IResource sizeFromResource)
        {
            var maxSizeResourceFile = resource.OrderBy(r => r.Width).LastOrDefault(r => r.PathType == ResourceFilePathType.Relative);

            if (null != maxSizeResourceFile)
            {
                IEnumerable<Tuple<int, int, int>> transformParamses;
                if (null == sizeFromResource)
                {
                    transformParamses = GetTransformsConfig();
                }
                else
                {
                    transformParamses = sizeFromResource.Select(r => new Tuple<int, int, int>(r.Width.Value, r.Height.Value, 0)).Distinct();
                }

                foreach (var transformParams in transformParamses)
                {
                    if (!resource.Any(f => f.Width == transformParams.Item1 && f.Height == transformParams.Item2))
                    {
                        MakeImage(resource, usernsame, maxSizeResourceFile, transformParams);
                    }
                }
            }
        }

        private static void MakeImage(IResource resource, string usernsame, IResourceFile maxSizeResourceFile,
                                      Tuple<int, int, int> transformParams)
        {
            var filePath = Path.Combine(ResourcesFolder, maxSizeResourceFile.Path);
            var imageProcess = new ImageProcess(filePath, "i");


            // Create
            var processResult = imageProcess.ConvertAndSaveAsJpeg(transformParams,
                                                                  Path.Combine(ResourcesFolder,
                                                                               resource.FolderName));

            var createResourceFileRequest = new CreateResourceFileRequest
                {
                    ContentType = processResult.ContentType,
                    Extension = processResult.Extension,
                    Path = GetPath(resource.FolderName, processResult.FileName),
                    Height = processResult.Height,
                    Width = processResult.Width,
                    PathType = ResourceFilePathType.Relative,
                    IsThumbnail = false,
                    Name = processResult.FileName,
                };

            bool addedToS3 = false;
            try
            {
                // Save to S3
                S3.Upload(File.OpenRead(processResult.Path), createResourceFileRequest.Path,
                          processResult.ContentType);

                addedToS3 = true;

                // Insert To DB
                ResourcesDataAccess.AddFile(createResourceFileRequest, resource.Id, usernsame);
            }
            catch (Exception)
            {
                try
                {
                    File.Delete(Path.Combine(ResourcesFolder, resource.FolderName));
                }
                catch (Exception ex)
                {
                    Log.WarnException(
                        "MakeVariousSizesImage : Failed to delete file after Unexpected error. " + resource.FolderName, ex);
                }

                if (addedToS3)
                {
                    try
                    {
                        S3.Delete(GetPath(resource.FolderName, processResult.FileName));
                    }
                    catch (Exception ex)
                    {
                        Log.WarnException(
                            "MakeVariousSizesImage : Failed to delete  S3 file after Unexpected error. " + resource.FolderName,
                            ex);
                    }
                }

                throw;
            }
        }
    }
}