using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Dal;
using Inqwise.Skipad.Entities;

namespace Inqwise.Skipad.Managers
{
    public class AdsManager
    {
        public static long Create(string adName, int campaignId, IDictionary<long, string> resourceClickUrlList, string username, string adDescription, string externalTagUrl, string surveyUrl, AdType adType, SkipType skipType)
        {
            return AdsDataAccess.Insert(adName, campaignId, resourceClickUrlList, username, adDescription, externalTagUrl, surveyUrl, adType, skipType);
        }

        public static IAd Get(long id, string username)
        {
            var reader = AdsDataAccess.GetReader(id, null, username);
            return ConstructSingleAd(reader);
        }

        public static IAd Get(Guid auid)
        {
            var reader = AdsDataAccess.GetReader(null, auid, null);
            return ConstructSingleAd(reader);
        }

        private static Ad ConstructSingleAd(IDataReader reader)
        {
            var resourcesSet = new Dictionary<long, Resource>();
            Ad ad = null;
            if (reader.Read())
            {
                ad = new Ad(reader);
            }

            // resources
            if (reader.NextResult())
            {
                while (reader.Read())
                {
                    var resource = new Resource(reader);
                    resourcesSet.Add(resource.Id, resource);
                    ad.AddResource(resource);
                }
            }

            // resourceFiles
            if (reader.NextResult())
            {
                while (reader.Read())
                {
                    var resourceFile = new ResourceFile(reader);
                    try
                    {
                        resourcesSet[resourceFile.ResourceId].AddResourceFile(resourceFile);
                    }
                    catch (Exception ex)
                    {
                        throw new Exception(string.Format("Get: Failed to add resourceFile #{0} to resource #{1}", resourceFile.Id, resourceFile.ResourceId), ex);
                    }
                }
            }
            return ad;
        }

        public static List<IAd> GetMeny(int? campaignId, string username, int? accountId)
        {
            
            var reader = AdsDataAccess.GetMenyReader(campaignId, username, accountId);
            var list = new List<IAd>();
            var adsSet = new Dictionary<long, Ad>();
            var resourcesSet = new Dictionary<long, Resource>();

            while (reader.Read())
            {
                var ad = new Ad(reader);
                list.Add(ad);
                adsSet.Add(ad.Id, ad);
            }

            // resources
            if (reader.NextResult())
            {
                while (reader.Read())
                {
                    var resource = new Resource(reader);

                    if (resourcesSet.ContainsKey(resource.Id))
                    {
                        resource = resourcesSet[resource.Id];
                    }
                    else
                    {
                        resourcesSet.Add(resource.Id, resource);
                    }

                    try
                    {
                        adsSet[resource.AdId.Value].AddResource(resource);
                    }
                    catch (Exception ex)
                    {
                        throw new Exception(string.Format("GetMeny: Failed to add resource #{0} to ad #{1}", resource.Id, resource.AdId), ex);
                    }
                }
            }

            // resourceFiles
            if (reader.NextResult())
            {
                while (reader.Read())
                {
                    var resourceFile = new ResourceFile(reader);
                    try
                    {
#if DEBUG
                        if (null == resourcesSet[resourceFile.ResourceId].Files.FirstOrDefault(r => r.Id == resourceFile.Id)) // TODO: WAITING FOR DB FIX  
#endif
                        {
                            resourcesSet[resourceFile.ResourceId].AddResourceFile(resourceFile);
                        }
                    }
                    catch (Exception ex)
                    {
                        throw new Exception(string.Format("GetMeny: Failed to add resourceFile #{0} to resource #{1}", resourceFile.Id, resourceFile.ResourceId), ex);
                    }
                }
            }
            return list;
        }

        public static void Delete(long id, string userName)
        {
            AdsDataAccess.Delete(id, userName);
        }

        public static Guid? Modify(long id, string adName, int? campaignId, IDictionary<long, string> resourceClickUrl, bool isGenerateNewAuid, string username, string externalTagUrl, string surveyUrl, bool isActive)
        {
            Guid? newAuid = null;
            if (isGenerateNewAuid)
            {
                newAuid = Guid.NewGuid();
            }

            AdsDataAccess.Update(id, adName, campaignId, resourceClickUrl, newAuid, username, externalTagUrl, surveyUrl, isActive);
            return newAuid;
        }


        private static readonly Lazy<string> VastUrl = new Lazy<string>(() => ConfigurationManager.AppSettings["VastUrl"]);
        public static string GetVastUrl(Guid auid)
        {
            return VastUrl.Value + auid;
        }

        public static DsAdsStatistics GetStatistics(int? campaignId, string username, DateTime? fromEventDate, DateTime? toEventDate, int? accountId, IEnumerable<long> adsList)
        {
            return AdsDataAccess.GetStatistics(campaignId, username, fromEventDate, toEventDate, accountId, adsList);
        }
    }
}