using System;
using System.Configuration;
using System.Data;
using Jayrock.Json;
using Inqwise.Skipad.Common;

namespace Inqwise.Skipad.Entities
{
    public class ResourceFile : IResourceFile
    {
        private static readonly Lazy<string> _resourcesFolder = new Lazy<string>(() => ConfigurationManager.AppSettings["ResourcesFolder"]);

        public static string ResourcesFolder
        {
            get { return _resourcesFolder.Value; }
        }

        private static readonly Lazy<string> ResourcesUrl = new Lazy<string>(() => ConfigurationManager.AppSettings["ResourcesUrl"]);
        public static string GetResourceUrl(IResourceFile resourceFile)
        {
            return GetResourceUrl(resourceFile.Path, resourceFile.PathType);
        }

        public static string GetResourceUrl(string path, ResourceFilePathType pathType)
        {
            if (pathType == ResourceFilePathType.Absolute)
            {
                return path;
            }
            return ResourcesUrl.Value + path;
        }

        public static class ColumnNames
        {
            public const string PathTypeId = "PathTypeId";
            public const string ResourceFileId = "ResourceFileId";
            public const string Path = "Path";
            public const string ContentType = "ContentType";
            public const string Width = "Width";
            public const string Height = "Height";
            public const string Bitrate = "Bitrate";
            public const string Extension = "Extension";
            public const string InsertDate = "InsertDate";
            public const string ResourceId = "ResourceId";
            public const string Name = "ResourceFileName";
            public const string IsThumbnail = "IsThumbnail";
        }

        public ResourceFile(IDataReader reader)
        {
            Id = Convert.ToInt64(reader[ColumnNames.ResourceFileId]);
            Path = Convert.ToString(reader[ColumnNames.Path]);
            ContentType = Convert.ToString(reader[ColumnNames.ContentType]);
            Width = Convert.IsDBNull(reader[ColumnNames.Width]) ? null : Convert.ToInt32(reader[ColumnNames.Width]) as int?;
            Height = Convert.IsDBNull(reader[ColumnNames.Height]) ? null : Convert.ToInt32(reader[ColumnNames.Height]) as int?;
            Bitrate = Convert.IsDBNull(reader[ColumnNames.Bitrate]) ? null : Convert.ToInt32(reader[ColumnNames.Bitrate]) as int?;
            Extension = reader[ColumnNames.Extension].ToString();
            InsertDate = Convert.ToDateTime(reader[ColumnNames.InsertDate]);
            ResourceId = Convert.ToInt64(reader[ColumnNames.ResourceId]);
            PathType = (ResourceFilePathType)Convert.ToInt32(reader[ColumnNames.PathTypeId]);
            Name = Convert.IsDBNull(reader[ColumnNames.Name])
                       ? System.IO.Path.GetFileName(Path)
                       : Convert.ToString(reader[ColumnNames.Name]);
            IsThumbnail = Convert.ToBoolean(reader[ColumnNames.IsThumbnail]);
        }

        public long ResourceId { get; private set; }
        public ResourceFilePathType PathType { get; private set; }
        public long Id { get; set; }
        public string Path { get; private set; }
        public string ContentType { get; private set; }
        public int? Width { get; private set; }
        public int? Height { get; private set; }
        public int? Bitrate { get; private set; }
        public string Extension { get; private set; }
        public DateTime InsertDate { get; private set; }
        public bool IsThumbnail { get; private set; }

        public IResource Resource { get; set; }
        public string Name { get; private set; }
        public IResourceFile Thumbnail { get; set; }

        public JsonObject ToJson()
        {
            var jo = new JsonObject();
            jo.Put("resourceFileId", Id);
            jo.Put("path", Path);
            jo.Put("contentType", ContentType);
            jo.Put("width", Width);
            jo.Put("height", Height);
            if (Bitrate.HasValue)
            {
                jo.Put("bitrate", Bitrate);
            }

            jo.Put("insertDate", InsertDate.ToString("dd-MMM-yyyy HH:mm:ss"));
            jo.Put("extension", Extension);
            jo.Put("name", Name);
            jo.Put("url", GetResourceUrl(this));
            if (null != Thumbnail)
            {
                jo.Put("thumbnailUrl", GetResourceUrl(Thumbnail));
            }

            return jo;
        }
    }
}