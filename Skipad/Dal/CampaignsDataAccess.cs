using System;
using System.Collections.Generic;
using System.Data;
using Inqwise.Skipad.Common;

namespace Inqwise.Skipad.Dal
{
    public class CampaignsDataAccess : DataAccess
    {
        private const string ACCOUNT_ID_PARAM_NAME = "@AccountId";
        private const string CAMPAIGN_NAME_PARAM_NAME = "@CampaignName";
        private const string CAMPAIGN_DESC_PARAM_NAME = "@CampaignDesc";
        private const string CAMPAIGN_ID_PARAM_NAME = "@CampaignId";
        private const string USERNAME_PARAM_NAME = "@Username";
        private const string TO_EVENT_DATE_PARAM_NAME = "@ToEventDate";
        private const string FORM_EVENT_DATE_PARAM_NAME = "@FromEventDate";
        private const string TO_DATE_PARAM_NAME = "@ToDate";
        private const string FORM_DATE_PARAM_NAME = "@FromDate";
        private const string CAMPAIGNS_IDS_PARAM_NAME = "CampaignIdsList";

        private const string DASHBOARD_STATISTICS_SP_NAME = "DashboardGetStatistics";
        private const string INSERT_CAMPAIGN_SP_NAME = "Campaigns_InsertNewCampaign";
        private const string GET_CAMPAIGN_SP_NAME = "Campaigns_GetData";
        private const string GET_CAMPAIGNS_SP_NAME = "Campaigns_GetData";
        private const string DELETE_CAMPAIGN_SP_NAME = "Campaigns_DeleteCampaign";
        private const string UPDATE_CAMPAIGN_SP_NAME = "Campaigns_UpdateCampaign";
        private const string CAMPAIGNS_STATISTICS_SP_NAME = "[dbo].[CampaignsGetStatistics]";

        public static IDataReader GetMenyDataReader(string username, int accountId)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(GET_CAMPAIGNS_SP_NAME))
            {
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);

                return db.ExecuteReader(command);
            }
        }

        public static void Delete(int id, string username)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(DELETE_CAMPAIGN_SP_NAME))
            {
                db.AddInParameter(command, CAMPAIGN_ID_PARAM_NAME, DbType.Int32, id);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.ExecuteNonQuery(command);
            }
        }

        public static void Update(int id, string name, string description, string username)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(UPDATE_CAMPAIGN_SP_NAME))
            {
                db.AddInParameter(command, CAMPAIGN_ID_PARAM_NAME, DbType.Int32, id);
                db.AddInParameter(command, CAMPAIGN_NAME_PARAM_NAME, DbType.String, name);
                db.AddInParameter(command, CAMPAIGN_DESC_PARAM_NAME, DbType.String, description);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);

                db.ExecuteNonQuery(command);
            }
        }

        public static int Insert(string name, string description, string username, int accountId)
        {
            int id;

            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(INSERT_CAMPAIGN_SP_NAME))
            {
                db.AddInParameter(command, CAMPAIGN_NAME_PARAM_NAME, DbType.String, name);
                db.AddInParameter(command, CAMPAIGN_DESC_PARAM_NAME, DbType.String, description);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                db.AddOutParameter(command, CAMPAIGN_ID_PARAM_NAME, DbType.Int32, sizeof(int));
                db.ExecuteNonQuery(command);

                id = (int)db.GetParameterValue(command, CAMPAIGN_ID_PARAM_NAME);
            }

            return id;
        }

        public static IDataReader GetDataReader(int id, string username, int accountId)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(GET_CAMPAIGN_SP_NAME))
            {
                db.AddInParameter(command, CAMPAIGN_ID_PARAM_NAME, DbType.Int32, id);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                return db.ExecuteReader(command);
            }
        }

        public static DsCampaignsStatistics GetStatistics(string username, DateTime? fromEventDate, DateTime? toEventDate, int accountId, IEnumerable<int> campaignsList)
        {
            var ds = new DsCampaignsStatistics();
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(CAMPAIGNS_STATISTICS_SP_NAME))
            {
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, FORM_EVENT_DATE_PARAM_NAME, DbType.DateTime, fromEventDate);
                db.AddInParameter(command, TO_EVENT_DATE_PARAM_NAME, DbType.DateTime, toEventDate);
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                if(null != campaignsList) db.AddInParameter(command, CAMPAIGNS_IDS_PARAM_NAME, DbType.String, string.Join(",", campaignsList));
                db.LoadDataSet(command, ds, ds.Campaigns.TableName);
            }

            return ds;
        }

        public static DsCampaignsOverallStatistics GetOverallStatistics(string username, DateTime? fromDate, DateTime? toDate, int? campaignId, int accountId)
        {
            var ds = new DsCampaignsOverallStatistics();
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(DASHBOARD_STATISTICS_SP_NAME))
            {
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, FORM_DATE_PARAM_NAME, DbType.DateTime, fromDate);
                db.AddInParameter(command, TO_DATE_PARAM_NAME, DbType.DateTime, toDate);
                db.AddInParameter(command, CAMPAIGN_ID_PARAM_NAME, DbType.Int32, campaignId);
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                db.LoadDataSet(command, ds, ds.Campaigns.TableName);
            }

            return ds;
        }
    }
}