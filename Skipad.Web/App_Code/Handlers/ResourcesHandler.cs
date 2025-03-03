using System;
using System.Collections.Generic;
using System.Linq;
using System.Resources;
using Jayrock.Json;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Managers;

namespace Handlers
{
    public class ResourcesHandler : BaseHandler<JsonObject>
    {
        private const string DELETE_MENY_METHOD_NAME = "deleteResources";
        private const string GET_MENY_METHOD_NAME = "getResources";
        private const string GET_METHOD_NAME = "getResource";
        private const string RESOURCE_TYPE_ID_ARG_NAME = "resourceTypeId";
        private const string DELETE_MENY_FILES_METHOD_NAME = "removeResourceFiles";

        protected override JsonObject Process(string methodName, JsonObject args)
        {
            JsonObject output;
            switch (methodName)
            {
                case GET_MENY_METHOD_NAME:
                    output = GetMeny(args);
                    break;
                case GET_METHOD_NAME:
                    output = Get(args);
                    break;
                case DELETE_MENY_METHOD_NAME:
                    output = DeleteMeny(args);
                    break;
                case DELETE_MENY_FILES_METHOD_NAME:
                    output = DeleteMenyFiles(args);
                    break;
                default:
                    output = GetMethodNotFoundJson(methodName);
                    break;
            }

            return output;
        }

        private JsonObject DeleteMenyFiles(JsonObject args)
        {
            IEnumerable<long> ids = args.GetMenyLong(LIST_PARAM_NAME);
            
            ResourcesManager.DeleteFiles(ids, UserName);
            return GetJsonOk();
        }

        private JsonObject DeleteMeny(JsonObject args)
        {
            throw new System.NotImplementedException();
        }

        private JsonObject Get(JsonObject args)
        {
            throw new System.NotImplementedException();
        }

        private JsonObject GetMeny(JsonObject args)
        {
            var output = new JsonObject();
            int? resourceTypeId = args.OptInt(RESOURCE_TYPE_ID_ARG_NAME);
            ResourceType? resourceType = null;
            if (resourceTypeId.HasValue)
            {
                resourceType = (ResourceType) resourceTypeId;
            }

            var resources = ResourcesManager.GetMeny(UserName, resourceType);

            var resourcesJa = new JsonArray();
            foreach (var resource in resources)
            {
                var jo = resource.ToJson();
                var file = resource.FirstOrDefault();
                if (null != file)
                {
                    jo.Put("url", ResourcesManager.GetResourceUrl(file));
                }
                resourcesJa.Add(jo);
            }

            output.Put(LIST_PARAM_NAME, resourcesJa);

            return output;
        }
    }
}