using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Jayrock.Json;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Common.Errors;
using Inqwise.Skipad.Managers;

namespace Handlers
{
    public class CampaignsHandler : BaseHandler<JsonObject>
    {
        private const string ACCOUNT_ID_ARG_NAME = "accountId";
        private const string GET_OVERALL_NAME = "getCampaignActivities";
        private const string CREATE_METHOD_NAME = "createCampaign";
        private const string GET_MENY_METHOD_NAME = "getCampaigns";
        private const string GET_METHOD_NAME = "getCampaign";
        private const string DELETE_MENY_METHOD_NAME = "deleteCampaigns";
        private const string MODIFY_METHOD_NAME = "updateCampaign";
        private const string CAMPAIGN_ID_ARG_NAME = "campaignId";
        private const string CAMPAIGN_NAME_ARG_NAME = "campaignName";
        private const string CAMPAIGN_DESCRIPTION_ARG_NAME = "campaignDescription";
        private const string FROM_EVENT_DATE_ARG_NAME = "fromDate";
        private const string TO_EVENT_DATE_ARG_NAME = "toDate";

        protected override JsonObject Process(string methodName, JsonObject args)
        {
            JsonObject output;
            switch (methodName)
            {
                case GET_MENY_METHOD_NAME:
                    output = GetMeny(args);
                    break;
                case GET_METHOD_NAME:
                    output = Get(args);
                    break;
                case DELETE_MENY_METHOD_NAME:
                    output = DeleteMeny(args);
                    break;
                case MODIFY_METHOD_NAME:
                    output = Modify(args);
                    break;
                case CREATE_METHOD_NAME:
                    output = Create(args);
                    break;
                case GET_OVERALL_NAME:
                    output = GetOverall(args);
                    break;
                default:
                    output = GetMethodNotFoundJson(methodName);
                    break;
            }

            return output;
        }

        private JsonObject GetOverall(JsonObject args)
        {
            JsonObject output = null;
            DateTime? fromEventDate = args.OptDate(FROM_EVENT_DATE_ARG_NAME);
            DateTime? toEventDate = args.OptDate(TO_EVENT_DATE_ARG_NAME);
            int? campaignId = args.OptInt(CAMPAIGN_ID_ARG_NAME);
            int accountId = args.GetInt(ACCOUNT_ID_ARG_NAME);
            var statistics = CampaignsManager.GetOverallStatistics(UserName, fromEventDate, toEventDate, campaignId, accountId).Campaigns.FirstOrDefault();

            if (null == statistics)
            {
                output = GetErrorJson(SkipadErrors.NoResults);
            }
            else
            {
                output = new JsonObject();
                output.Put("avgTimeOnImage", "N/A" /*statistics.AvgTimeOnSkipAd*/);
                output.Put("bounceRate", statistics.BounceRate);
                output.Put("imageClicks", statistics.SkipAdClicks);
                output.Put("imageCTR", statistics.SkipAdCTR);
                output.Put("imageFitted", statistics.SkipAdFitted);
                output.Put("imageFittedSlide", statistics.SkipAdFittedSlide);
                output.Put("timeSaved", "N/A" /*statistics.TimeSaved*/);
                output.Put("timeSpentOnImage", "N/A" /*statistics.TimeSpentOnSkipAd*/);
                output.Put("videoClicks", statistics.VideoClicks);
                output.Put("videoCTR", statistics.VideoCTR);
                output.Put("imageFittedServed", statistics.SkipAdFittedServed);
                output.Put("totalEngagementTime", GetTimeFormat(statistics.TotalEngagementTime));
                output.Put("avgEngagementTime", statistics.AVGEngagementTime);




            }

            return output;
        }

        private JsonObject Create(JsonObject args)
        {
            JsonObject output = null;
            string name = args[CAMPAIGN_NAME_ARG_NAME].ToString();
            string description = args.OptString(CAMPAIGN_DESCRIPTION_ARG_NAME);
            int accountId = args.GetInt(ACCOUNT_ID_ARG_NAME);

            int id = CampaignsManager.Create(name, description, UserName, accountId);
            output = new JsonObject();
            output.Put(CAMPAIGN_ID_ARG_NAME, id);

            bool isAssignPackage = args.Contains("themeId");
            if (isAssignPackage)
            {
                int? packageId = args.OptInt("themeId");
                PackagesManager.Assign(packageId, accountId, UserName, id, (int)PackageLevel.Campaign);
            }

            return output;
        }

        private JsonObject Modify(JsonObject args)
        {
            JsonObject output = null;
            int id = args.GetInt(CAMPAIGN_ID_ARG_NAME);
            string name = args.OptString(CAMPAIGN_NAME_ARG_NAME);
            string description  = args.OptString(CAMPAIGN_DESCRIPTION_ARG_NAME);
            int accountId = args.GetInt(ACCOUNT_ID_ARG_NAME);

            bool isAssignPackage = args.Contains("themeId");
            
            if (null != name)
            {
                CampaignsManager.Modify(id, name, description, UserName);
            }

            if (isAssignPackage)
            {
                int? packageId = args.OptInt("themeId");
                PackagesManager.Assign(packageId, accountId, UserName, id, (int)PackageLevel.Campaign);
            }



            output = GetJsonOk();
            
            return output;
        }

