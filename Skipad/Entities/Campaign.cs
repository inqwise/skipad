using System;
using System.Data;
using Jayrock.Json;
using Inqwise.Skipad.Common;

namespace Inqwise.Skipad.Entities
{
    public class Campaign : ICampaign
    {
        public static class ColumnNames
        {
            public const string CampaignId = "CampaignId";
            public const string CampaignName = "CampaignName";
            public const string CampaignDescription = "CampaignDesc";
            public const string InsertDate = "ModifyDate";
            public const string ModifyDate = "ModifyDate";
            public const string PackageId = "AccountPropertyPackageId";
        }

        public Campaign(IDataReader reader)
        {
            Id = Convert.ToInt32(reader[ColumnNames.CampaignId]);
            Name = Convert.ToString(reader[ColumnNames.CampaignName]);
            Description = Convert.IsDBNull(reader[ColumnNames.CampaignDescription]) ? null : reader[ColumnNames.CampaignDescription].ToString();
            InsertDate = Convert.ToDateTime(reader[ColumnNames.InsertDate]);
            ModifyDate = Convert.ToDateTime(reader[ColumnNames.ModifyDate]);
            var objPackageId = reader[ColumnNames.PackageId];
            if (!Convert.IsDBNull(objPackageId))
            {
                PackageId = Convert.ToInt32(objPackageId);
            }
        }

        public int Id { get; private set; }
        public string Name { get; private set; }
        public string Description { get; private set; }
        public DateTime InsertDate { get; private set; }
        public DateTime ModifyDate { get; private set; }
        public int? PackageId { get; private set; }

        public JsonObject ToJson()
        {
            var jo = new JsonObject();
            jo.Put("campaignId", Id);
            jo.Put("campaignName", Name);
            if (null != Description)
            {
                jo.Put("campaignDescription", Description); 
            }
            jo.Put("modifyDate", ModifyDate.ToString("dd-MMM-yyyy HH:mm:ss"));
            jo.Put("themeId", PackageId);
            return jo;
        }
    }
}