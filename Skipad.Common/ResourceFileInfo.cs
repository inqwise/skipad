using System;
using System.IO;
using Inqwise.Skipad.Common.Errors;

namespace Inqwise.Skipad.Common
{
    public class ResourceFileInfo
    {
        public string Url { get; set; }
        public string Name { get; set; }
        public long Size { get; set; }
        public string FilePath { get; set; }
        public ResourceType ResourceType { get; set; }

        public long? ResourceId { get; set; }
        public SkipadErrors? Error { get; set; }
        public bool HasError {
            get { return Error.HasValue; }
        }

        public TimeSpan? Duration { get; set; }

        public int? Width { get; set; }

        public int? Height { get; set; }

        public string Format { get; set; }

        public double? BitRate { get; set; }

        public bool IsInternalHosting { get; set; }

        public string ContentType { get; set; }

        public long ResourceFileId { get; set; }

        public string Extension {
            get { return Path.GetExtension(FilePath); }
        }

        public string ThumbnailUrl { get; set; }

        public ResourceFilePathType PathType { get; set; }

        public ResourceRole ResourceRole { get; set; }
    }
}