        private JsonObject DeleteMeny(JsonObject args)
        {
            JsonObject output = null;
            IEnumerable<int> ids = args.GetMenyInt(LIST_PARAM_NAME);
            foreach (var id in ids)
            {
                CampaignsManager.Delete(id, UserName);
            }

            return GetJsonOk();
        }

        private JsonObject Get(JsonObject args)
        {
            JsonObject output;
            int id = args.GetInt(CAMPAIGN_ID_ARG_NAME);
            int accountId = args.GetInt(ACCOUNT_ID_ARG_NAME);

            ICampaign campaign = CampaignsManager.Get(id, UserName, accountId);
            if (null == campaign)
            {
                output = GetErrorJson(SkipadErrors.NoResults);
            }
            else
            {
                output = campaign.ToJson();
            }

            return output;
        }

        private JsonObject GetMeny(JsonObject args)
        {
            JsonObject output = null;
            DateTime? fromEventDate = args.OptDate(FROM_EVENT_DATE_ARG_NAME);
            DateTime? toEventDate = args.OptDate(TO_EVENT_DATE_ARG_NAME);
            int accountId = args.GetInt(ACCOUNT_ID_ARG_NAME);
            IEnumerable<int> campaignsList = args.OptMenyInt("campaignsList");

            var capaignsDs = CampaignsManager.GetStatistics(UserName, fromEventDate, toEventDate, accountId, campaignsList);
            var campaigns = capaignsDs.Campaigns;

            if (null == campaigns || campaigns.Count == 0)
            {
                output = GetErrorJson(SkipadErrors.NoResults);
            }
            else
            {
                switch (OutputArgs.Name)
                {
                    case ContentDefType.Json:
                        output = new JsonObject();
                        var ja = new JsonArray();
                        foreach (var campaign in campaigns)
                        {
                            var jo = new JsonObject();

                            jo.Put("campaignId", campaign.CampaignId);
                            jo.Put("campaignName", campaign.CampaignName);
                            jo.Put("avgTimeOnSkipAd", "N/A" /*campaign.AVGTimeOnSkipAd*/);
                            jo.Put("bounceRate", campaign.BounceRate);
                            jo.Put("imageClicks", campaign.ClickedImage);
                            jo.Put("complete", campaign.Complete);
                            jo.Put("videoCTR", campaign.CtrVideo);
                            jo.Put("firstQuartile", campaign.FirstQuartile);
                            jo.Put("imageFitted", campaign.FittedImage);
                            jo.Put("midPoint", campaign.MidPoint);
                            jo.Put("mute", campaign.Mute);
                            jo.Put("paused", campaign.Paused);
                            jo.Put("percentFitFromServed", campaign.PercentFitFromServed);
                            jo.Put("percentSuccessFit", campaign.PercentSuccessFit);
                            jo.Put("served", campaign.Served);
                            jo.Put("skipButton", campaign.SkipButton);
                            jo.Put("skipSlider", campaign.SkipSlider);
                            jo.Put("slideMissed", campaign.SliderMissed);
                            jo.Put("slideStarted", campaign.SlideStarted);
                            jo.Put("thirdQuartile", campaign.ThirdQuartile);
                            jo.Put("timeOnSkipAd", "N/A" /*campaign.TimeOnSkipAd*/);
                            jo.Put("timeSaved", "N/A" /*campaign.TimeSaved */);
                            jo.Put("videoClicks", campaign.VideoClicks);
                            jo.Put("imageCTR", campaign.CtrImage);
                            jo.Put("percentSlideStartedFromServed", campaign.PercentSlideStartedFromServed);
                            jo.Put("ctrFromFit", campaign.CtrFromFit);
                            jo.Put("totalEngagementTime", GetTimeFormat(campaign.TotalEngagementTime));
                            jo.Put("avgEngagementTime", campaign.AVGEngagementTime);
                            jo.Put("share", campaign.Share);
                            jo.Put("reply", campaign.Replay);
                            jo.Put("rateVoted", campaign.RateVoted);
                            jo.Put("avgRate", campaign.AvgRate);
                            jo.Put("validView", campaign.ValidView);

                            ja.Add(jo);
                        }

                        output.Put(LIST_PARAM_NAME, ja);
                        break;
                    case ContentDefType.Xls:
                        DownloadFilePath = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
                        CreateWorkbook(DownloadFilePath, capaignsDs);
                        break;
                    default:
                        throw new ArgumentOutOfRangeException();
                }

               
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