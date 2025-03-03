using System;
using System.Collections.Generic;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Dal;
using Inqwise.Skipad.Entities;

namespace Inqwise.Skipad.Managers
{
    public class PackagesManager
    {
        public static IEnumerable<IPackage> GetMeny(int accountId, string userName)
        {
            var reader = PackagesDataAccess.GetMenyDataReader(accountId, userName);
            var list = new List<IPackage>();

            while (reader.Read())
            {
                list.Add(new Package(reader));
            }

            return list;
        }

        public static int Create(int accountId, string packageName, PackageLevel packageLevel)
        {
            string externalIdPrefix = GenerateExternalIdPrefix();
            return PackagesDataAccess.Insert(accountId, externalIdPrefix, packageName, packageLevel);
        }

        private static string GenerateExternalIdPrefix()
        {
            var now = DateTime.Now;
            var ds = new TimeSpan(0, 0, now.Year + now.Month + now.Hour + now.Minute + now.Second + now.Millisecond);
            return string.Format("{0:X}-", ds.Ticks / 100 / 100 / 60);
        }

        public static void Delete(int packageId, int accountId, string userName)
        {
            PackagesDataAccess.Delete(packageId, accountId, userName);
        }

        public static void Modify(int packageId, string packageName, string username)
        {
            PackagesDataAccess.Update(packageId, packageName, username);
        }

        public static void Assign(int? packageId, int accountId, string username, int? entityId, int? levelId)
        {
            PackagesDataAccess.Assign(packageId, accountId, username, entityId, levelId);
        }

        public static IPackage Get(int? packageId, string userName, string packageExternalId)
        {
            IPackage result = null;
            using (var reader = PackagesDataAccess.GetDataReader(packageId, userName, packageExternalId))
            {
                if (reader.Read())
                {
                    result = new Package(reader);
                }
            }
            return result;
        }
    }
}