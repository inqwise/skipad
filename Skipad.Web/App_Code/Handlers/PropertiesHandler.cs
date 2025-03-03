using System.Collections.Generic;
using System.Linq;
using Jayrock.Json;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Common.Errors;
using Inqwise.Skipad.Managers;

namespace Handlers
{
    public class PropertiesHandler : BaseHandler<JsonObject>
    {
        private const string GET_PROPERTIES_METHOD_NAME = "getProperties";
        private const string GET_GROUPS_NAME = "getGroups";
        private const string MODIFY_PROPERTIES_NAME = "updateProperties";

        protected override JsonObject Process(string methodName, JsonObject args)
        {
            JsonObject output;
            switch (methodName)
            {
                case GET_PROPERTIES_METHOD_NAME:
                    output = GetProperties(args);
                    break;
                case GET_GROUPS_NAME:
                    output = GetGroups(args);
                    break;
                case MODIFY_PROPERTIES_NAME:
                    output = ModifyProperties(args);
                    break;
                default:
                    output = GetMethodNotFoundJson(methodName);
                    break;
            }

            return output;
        }

        private struct UpdatePropertyArgs : IUpdatePropertyArgs
        {
            public int PropertyTypeId { get; set; }
            public string Value { get; set; }
        }

        private JsonObject ModifyProperties(JsonObject args)
        {
            var accountId = args.GetInt("accountId");
            var groupId = args.GetInt("groupId");
            var packageId = args.GetInt("themeId");
            var propertiesArr = (JsonArray)args["list"];
            var properties = (from JsonObject propertyJo in propertiesArr
                              select new UpdatePropertyArgs
                                  {
                                      PropertyTypeId = propertyJo.GetInt("propertyTypeId"), Value = propertyJo.OptStringTrim("value")
                                  }).Cast<IUpdatePropertyArgs>();


            PropertiesManager.UpdateProperties(accountId, UserName, groupId, properties, packageId);

            return GetJsonOk();
        }

        private JsonObject GetGroups(JsonObject args)
        {
            JsonObject output = null;

            var groups = PropertiesManager.GetGroups();

            if (null == groups || !groups.Any())
            {
                output = GetErrorJson(SkipadErrors.NoResults);
            }
            else
            {
                output = new JsonObject();
                var ja = new JsonArray();
                foreach (var group in groups)
                {
                    var jo = new JsonObject();

                    jo.Put("groupId", group.PropertyGroupId);
                    jo.Put("name", group.Name);
                    ja.Add(jo);
                }

                output.Put(LIST_PARAM_NAME, ja);
            }

            return output;
        }

        private JsonObject GetProperties(JsonObject args)
        {
            JsonObject output = null;

            var accountId = args.GetInt("accountId");
            var groupId = args.GetInt("groupId");
            var packageId = args.GetInt("themeId");
            var properties = PropertiesManager.GetProperties(accountId, UserName, groupId, packageId);

            if (null == properties || !properties.Any())
            {
                output = GetErrorJson(SkipadErrors.NoResults);
            }
            else
            {
                output = new JsonObject();
                var ja = new JsonArray();
                foreach (var property in properties)
                {
                    var jo = new JsonObject();

                    jo.Put("propertyTypeName", property.PropertyTypeName);
                    jo.Put("propertyTypeId", property.PropertyTypeId);
                    jo.Put("value", property.Value);
                    jo.Put("valueTypeId", property.ValueTypeId);
                    if (null != property.Value && property.Inherited)
                    {
                        jo.Put("inherited", true);
                    }
                    jo.Put("isAdvanced", property.IsAdvanced);
                    jo.Put("description", property.PropertyTypeDescription);
                    jo.Put("example", property.PropertyTypeExample);
                    ja.Add(jo);
                }

                output.Put(LIST_PARAM_NAME, ja);
            }

            return output;
        }
    }
}