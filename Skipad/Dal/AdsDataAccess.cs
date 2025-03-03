using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using Inqwise.Skipad.Common;

namespace Inqwise.Skipad.Dal
{
    public class AdsDataAccess : DataAccess
    {
        private const string TO_EVENT_DATE_PARAM_NAME = "@ToEventDate";
        private const string FORM_EVENT_DATE_PARAM_NAME = "@FromEventDate";
        private const string USERNAME_PARAM_NAME = "@UserName";
        private const string AD_ID_PARAM_NAME = "@Ads_Id";
        private const string AUID_PARAM_NAME = "@Auid";
        private const string AD_NAME_PARAM_NAME = "@AdName";
        private const string AD_DESCRIPTION_PARAM_NAME = "@AdDesc";
        private const string CAMPAIGN_ID_PARAM_NAME = "@CampaignId";
        private const string RESOURCES_PARAM_NAME = "@AdsResourcesList";
        private const string ACCOUNT_ID_PARAM_NAME = "@AccountId";

        private const string EXTERNAL_TAG_URL_PARAM_NAME = "@ExternalTagURL";
        private const string SURVEY_URL_PARAM_NAME = "@SurveyURL";
        private const string AD_TYPE_ID_PARAM_NAME = "@AdTypeId";
        private const string ADS_IDS_PARAM_NAME = "AdIdsList";
        private const string IS_ACTIVE_PARAM_NAME = "IsActive";

        private const string INSERT_AD_SP_NAME = "Ads_InsertNewAd";
        private const string GET_AD_SP_NAME = "Ads_GetData";
        private const string GET_ADS_SP_NAME = "Ads_GetData";
        private const string UPDATE_AD_SP_NAME = "Ads_UpdateAd";
        private const string DELETE_AD_SP_NAME = "Ads_DeleteAd";
        private const string ADS_STATISTICS_SP_NAME = "AdsGetStatistics";
        private const string SKIP_TYPE_ID_PARAM_NAME = "@SkipTypeId";

        public static long Insert(string adName, int campaignId, IDictionary<long, string> resourceClickUrls, string username, string adDescription, string externalTagUrl, string surveyUrl, AdType adType, SkipType skipType)
        {
            long id;
            
            var db = (SqlDatabase)Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(INSERT_AD_SP_NAME))
            {
                db.AddInParameter(command, AUID_PARAM_NAME, DbType.Guid, Guid.NewGuid());
                db.AddInParameter(command, AD_NAME_PARAM_NAME, DbType.String, adName);
                db.AddInParameter(command, AD_DESCRIPTION_PARAM_NAME, DbType.String, adDescription);
                db.AddInParameter(command, CAMPAIGN_ID_PARAM_NAME, DbType.Int32, campaignId);
                db.AddOutParameter(command, AD_ID_PARAM_NAME, DbType.Int64, sizeof(long));
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, EXTERNAL_TAG_URL_PARAM_NAME, DbType.String, externalTagUrl);
                db.AddInParameter(command, SURVEY_URL_PARAM_NAME, DbType.String, surveyUrl);
                db.AddInParameter(command, AD_TYPE_ID_PARAM_NAME, DbType.Int32, (int)adType);
                db.AddInParameter(command, SKIP_TYPE_ID_PARAM_NAME, DbType.Int32, (int)skipType);
                
                var table = BuildResourcesDataTable(resourceClickUrls);
                db.AddInParameter(command, RESOURCES_PARAM_NAME, SqlDbType.Structured, table);
                
                db.ExecuteNonQuery(command);

                id = (long) db.GetParameterValue(command, AD_ID_PARAM_NAME);
            }

            return id;
        }

        public static IDataReader GetReader(long? id, Guid? auid, string username)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(GET_AD_SP_NAME))
            {
                db.AddInParameter(command, AD_ID_PARAM_NAME, DbType.Int64, id);
                db.AddInParameter(command, AUID_PARAM_NAME, DbType.Guid, auid);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                return db.ExecuteReader(command);
            }
        }

        public static IDataReader GetMenyReader(int? campaignId, string username, int? accountId)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(GET_ADS_SP_NAME))
            {
                db.AddInParameter(command, CAMPAIGN_ID_PARAM_NAME, DbType.Int32, campaignId);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                return db.ExecuteReader(command);
            }
        }

        public static void Delete(long id, string username)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(DELETE_AD_SP_NAME))
            {
                db.AddInParameter(command, AD_ID_PARAM_NAME, DbType.Int64, id);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.ExecuteNonQuery(command);
            }
        }

        public static void Update(long id, string adName, int? campaignId, IDictionary<long, string> resourceClickUrls, Guid? auid, string username, string externalTagUrl, string surveyUrl, bool isActive)
        {
            var db = (SqlDatabase)Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(UPDATE_AD_SP_NAME))
            {
                db.AddInParameter(command, AD_ID_PARAM_NAME, DbType.Int64, id);
                db.AddInParameter(command, AD_NAME_PARAM_NAME, DbType.String, adName);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, EXTERNAL_TAG_URL_PARAM_NAME, DbType.String, externalTagUrl);
                db.AddInParameter(command, SURVEY_URL_PARAM_NAME, DbType.String, surveyUrl);
                
                if (campaignId.HasValue)
                {
                    db.AddInParameter(command, CAMPAIGN_ID_PARAM_NAME, DbType.Int32, campaignId); 
                }
                
                if (auid.HasValue)
                {
                    db.AddInParameter(command, AUID_PARAM_NAME, DbType.Guid, auid); 
                }

                if (null != resourceClickUrls)
                {
                    var table = BuildResourcesDataTable(resourceClickUrls);
                    db.AddInParameter(command, RESOURCES_PARAM_NAME, SqlDbType.Structured, table);
                }

                db.AddInParameter(command, IS_ACTIVE_PARAM_NAME, DbType.Boolean, isActive);

                db.ExecuteNonQuery(command);
            }
        }

        private static DataTable BuildResourcesDataTable(IEnumerable<KeyValuePair<long, string>> resourceClickUrls)
        {
            var table = new DataTable("ResourcesTable");
            var idColumn = table.Columns.Add("ResourceID", typeof (long));
            var clickUrlColumn = table.Columns.Add("ClickUrl", typeof(string));

            foreach (var resourceClickUrl in resourceClickUrls)
            {
                var row = table.NewRow();
                row[idColumn] = resourceClickUrl.Key;
                row[clickUrlColumn] = resourceClickUrl.Value;
                table.Rows.Add(row);
            }

            return table;
        }

        public static DsAdsStatistics GetStatistics(int? campaignId, string username, DateTime? fromEventDate, DateTime? toEventDate, int? accountId, IEnumerable<long> adsList)
        {
            var ds = new DsAdsStatistics();
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(ADS_STATISTICS_SP_NAME))
            {
                db.AddInParameter(command, CAMPAIGN_ID_PARAM_NAME, DbType.Int32, campaignId);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, FORM_EVENT_DATE_PARAM_NAME, DbType.DateTime, fromEventDate);
                db.AddInParameter(command, TO_EVENT_DATE_PARAM_NAME, DbType.DateTime, toEventDate);
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                if (null != adsList) db.AddInParameter(command, ADS_IDS_PARAM_NAME, DbType.String, string.Join(",", adsList));
                db.LoadDataSet(command, ds, ds.Ads.TableName);
            }

            return ds;
        }
    }
}