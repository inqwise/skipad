
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using ExcelLibrary.SpreadSheet;
using Jayrock.Json;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Common.Errors;
using Inqwise.Skipad.Entities;
using Inqwise.Skipad.Managers;

namespace Handlers
{
    public class AdsHandler : BaseHandler<JsonObject>
    {
        private const string CREATE_METHOD_NAME = "createAd";
        private const string FROM_EVENT_DATE_ARG_NAME = "fromDate";
        private const string TO_EVENT_DATE_ARG_NAME = "toDate";
        private const string COPY_METHOD_NAME = "copyAd";
        private const string IS_CHANGE_AUID_ARG_NAME = "changeAuid";
        private const string AD_NAME_ARG_NAME = "adName";
        private const string MODIFY_METHOD_NAME = "updateAd";
        private const string DELETE_MENY_METHOD_NAME = "deleteAds";
        private const string GET_MENY_METHOD_NAME = "getAds";
        private const string GET_METHOD_NAME = "getAd";
        private const string CAMPAIGN_ID_ARG_NAME = "campaignId";
        private const string AUID_ARG_NAME = "auid";
        private const string AD_ID_ARG_NAME = "adId";
        private const string ACCOUNT_ID_ARG_NAME = "accountId";
        private const string VAST_VERSION_1 = "1";

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
                case COPY_METHOD_NAME:
                    output = Copy(args);
                    break;
                case CREATE_METHOD_NAME:
                    output = Create(args);
                    break;
                default:
                    output = GetMethodNotFoundJson(methodName);
                    break;
            }

