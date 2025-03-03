using System;
using System.Collections.Generic;
using System.Data;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Dal;
using Inqwise.Skipad.Entities;

namespace Inqwise.Skipad.Managers
{
    public class CampaignsManager
    {
        public static List<ICampaign> GetMeny(string username, int accountId)
        {   
            var reader = CampaignsDataAccess.GetMenyDataReader(username, accountId);
            var list = new List<ICampaign>();

            while (reader.Read())
            {
                list.Add(new Campaign(reader));
            }

            return list;
        }

        public static void Delete(int id, string username)
        {
            CampaignsDataAccess.Delete(id, username);
        }

        public static void Modify(int id, string name, string description, string username)
        {
            CampaignsDataAccess.Update(id, name, description, username);
        }

        public static int Create(string name, string description, string username, int accountId)
        {
            return CampaignsDataAccess.Insert(name, description, username, accountId);
        }

        public static ICampaign Get(int id, string username, int accountId)
        {
            var reader = CampaignsDataAccess.GetDataReader(id, username, accountId);
            ICampaign campaign = null;

            if (reader.Read())
            {
                campaign = new Campaign(reader);
            }

            return campaign;
        }

        public static DsCampaignsStatistics GetStatistics(string username, DateTime? fromEventDate, DateTime? toEventDate, int accountId, IEnumerable<int> campaignsList)
        {
            return CampaignsDataAccess.GetStatistics(username, fromEventDate, toEventDate, accountId, campaignsList);
        }

        public static DsCampaignsOverallStatistics GetOverallStatistics(string userName, DateTime? fromEventDate, DateTime? toEventDate, int? campaignId, int accountId)
        {
            return CampaignsDataAccess.GetOverallStatistics(userName, fromEventDate, toEventDate, campaignId, accountId);
        }
    }
}