using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using Jayrock.Json;
using Inqwise.Skipad.Common;
using System.Linq;
using Inqwise.Skipad.Dal;

namespace Inqwise.Skipad.Entities
{
    public class Resource : IResource
    {
        private string _clickUrl;

        public static class ColumnNames
        {
            public const string FolderName = "PathFolder";
            public const string AdId = "Ads_Id";
            public const string ResourceId = "ResourceId";
            public const string ResourceTypeId = "ResourceTypeId";
            public const string InsertDate = "InsertDate";
            public const string ClickUrl = "ClickUrl";
            public const string Name = "ResourceName";
            public const string Description = "ResourceDesc";
            public const string Duration = "Duration";
            public const string RoleId = "ResourceRoleId";
        }

        public Resource(IDataReader reader)
        {
            Id = Convert.ToInt64(reader[ColumnNames.ResourceId]);
            ResourceType = (ResourceType) Convert.ToInt32(reader[ColumnNames.ResourceTypeId]);
            InsertDate = Convert.ToDateTime(reader[ColumnNames.InsertDate]);
            ClickUrl = reader.GetSchemaTable().AsEnumerable().Any(row => row[0].Equals(ColumnNames.ClickUrl)) ? reader[ColumnNames.ClickUrl].ToString() : null;
            AdId = reader.GetSchemaTable().AsEnumerable().Any(row => row[0].Equals(ColumnNames.AdId)) ? Convert.ToInt64(reader[ColumnNames.AdId]) as long? : null;
            Name = reader[ColumnNames.Name].ToString();
            Description = reader[ColumnNames.Description] as string;
            Duration = reader[ColumnNames.Duration] as TimeSpan?;
            FolderName = reader[ColumnNames.FolderName].ToString();
            Role = reader.GetSchemaTable().AsEnumerable().Any(row => row[0].Equals(ColumnNames.RoleId)) ? (ResourceRole)Convert.ToInt32(reader[ColumnNames.RoleId]) : ResourceRole.Undefined;

            Files = new List<ResourceFile>();
        }

        public long Id { get; private set; }
        public string Name { get; private set; }
        public string Description { get; private set; }
        public ResourceType ResourceType { get; private set; }
        public DateTime InsertDate { get; private set; }
        public string ClickUrl
        {
            get
            {
                if (null == AdId)
                {
                    throw new InvalidOperationException("ClickUrl available only for Ad referenced Resource");
                }
                return _clickUrl;
            }
            private set { _clickUrl = value; }
        }
        public TimeSpan? Duration { get; private set; }
        public string FolderName { get; private set; }
        public ResourceRole Role { get; private set; }

        public long? AdId { get; private set; }
        public List<ResourceFile> Files { get; private set; }
        public IResource Thumbnail { get; private set; }

        IEnumerable<IResourceFile> IResource.Files
        {
            get { return Files; }
        }

        public JsonObject ToJson()
        {
            var jo = new JsonObject();
            jo.Put("resourceId", Id);
            jo.Put("name", Name);
            if (null != Description)
            {
                jo.Put("description", Description); 
            }
            jo.Put("resourceTypeId", (int)ResourceType);
            jo.Put("insertDate", InsertDate.ToString("dd-MMM-yyyy HH:mm:ss"));

            if (AdId.HasValue) // Only for ad referenced resource
            {
                jo.Put("clickUrl", ClickUrl);
            }

            if (Duration.HasValue)
            {
                jo.Put("duration", Duration);
            }

            if (Role != ResourceRole.Undefined)
            {
                jo.Put("resourceRoleId", (int)Role);
            }

            jo.Put("files", GetFilesJson());

            return jo;
        }

        private JsonArray GetFilesJson()
        {
            var ja = new JsonArray();
            foreach (var resourceFile in Files)
            {
                ja.Add(resourceFile.ToJson());
            }

            return ja;
        }

        public void AddResourceFile(ResourceFile resourceFile)
        {
            if (null != Files)
            {
                if (resourceFile.IsThumbnail)
                {
                    Files.First(r => r.Id == resourceFile.Id).Thumbnail = resourceFile;
                }
                else
                {
                    Files.Add(resourceFile);
                }
                resourceFile.Resource = this; 
            }
        }

        public IEnumerator<IResourceFile> GetEnumerator()
        {
            return Files.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return Files.GetEnumerator();
        }

        public void SetThumbnail(IResource resource)
        {
            Thumbnail = resource;
        }

        public long Copy(string username)
        {
            var copyResourceId = ResourcesDataAccess.Insert(Name, Description, username, ResourceType, Duration, FolderName, Role);
            foreach (var resourceFile in Files)
            {
                ResourcesDataAccess.AddFile(resourceFile.Id, copyResourceId, username);
            }

            return copyResourceId;
        }
    }
}