            return output;
        }

        private JsonObject Create(JsonObject args)
        {
            int campaignId = args.GetInt("campaignId");
            string adName = args.GetString("adName");
            string videoClickUrl = args.GetString("videoClickUrl");
            string imageClickUrl = args.GetString("imageClickUrl");
            long videoResourceId = args.GetLong("videoResourceId");
            long imageResourceId = args.GetLong("imageResourceId");
            bool isGenerateImages = args.GetBool("imageGenerate");
            string externalTagUrl = args.OptStringTrim("externalTagUrl");
            string surveyUrl = args.OptStringTrim("surveyUrl");
            var adType = (AdType)args.GetInt("adTypeId");
            long? audioResourceId = args.OptLong("audioResourceId");
            var skipType = (SkipType) args.OptInt("skipTypeId").GetValueOrDefault((int)SkipType.Slide);

            var resources = new Dictionary<long, string>
                {
                    {imageResourceId, imageClickUrl}
                };

            if (0 != videoResourceId)
            {
                resources.Add(videoResourceId, videoClickUrl);
            }

            if (audioResourceId.HasValue)
            {
                resources.Add(audioResourceId.Value, null);
            }

            var adId = AdsManager.Create(adName, campaignId, resources, UserName, null, externalTagUrl, surveyUrl, adType, skipType);

            if (isGenerateImages)
            {
                // Generate Images in different sizes
                ResourcesManager.MakeVariousSizes(imageResourceId, UserName, videoResourceId);
            }

            return new JsonObject {{"adId", adId}};
        }

        private JsonObject Copy(JsonObject args)
        {
            JsonObject output = null;
            long adId = args.GetInt(AD_ID_ARG_NAME);
            string name = args[AD_NAME_ARG_NAME].ToString();
            IAd ad = AdsManager.Get(adId, UserName);

            if (null == ad)
            {
                output = GetErrorJson(SkipadErrors.NoResults);
            }
            else
            {
                long copyAdId = ad.Copy(name, UserName);
                output = new JsonObject();
                output.Put(AD_ID_ARG_NAME, copyAdId);
            }

            return output;
        }

        private JsonObject Get(JsonObject args)
        {
            JsonObject output = null;
            string auidStr = args.OptString(AUID_ARG_NAME);
            int? adId = args.OptInt(AD_ID_ARG_NAME);

            if (!ExactOne(auidStr, adId))
            {
                output = GetErrorJson(SkipadErrors.InvalidArgument, string.Format("Exact one argument required: '{0}' or '{1}'", AUID_ARG_NAME, AD_ID_ARG_NAME));
            }

            var auid = new Guid();
            if (null == output && null != auidStr && !Guid.TryParse(auidStr, out auid))
            {
                output = GetErrorJson(SkipadErrors.InvalidArgument, "auid must be a guid or null");   
            }

            if(null == output)
            {
                IAd ad = adId.HasValue ? AdsManager.Get(adId.Value, UserName) : AdsManager.Get(auid);
                output = ad.ToJson();

                var targetEvents = ExternalTargetEventsManager.GetMeny(ad.Id);

                output.Put("imageUrl", ResourcesManager.GetResourceUrl(ad.Image.Files.FirstOrDefault()));

                if (null != ad.Video)
                {
                    IResourceFile videoRecourceFile = ad.Video.Files.FirstOrDefault();
                    output.Put("videoUrl", ResourcesManager.GetResourceUrl(videoRecourceFile));
                    output.Put("videoThumbUrl", ResourcesManager.GetResourceThumbUrl(videoRecourceFile));
                }

                output.Put("tagUrl", ResourcesManager.GetTagUrl(ad.Auid.ToString(), OutputType.Vast));
                if (ad.AdType == AdType.InLine)
                {
                    output.Put("mraidTagUrl", ResourcesManager.GetTagUrl(ad.Auid.ToString(), OutputType.Mraid));
                    output.Put("vpaidHtml5TagUrl", ResourcesManager.GetTagUrl(ad.Auid.ToString(), OutputType.VpaidHtml5));
                    output.Put("vpaidFlashTagUrl", ResourcesManager.GetTagUrl(ad.Auid.ToString(), OutputType.VpaidFlash));
                    output.Put("vpaidFlashV1TagUrl", ResourcesManager.GetTagUrl(ad.Auid.ToString(), OutputType.VpaidFlash, VAST_VERSION_1));
                }
                output.Put("auid", ad.Auid);

                var ja = new JsonArray();
                foreach (var targetEvent in targetEvents)
                {
                    var jo = new JsonObject();

                    jo.Put("url", targetEvent.Url);
                    jo.Put("eventTypeId", targetEvent.EventTypeId);
                    ja.Add(jo);
                }

                output.Put("customEvents", ja);
            }

            return output;
        }

        private struct UpdateExternalTargetEvent : IUpdateExternalTargetEventArgs
        {
            public int EventTypeId { get; set; }
            public string Url { get; set; }
        }

        private JsonObject Modify(JsonObject args)
        {
            JsonObject output = null;
            long id = args.GetInt(AD_ID_ARG_NAME);
            string name = args[AD_NAME_ARG_NAME].ToString();
            bool isGenerateNewAuid = args.OptBool(IS_CHANGE_AUID_ARG_NAME, false).GetValueOrDefault();
            string videoClickUrl = args.GetString("videoClickUrl");
            string imageClickUrl = args.GetString("imageClickUrl");
            string externalTagUrl = args.OptStringTrim("externalTagUrl");
            string surveyUrl = args.OptStringTrim("surveyUrl");
            var accountId = args.GetInt("accountId");
            var isActive = args.OptBool("isActive", true);
               
            var currentAd = AdsManager.Get(id, UserName);

            if (null == currentAd)
            {
                GetErrorJson(SkipadErrors.NoResults, "Ad not found");
            }
            else
            {
                IResource videoResource = currentAd.Video;
                IResource imageResource = currentAd.Image;

                Dictionary<long, string> clickUrls = null;

                if (null != videoClickUrl || null != imageClickUrl)
                {
                    clickUrls = new Dictionary<long, string>();

                    if (null != videoResource && null != videoClickUrl)
                    {
                        clickUrls.Add(videoResource.Id, videoClickUrl);
                    }

                    if (null != imageResource && null != imageClickUrl)
                    {
                        clickUrls.Add(imageResource.Id, imageClickUrl);
                    }
                }

                Guid? auid = AdsManager.Modify(id, name, null, clickUrls, isGenerateNewAuid, UserName, externalTagUrl, surveyUrl, isActive.GetValueOrDefault());

                var eventsArr = (JsonArray)args["customEvents"];
                var events = (from JsonObject eventJo in eventsArr
                              select new UpdateExternalTargetEvent
                              {
                                  EventTypeId = eventJo.GetInt("eventTypeId"),
                                  Url = eventJo.OptStringTrim("url")
                              }).Cast<IUpdateExternalTargetEventArgs>();


                ExternalTargetEventsManager.Modify(id, accountId, UserName, events);



                output = GetJsonOk();
            }

            

            return output;
        }

        private JsonObject DeleteMeny(JsonObject args)
        {
            IEnumerable<long> ids = args.GetMenyLong(LIST_PARAM_NAME);
            foreach (var id in ids)
            {
                AdsManager.Delete(id, UserName);
            }

            return GetJsonOk();
        }

        private JsonObject GetMeny(JsonObject args)
        {
            JsonObject output = null;
            int? campaignId = args.OptInt(CAMPAIGN_ID_ARG_NAME);
            DateTime? fromEventDate = args.OptDate(FROM_EVENT_DATE_ARG_NAME);
            DateTime? toEventDate = args.OptDate(TO_EVENT_DATE_ARG_NAME);
            int accountId = args.GetInt(ACCOUNT_ID_ARG_NAME);
            IEnumerable<long> adsList = args.OptMenyLong("adsList");

            var adsDs = AdsManager.GetStatistics(campaignId, UserName, fromEventDate, toEventDate, accountId, adsList);
            var ads = adsDs.Ads;

            switch (OutputArgs.Name)
            {
                case ContentDefType.Json:
                    output = new JsonObject();
                    var adsJa = new JsonArray();
                    foreach (var ad in ads)
                    {
                        var jo = new JsonObject();
                        jo.Put("adId", ad.Ads_Id);
                        jo.Put("adName", ad.AdName);
                        jo.Put("campaignId", ad.CampaignId);
                        jo.Put("campaignName", ad.CampaignName);
                        jo.Put("imageClicks", ad.ClickedOnImage);
                        jo.Put("imageCTR", ad.CtrImage);
                        jo.Put("imageFitted", ad.FittedImage);
                        jo.Put("thumbnailUrl",
                               ResourcesManager.GetResourceUrl(ad.ThumbnailPath,
                                                               (ResourceFilePathType) ad.ThumbnailPathTypeId));
                        jo.Put("imageUrl",
                               ResourcesManager.GetResourceUrl(ad.ImagePath, (ResourceFilePathType) ad.ImagePathTypeId));
                        jo.Put("slideStarted", ad.SlideStarted);
                        jo.Put("timeSpentOnImage", "N/A" /*ad.TimeSpentOnImage*/);
                        jo.Put("tagUrl", ResourcesManager.GetTagUrl(ad.AUID, OutputType.Vast));
                        jo.Put("mraidTagUrl", ResourcesManager.GetTagUrl(ad.AUID, OutputType.Mraid));
                        jo.Put("served", ad.Served);
                        jo.Put("percentSlideStartedFromServed", ad.PercentSlideStartedFromServed);
                        jo.Put("ctrFromFit", ad.CtrFromFit);
                        jo.Put("totalEngagementTime", GetTimeFormat(ad.TotalEngagementTime));
                        jo.Put("avgEngagementTime", ad.AVGEngagementTime);
                        jo.Put("auid", ad.AUID);
                        jo.Put("adTypeId", ad.AdTypeId);
                        jo.Put("share", ad.Share);
                        jo.Put("reply", ad.Replay);
                        jo.Put("rateVoted", ad.RateVoted);
                        jo.Put("avgRate", ad.AvgRate);
                        jo.Put("validView", ad.ValidView);
                        adsJa.Add(jo);
                    }

                    output.Put(LIST_PARAM_NAME, adsJa);
                    break;
                case ContentDefType.Xls:
                    DownloadFilePath = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
                    CreateWorkbook(DownloadFilePath, adsDs);
                    break;
                default:
                    throw new ArgumentOutOfRangeException();
            }
            return output;
        }

        /*
        private JsonObject GetMeny(JsonObject args)
        {
            var output = new JsonObject();
            int? campaignId = args.OptInt(CAMPAIGN_ID_ARG_NAME);
            var ads = AdsManager.GetMeny(campaignId, UserName);
            var adsJa = new JsonArray();
            foreach (var ad in ads)
            {
                var jo = ad.ToJson();
                jo.Put("tagUrl", ResourcesManager.GetTagUrl(ad.Auid.ToString()));
                adsJa.Add(jo);
            }
            
            output.Put(LIST_PARAM_NAME, adsJa);

            return output;
        }*/

        protected override ContentDef[] ImplementedOutputTypes
        {
            get
            {
                return new[] { ContentDef.Json, ContentDef.Xls };
            }
        }
    }
}