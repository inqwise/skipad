using System;
using System.IO;
using Jayrock.Json;
using Inqwise.Skipad.Common.Errors;
using Inqwise.Skipad.Managers;

namespace Handlers
{
    public class ReferralsHandler : BaseHandler<JsonObject>
    {
        // ARGS
        private const string ACCOUNT_ID_ARG_NAME = "accountId";
        private const string FROM_EVENT_DATE_ARG_NAME = "fromDate";
        private const string TO_EVENT_DATE_ARG_NAME = "toDate";
        private const string CAMPAIGN_ID_ARG_NAME = "campaignId";
        private const string AD_ID_ARG_NAME = "adId";
        private const string DOMAIN_ARG_NAME = "domain";
        

        // FUNCTIONS
        private const string GET_DOMAINS_METHOD_NAME = "getDomains";
        private const string GET_URLS_METHOD_NAME = "getUrls";
        
        protected override JsonObject Process(string methodName, JsonObject args)
        {
            JsonObject output;
            switch (methodName)
            {
                case GET_DOMAINS_METHOD_NAME:
                    output = GetDomains(args);
                    break;
                case GET_URLS_METHOD_NAME:
                    output = GetUrls(args);
                    break;
                default:
                    output = GetMethodNotFoundJson(methodName);
                    break;
            }

            return output;
        }

        private JsonObject GetDomains(JsonObject args)
        {
            JsonObject output = null;
            int? campaignId = args.OptInt(CAMPAIGN_ID_ARG_NAME);
            long? adId = args.OptLong(AD_ID_ARG_NAME);
            DateTime? fromEventDate = args.OptDate(FROM_EVENT_DATE_ARG_NAME);
            DateTime? toEventDate = args.OptDate(TO_EVENT_DATE_ARG_NAME);
            int? top = args.OptInt(TOP_ARG_NAME);
            int accountId = args.GetInt(ACCOUNT_ID_ARG_NAME);

            var domainsDs = ReferralsManager.GetDomainsStatistics(campaignId, UserName, fromEventDate, toEventDate, accountId, adId, top);
            var domains = domainsDs.Domains;

            switch(OutputArgs.Name)
            {
                case ContentDefType.Json:
                    output = new JsonObject();
                    var domainsJa = new JsonArray();
                    foreach (var domain in domains)
                    {
                        var jo = new JsonObject();
                        jo.Put("domain", domain.DomainName);
                        jo.Put("imageClicks", domain.ClickedOnImage);
                        jo.Put("imageCTR", domain.CtrImage);
                        jo.Put("imageFitted", domain.FittedImage);
                        jo.Put("slideStarted", domain.SlideStarted);
                        jo.Put("served", domain.Served);
                        jo.Put("percentSlideStartedFromServed", domain.PercentSlideStartedFromServed);
                        jo.Put("ctrFromFit", domain.CtrFromFit);
                        jo.Put("totalEngagementTime", GetTimeFormat(domain.TotalEngagementTime));
                        jo.Put("avgEngagementTime", domain.AVGEngagementTime);
                        jo.Put("share", domain.Share);
                        jo.Put("reply", domain.Replay);
                        jo.Put("rateVoted", domain.RateVoted);
                        jo.Put("avgRate", domain.AvgRate);
                        jo.Put("validView", domain.ValidView);
                        domainsJa.Add(jo);
                    }

                    output.Put(LIST_PARAM_NAME, domainsJa);
                    break;
                case ContentDefType.Xls:
                    DownloadFilePath = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
                    CreateWorkbook(DownloadFilePath, domainsDs);
                    break;
                default:
                    throw new ArgumentOutOfRangeException();
            }

            

            

            return output;
        }

        private JsonObject GetUrls(JsonObject args)
        {
            JsonObject output = null;
            int? campaignId = args.OptInt(CAMPAIGN_ID_ARG_NAME);
            long? adId = args.OptLong(AD_ID_ARG_NAME);
            DateTime? fromEventDate = args.OptDate(FROM_EVENT_DATE_ARG_NAME);
            DateTime? toEventDate = args.OptDate(TO_EVENT_DATE_ARG_NAME);
            string domain = args.OptStringTrim(DOMAIN_ARG_NAME);
            int accountId = args.GetInt(ACCOUNT_ID_ARG_NAME);
            int? top = args.OptInt(TOP_ARG_NAME);

            var referralsDs = ReferralsManager.GetReferralsStatistics(campaignId, UserName, fromEventDate, toEventDate,
                                                                      accountId, adId, domain, top);
            var urlRows = referralsDs.Referrals;

            switch (OutputArgs.Name)
            {
                case ContentDefType.Json:
                    output = new JsonObject();
                    var urlsJa = new JsonArray();
                    foreach (var urlRow in urlRows)
                    {
                        var jo = new JsonObject();
                        jo.Put("url", urlRow.IsTargetURLNull() ? urlRow.ReferralURL : urlRow.TargetURL);
                        jo.Put("imageClicks", urlRow.ClickedOnImage);
                        jo.Put("imageCTR", urlRow.CtrImage);
                        jo.Put("imageFitted", urlRow.FittedImage);
                        jo.Put("slideStarted", urlRow.SlideStarted);
                        jo.Put("served", urlRow.Served);
                        jo.Put("percentSlideStartedFromServed", urlRow.PercentSlideStartedFromServed);
                        jo.Put("ctrFromFit", urlRow.CtrFromFit);
                        jo.Put("totalEngagementTime", GetTimeFormat(urlRow.TotalEngagementTime));
                        jo.Put("avgEngagementTime", urlRow.AVGEngagementTime);
                        jo.Put("share", urlRow.Share);
                        jo.Put("reply", urlRow.Replay);
                        jo.Put("rateVoted", urlRow.RateVoted);
                        jo.Put("avgRate", urlRow.AvgRate);
                        jo.Put("validView", urlRow.ValidView);
                        urlsJa.Add(jo);
                    }

                    output.Put(LIST_PARAM_NAME, urlsJa);
                    break;
                case ContentDefType.Xls:
                    DownloadFilePath = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
                    CreateWorkbook(DownloadFilePath, referralsDs);
                    break;
                default:
                    throw new ArgumentOutOfRangeException();
            }

            

            return output;
        }

        protected override ContentDef[] ImplementedOutputTypes
        {
            get
            {
                return new[] { ContentDef.Json, ContentDef.Xls };
            }
        }
    }
}