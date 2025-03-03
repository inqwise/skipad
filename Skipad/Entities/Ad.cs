using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using Jayrock.Json;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Dal;

namespace Inqwise.Skipad.Entities
{
    public class Ad : IAd
    {
        public static class ColumnNames
        {
            public const string ModifyDate = "ModifyDate";
            public const string AdId = "Ads_Id";
            public const string AdName = "AdName";
            public const string Auid = "Auid";
            public const string CampaignId = "CampaignId";
            public const string CampaignName = "CampaignName";
            public const string Description = "AdDesc";
            public const string ExternalTagUrl = "ExternalTagURL";
            public const string SurveyUrl = "SurveyURL";
            public const string AdTypeId = "AdTypeId";
            public const string IsActive = "IsActive";
            public static string SkipTypeId = "SkipTypeId";
        }

        public Ad(IDataReader reader)
        {
            Id = Convert.ToInt32(reader[ColumnNames.AdId]);
            Name = Convert.ToString(reader[ColumnNames.AdName]);
            Auid = Convert.IsDBNull(reader[ColumnNames.Auid]) ? null : Guid.Parse(reader[ColumnNames.Auid].ToString()) as Guid?;
            CampaignId = Convert.ToInt32(reader[ColumnNames.CampaignId]);
            CampaignName = Convert.ToString(reader[ColumnNames.CampaignName]);
            Description = Convert.IsDBNull(reader[ColumnNames.Description]) ? null : reader[ColumnNames.Description].ToString();
            ModifyDate = Convert.ToDateTime(reader[ColumnNames.ModifyDate]);
            Resources = new List<IResource>();
            ExternalTagUrl = Convert.IsDBNull(reader[ColumnNames.ExternalTagUrl]) ? null : reader[ColumnNames.ExternalTagUrl].ToString();
            SurveyUrl = Convert.IsDBNull(reader[ColumnNames.SurveyUrl]) ? null : reader[ColumnNames.SurveyUrl].ToString();
            AdType = (AdType)Convert.ToInt32(reader[ColumnNames.AdTypeId]);
            IsActive = Convert.ToBoolean(reader[ColumnNames.IsActive]);
            SkipType = Convert.IsDBNull(reader[ColumnNames.SkipTypeId]) ? SkipType.Slide : (SkipType)Convert.ToInt32(reader[ColumnNames.SkipTypeId]);
        }

        public long Id { get; set; }
        public string Name { get; private set; }
        public Guid? Auid { get; private set; }
        public int CampaignId { get; private set; }
        public IResource Video { get; private set; }
        public IResource Image { get; private set; }
        public string Description { get; private set; }
        public DateTime ModifyDate { get; private set; }
        public List<IResource> Resources { get; private set; }
        public string CampaignName { get; private set; }
        public IResource VideoThumbnail { get; private set; }
        public string ExternalTagUrl { get; private set; }
        public string SurveyUrl { get; private set; }
        public AdType AdType { get; private set; }
        public IResource Audio { get; private set; }
        public bool IsActive { get; private set; }
        public SkipType SkipType { get; private set; }

        public long Copy(string name, string username)
        {
            //Dictionary<long, string> resourceClickUrls = Resources.Select(r => new KeyValuePair<long, string>(r.Id, r.ClickUrl)).ToDictionary(t => t.Key, t => t.Value);
            var resourceClickUrls = new Dictionary<long,string>();
            foreach (var resource in Resources)
            {
                var copyResourceId = resource.Copy(username);
                resourceClickUrls.Add(copyResourceId, resource.ClickUrl);
            }

            return AdsDataAccess.Insert(name, CampaignId, resourceClickUrls, username, null, null, null, AdType, SkipType);
        }

        IEnumerable<IResource> IAd.Resources
        {
            get { return Resources; }
        }

        public JsonObject ToJson()
        {
            var jo = new JsonObject();
            jo.Put("adId", Id);
            jo.Put("adName", Name);
            jo.Put("auid", Auid);
            jo.Put("campaignId", CampaignId);
            jo.Put("campaignName", CampaignName);
            jo.Put("adDescription", Description);
            jo.Put("modifyDate", ModifyDate.ToString("dd-MMM-yyyy HH:mm:ss"));
            jo.Put("resources", GetResourcesJson());
            jo.Put("externalTagUrl", ExternalTagUrl);
            jo.Put("surveyUrl", SurveyUrl);
            jo.Put("adTypeId", (int)AdType);
            jo.Put("isActive", IsActive);
            jo.Put("skipTypeId", (int)SkipType);
            return jo;
        }

        private JsonObject GetResourcesJson()
        {
            var jo = new JsonObject();
            foreach (var resource in Resources)
            {
                jo.Put(((int)resource.ResourceType).ToString(CultureInfo.InvariantCulture), resource.ToJson());
            }

            return jo;
        }


        public void AddResource(IResource resource)
        {
            switch (resource.ResourceType)
            {
                case ResourceType.Video:
                    Video = resource;
                    if (null != VideoThumbnail)
                    {
                        ((Resource)Video).SetThumbnail(VideoThumbnail);
                    }
                    break;
                case ResourceType.Image:
                    Image = resource;
                    break;
                case ResourceType.Audio:
                    Audio = resource;
                    break;
                default:
                    throw new ArgumentOutOfRangeException("resource.ResourceType", resource.ResourceType, "Resource type not implemented");
            }

            Resources.Add(resource);
        }

        public IEnumerator<IResource> GetEnumerator()
        {
            return Resources.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return Resources.GetEnumerator();
        }
    }
}