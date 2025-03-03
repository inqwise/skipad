using System;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Dal;

namespace Inqwise.Skipad.Managers
{
    public class ReferralsManager
    {
        public static DsReferralsStatistics GetReferralsStatistics(int? campaignId, string userName, DateTime? fromEventDate, DateTime? toEventDate, int accountId, long? adId, string domain, int? top)
        {
            return ReferralsDataAccess.GetUrlsStatistics(campaignId, userName, fromEventDate, toEventDate, accountId,
                                                            adId, top, domain);
        }

        public static DsDomainsStatistics GetDomainsStatistics(int? campaignId, string userName, DateTime? fromEventDate, DateTime? toEventDate, int accountId, long? adId, int? top)
        {
            return ReferralsDataAccess.GetDomainsStatistics(campaignId, userName, fromEventDate, toEventDate, accountId,
                                                            adId, top);
        }
    }
}