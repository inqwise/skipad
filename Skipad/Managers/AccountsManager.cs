using System;
using System.Collections.Generic;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Dal;
using Inqwise.Skipad.Entities;

namespace Inqwise.Skipad.Managers
{
    public class AccountsManager
    {
        public static List<IAccount> GetMeny(string username)
        {
            var reader = AccountsDataAccess.GetMenyDataReader(username);
            var list = new List<IAccount>();

            while (reader.Read())
            {
                list.Add(new Account(reader));
            }

            return list;
        }

        public static IAccount Get(int id, string username)
        {
            var reader = AccountsDataAccess.GetDataReader(id, username);
            IAccount account = null;

            if (reader.Read())
            {
                account = new Account(reader);
            }

            return account;
        }

        public static int Create(string username, string accountName)
        {
            string externalIdPrefix = GenerateExternalIdPrefix();
            int accountId = AccountsDataAccess.Insert(username, accountName, externalIdPrefix);
            int packageId = PackagesManager.Create(accountId, accountName, PackageLevel.Account);
            PackagesManager.Assign(packageId, accountId, username, accountId, (int)PackageLevel.Account);

            return accountId;
        }

        private static string GenerateExternalIdPrefix()
        {
            var now = DateTime.Now;
            var ds = new TimeSpan(0, 0, now.Year + now.Month + now.Hour + now.Minute + now.Second + now.Millisecond);
            return string.Format("{0:X}-", ds.Ticks / 100 / 100 / 60);
        }

        public static void Modify(int accountId, string accountName, string username)
        {
            AccountsDataAccess.Update(accountId, accountName, username);
        }
    }
}