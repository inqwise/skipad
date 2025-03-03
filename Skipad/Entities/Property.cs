using System;
using System.Data;
using Inqwise.Skipad.Common;

namespace Inqwise.Skipad.Entities
{
    public class Property : IProperty
    {
        public Property(IDataReader reader)
        {
            PropertyGroupId = Convert.ToInt32(reader["PropertyGroupId"]);
            PropertyTypeId = Convert.ToInt32(reader["PropertyTypeId"]);
            var keyObj = reader["PropertyKeyName"];
            Key = Convert.IsDBNull(keyObj) ? null : keyObj.ToString();
            ValueTypeId = Convert.ToInt32(reader["PropertyValueTypeId"]);
            var valueObj = reader["PropertyValue"];
            Value = Convert.IsDBNull(valueObj) ? null : valueObj.ToString();
            PropertyTypeName = reader["PropertyTypeName"].ToString();
            Inherited = Convert.ToBoolean(reader["Inherited"]);
            IsAdvanced = Convert.ToBoolean(reader["IsAdvanced"]);
            var descriptionObj = reader["Description"];
            PropertyTypeDescription = Convert.IsDBNull(descriptionObj) ? null : descriptionObj.ToString();
            var exampleObj = reader["Example"];
            PropertyTypeExample = Convert.IsDBNull(exampleObj) ? null : exampleObj.ToString();
        }

        public int PropertyGroupId { get; private set; }
        public int PropertyTypeId { get; private set; }
        public string Key { get; private set; }
        public int ValueTypeId { get; private set; }
        public string Value { get; private set; }
        public string PropertyTypeName { get; private set; }
        public bool Inherited { get; private set; }
        public string PropertyTypeDescription { get; private set; }
        public string PropertyTypeExample { get; private set; }
        public bool IsAdvanced { get; private set; }
    }
}