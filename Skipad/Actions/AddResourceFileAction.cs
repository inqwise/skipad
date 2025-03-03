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

namespace Inqwise.Skipad.Actions
{
    public abstract class AddResourceFileAction : ICreateResourceFileRequest
    {
        protected static AmazonHelper S3 = new AmazonHelper();
        private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();
        protected ResourceFileInfo FileInfo { get; private set; }
        protected string Subfolder { get; private set; }
        private string _path;
        protected readonly Encoder Encoder = VideoProcess.GetEncoder();

        protected AddResourceFileAction(ResourceFileInfo file)
        {
            FileInfo = file;
        }

        public static AddResourceFileAction GetAction(ResourceFileInfo file)
        {
            switch (file.ResourceType)
            {
                case ResourceType.Video:
                    return new AddVideoAction(file);
                    
                case ResourceType.Image:
                    return new AddImageAction(file);

                case ResourceType.Audio:
                    return new AddAudioAction(file);

                default:
                    throw new ArgumentOutOfRangeException("file.ResourceType", file.ResourceType, "Unsupported ResourceType");
            }
        }

        protected abstract void IdentifyDetails(ResourceFileInfo fileInfo);
        //protected abstract void PreOperations();

        protected abstract string FileName { get; }

        public ResourceFileInfo Process(string username)
        {
            bool rollback = false;
            
            try
            {
                IdentifyDetails(FileInfo);
                
                CollectAndSave(username);
            }
            catch (Exception ex)
            {
                Log.ErrorException("Process : Unexpected error occured", ex);
                rollback = true;
                FileInfo.Error = SkipadErrors.GeneralError;
            }

            if (rollback) // ResourceFile not created
            {
                Rollback();
            }

            return FileInfo;
        }

        protected virtual void CollectAndSave(string username)
        {
            IResource resource;
            if (null == FileInfo.Error)
            {
                if (FileInfo.ResourceId.HasValue)
                {
                    resource = ResourcesManager.Get(FileInfo.ResourceId.Value, username);
                    if (null == resource)
                    {
                        Log.Warn("Process : Unable to find resource # {0} for username '{1}'", FileInfo.ResourceId, username);
                        FileInfo.Error = SkipadErrors.ResourceNotFound;
                    }
                    else
                    {
                        Subfolder = resource.FolderName;
                    }
                }

                if (null == Subfolder)
                {
                    Subfolder = Guid.NewGuid().ToString();
                }
            }

            if (null == FileInfo.Error)
            {
                var filePath = System.IO.Path.Combine(ResourcesManager.ResourcesFolder, Subfolder, FileName);
                // Move file
                var folder = System.IO.Path.Combine(ResourcesManager.ResourcesFolder, Subfolder);
                if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                File.Move(FileInfo.FilePath, filePath);
                FileInfo.FilePath = filePath;

                if (FileInfo.IsInternalHosting)
                {
                    // Save to S3
                    S3.Upload(File.OpenRead(FileInfo.FilePath), GetPath(Subfolder, FileName), FileInfo.ContentType);
                    FileInfo.Url = ResourcesManager.GetResourceUrl(GetPath(Subfolder, FileName),
                                                                   ResourceFilePathType.Relative);
                    FileInfo.PathType = ResourceFilePathType.Relative;
                    _path = GetPath(Subfolder, FileName);
                }
                else
                {
                    FileInfo.Url = ResourcesManager.GetResourceUrl(FileInfo.Url,
                                                                   ResourceFilePathType.Absolute);

                    FileInfo.PathType = ResourceFilePathType.Absolute;
                    _path = FileInfo.Url;
                }
            }

            if (null == FileInfo.Error)
            {
                if (FileInfo.ResourceId.HasValue)
                {
                    // Add file to exist resource;
                    FileInfo.ResourceFileId = ResourcesDataAccess.AddFile(this, FileInfo.ResourceId.Value, username);
                }
                else
                {
                    FileInfo.ResourceId = ResourcesDataAccess.Insert(FileInfo.Name, null, username,
                                                                     FileInfo.ResourceType, FileInfo.Duration,
                                                                     Subfolder, FileInfo.ResourceRole);

                    var resourceFileId = ResourcesDataAccess.AddFile(this, FileInfo.ResourceId.Value, username);
                    //resource = ResourcesManager.Get(FileInfo.ResourceId.Value, username);
                    FileInfo.ResourceFileId = resourceFileId;
                }
            }
        }

        protected virtual void Rollback()
        {
            if (FileInfo.ResourceFileId == 0)
            {
                // Rollback
                if (FileInfo.IsInternalHosting)
                {
                    try
                    {
                        // Delete from S3
                        S3.Delete(GetPath(Subfolder, FileName));
                    }
                    catch (Exception ex)
                    {
                        Log.ErrorException("Process : Failed to delete file from S3", ex);
                    }

                    File.Delete(FileInfo.FilePath);
                }
            }
        }

        protected static string GetPath(string subfolder, string fileName)
        {
            return subfolder + "/" + fileName;
        }

        public long? ResourceFileId
        {
            get { return null; }
        }

        public bool IsThumbnail
        {
            get { return false; }
        }

        public string Path
        {
            get { return _path; }
        }

        public string ContentType 
        {
            get { return FileInfo.ContentType; }
        }

        public string Extension {
            get { return FileInfo.Extension; }
        }
        
        public int? Width {
            get { return FileInfo.Width; }
        }
        
        public int? Height {
            get { return FileInfo.Height; }
        }

        public double? Bitrate {
            get { return FileInfo.BitRate; }
        }
        
        public ResourceFilePathType PathType {
            get { return FileInfo.PathType; }
        }

        public string Name {
            get { return FileInfo.Name; }
        }
    }
}