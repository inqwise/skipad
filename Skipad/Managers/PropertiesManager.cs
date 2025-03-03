using System.Collections.Generic;
using Inqwise.Skipad.Common;
using System;
using Inqwise.Skipad.Dal;
using Inqwise.Skipad.Entities;

namespace Inqwise.Skipad.Managers
{
    public class PropertiesManager
    {
        public static IEnumerable<IPropertyGroup> GetGroups()
        {
            var reader = PropertiesDataAccess.GetGroupsDataReader();
            var list = new List<IPropertyGroup>();

            while (reader.Read())
            {
                list.Add(new PropertyGroup(reader));
            }

            return list;
        }

        public static IEnumerable<IProperty> GetProperties(int accountId, string userName, int groupId, int packageId)
        {
            var reader = PropertiesDataAccess.GetPropertiesDataReader(accountId, userName, groupId, packageId);
            var list = new List<IProperty>();

            while (reader.Read())
            {
                list.Add(new Property(reader));
            }

            return list;
        }

        public static void UpdateProperties(int accountId, string userName, int propertyGroupId, IEnumerable<IUpdatePropertyArgs> args, int packageId)
        {
            PropertiesDataAccess.UpdateProperties(accountId, userName, propertyGroupId, args, packageId);
        }
    }
}