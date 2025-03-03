using System;
using System.Data;
using Inqwise.Skipad.Common;

namespace Inqwise.Skipad.Entities
{
    public class PropertyGroup : IPropertyGroup
    {
        public PropertyGroup(IDataReader reader)
        {
            PropertyGroupId = Convert.ToInt32(reader["PropertyGroupId"]);
            Name = reader["PropertyGroupName"].ToString();
            Key = reader["KeyName"].ToString();
        }

        public int PropertyGroupId { get; private set; }
        public string Name { get; private set; }
        public string Key { get; private set; }
    }
}