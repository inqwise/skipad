using System;
using System.Collections;
using System.Collections.Generic;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Dal;
using Inqwise.Skipad.Entities;

namespace Inqwise.Skipad.Managers
{
    public class ExternalTargetEventsManager
    {
        public static IEnumerable<IExternalTargetEvent> GetMeny(long adId)
        {
            var reader = ExternalTargetEventsDataAccess.GetMenyDataReader(adId);
            var list = new List<IExternalTargetEvent>();

            while (reader.Read())
            {
                list.Add(new ExternalTargetEvent(reader));
            }

            return list;
        }

        public static void Modify(long adId, int accountId, string username, IEnumerable<IUpdateExternalTargetEventArgs> args)
        {
            ExternalTargetEventsDataAccess.Update(adId, accountId, username, args);
        }
    }
}