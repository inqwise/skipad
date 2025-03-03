using System;
using System.Data;
using Inqwise.Skipad.Common;

namespace Inqwise.Skipad.Dal
{
    public class ReferralsDataAccess : DataAccess
    {
        private const string TO_EVENT_DATE_PARAM_NAME = "@ToEventDate";
        private const string FORM_EVENT_DATE_PARAM_NAME = "@FromEventDate";
        private const string USERNAME_PARAM_NAME = "@UserName";
        private const string AD_ID_PARAM_NAME = "@Ads_Id";
        private const string CAMPAIGN_ID_PARAM_NAME = "@CampaignId";
        private const string ACCOUNT_ID_PARAM_NAME = "@AccountId";
        private const string TOP_PARAM_NAME = "@Top";
        private const string DOMAIN_NAME_PARAM_NAME = "@DomainName";

        private const string DOMAINS_STATISTICS_SP_NAME = "DomainsGetStatistics";
        private const string URLS_STATISTICS_SP_NAME = "UrlsGetStatistics";

        public static DsDomainsStatistics GetDomainsStatistics(int? campaignId, string username, DateTime? fromEventDate, DateTime? toEventDate, int accountId, long? adId, int? top)
        {
            var ds = new DsDomainsStatistics();
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(DOMAINS_STATISTICS_SP_NAME))
            {
                command.CommandTimeout = 6000;
                db.AddInParameter(command, CAMPAIGN_ID_PARAM_NAME, DbType.Int32, campaignId);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, FORM_EVENT_DATE_PARAM_NAME, DbType.DateTime, fromEventDate);
                db.AddInParameter(command, TO_EVENT_DATE_PARAM_NAME, DbType.DateTime, toEventDate);
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                db.AddInParameter(command, AD_ID_PARAM_NAME, DbType.Int64, adId);
                db.AddInParameter(command, TOP_PARAM_NAME, DbType.Int16, top);
                db.LoadDataSet(command, ds, ds.Domains.TableName);
            }

            return ds;
        }

        public static DsReferralsStatistics GetUrlsStatistics(int? campaignId, string username, DateTime? fromEventDate, DateTime? toEventDate, int accountId, long? adId, int? top, string domain)
        {
            var ds = new DsReferralsStatistics();
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(URLS_STATISTICS_SP_NAME))
            {
                command.CommandTimeout = 6000;
                db.AddInParameter(command, CAMPAIGN_ID_PARAM_NAME, DbType.Int32, campaignId);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, FORM_EVENT_DATE_PARAM_NAME, DbType.DateTime, fromEventDate);
                db.AddInParameter(command, TO_EVENT_DATE_PARAM_NAME, DbType.DateTime, toEventDate);
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                db.AddInParameter(command, AD_ID_PARAM_NAME, DbType.Int64, adId);
                db.AddInParameter(command, TOP_PARAM_NAME, DbType.Int16, top);
                db.AddInParameter(command, DOMAIN_NAME_PARAM_NAME, DbType.String, domain);
                db.LoadDataSet(command, ds, ds.Referrals.TableName);
                
            }

            return ds;
        }
    }
}