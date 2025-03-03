using System;
using System.Data;
using Inqwise.Skipad.Common;

namespace Inqwise.Skipad.Entities
{
    public class Account : IAccount
    {
        public static class ColumnNames
        {
            public const string Name = "AccountName";
            public const string AccountId = "AccountId";
            public const string ExternalId = "AccountExternalId";
            public const string CreateDate = "CreateDate";
            public const string IsDefault = "IsDefault";
            public const string PackageId = "AccountPropertyPackageId";
        }

        public Account(IDataReader reader)
        {
            Id = Convert.ToInt32(reader[ColumnNames.AccountId]);
            ExternalId = reader[ColumnNames.ExternalId].ToString();
            Name = reader[ColumnNames.Name].ToString();
            CreateDate = Convert.ToDateTime(reader[ColumnNames.CreateDate]);
            var objIsDefault = reader[ColumnNames.IsDefault];
            if (!Convert.IsDBNull(objIsDefault))
            {
                IsDefault = Convert.ToBoolean(objIsDefault); 
            }
            var objPackageId = reader[ColumnNames.PackageId];
            if (!Convert.IsDBNull(objPackageId))
            {
                PackageId = Convert.ToInt32(objPackageId);
            }
        }

        public long Id { get; private set; }
        public string ExternalId { get; private set; }
        public string Name { get; private set; }
        public DateTime CreateDate { get; private set; }
        public bool? IsDefault { get; private set; }
        public int? PackageId { get; private set; }
    }
}