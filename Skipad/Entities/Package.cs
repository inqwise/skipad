using System;
using System.Data;
using Inqwise.Skipad.Common;

namespace Inqwise.Skipad.Entities
{
    public class Package : IPackage
    {
        public int Id { get; private set; }
        public string Name { get; private set; }
        public int AccountId { get; private set; }
        public PackageLevel? PackageLevel { get; private set; }
        public string ExternalId { get; private set; }
        public DateTime ModifyDate { get; private set; }

        public Package(IDataReader reader)
        {
            Id = Convert.ToInt32(reader["AccountPropertyPackageId"]);
            Name = reader["PackageName"].ToString();
            ExternalId = reader["PackageExternalId"].ToString();
            AccountId = Convert.ToInt32(reader["AccountId"]);
            PackageLevel = Convert.IsDBNull(reader["PackageLevelId"]) ? default(PackageLevel?) : (PackageLevel)Convert.ToInt32(reader["PackageLevelId"]);
            ModifyDate = Convert.IsDBNull(reader["LastModifiedDate"]) ? Convert.ToDateTime(reader["InsertDate"]) : Convert.ToDateTime(reader["LastModifiedDate"]);
        }    
    }
}