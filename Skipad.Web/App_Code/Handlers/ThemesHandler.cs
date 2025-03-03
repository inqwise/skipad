using System.Collections.Generic;
using Jayrock.Json;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Common.Errors;
using Inqwise.Skipad.Managers;

namespace Handlers
{
    public class ThemesHandler : BaseHandler<JsonObject>
    {
        private const string PACKAGE_ID_ARG_NAME = "themeId";
        private const string PACKAGE_NAME_ARG_NAME = "themeName";
        private const string ACCOUNT_ID_ARG_NAME = "accountId";

        // FUNCTIONS
        private const string GET_METHOD_NAME = "get";
        private const string GET_MENY_METHOD_NAME = "getList";
        private const string CREATE_METHOD_NAME = "create";
        private const string DELETE_MENY_METHOD_NAME = "deleteList";
        
        protected override JsonObject Process(string methodName, JsonObject args)
        {
            JsonObject output;
            switch (methodName)
            {
                case GET_METHOD_NAME:
                    output = Get(args);
                    break;
                case GET_MENY_METHOD_NAME:
                    output = GetMeny(args);
                    break;
                case CREATE_METHOD_NAME:
                    output = Create(args);
                    break;
                case DELETE_MENY_METHOD_NAME:
                    output = DeleteMeny(args);
                    break;
                default:
                    output = GetMethodNotFoundJson(methodName);
                    break;
            }

            return output;
        }

        private JsonObject DeleteMeny(JsonObject args)
        {
            JsonObject output = null;
            int accountId = args.GetInt(ACCOUNT_ID_ARG_NAME);
            IEnumerable<int> ids = args.GetMenyInt(LIST_PARAM_NAME);
            foreach (var id in ids)
            {
                PackagesManager.Delete(id, accountId, UserName);
            }

            return GetJsonOk();
        }

        private JsonObject Create(JsonObject args)
        {
            var output = new JsonObject();
            int accountId = args.GetInt(ACCOUNT_ID_ARG_NAME);
            string packageName = args.GetString(PACKAGE_NAME_ARG_NAME);

            var packageId = PackagesManager.Create(accountId, packageName, PackageLevel.Campaign);

            output.Put("themeId", packageId);

            return output;
        }

        private JsonObject GetMeny(JsonObject args)
        {
            var output = new JsonObject();
            int accountId = args.GetInt(ACCOUNT_ID_ARG_NAME);

            var packages = PackagesManager.GetMeny(accountId, UserName);

            var packagesJa = new JsonArray();
            foreach (var package in packages)
            {
                if (package.PackageLevel != PackageLevel.Account)
                {
                    var jo = new JsonObject();
                    jo.Put("themeId", package.Id);
                    jo.Put("themeName", package.Name);
                    jo.Put("themeExternalId", package.ExternalId);
                    jo.Put("modifyDate", package.ModifyDate.ToString(DATE_TIME_FORMAT));
                    packagesJa.Add(jo);
                }
            }

            output.Put(LIST_PARAM_NAME, packagesJa);

            return output;
        }

        private JsonObject Get(JsonObject args)
        {
            var output = new JsonObject();
            var packageId = args.GetInt(PACKAGE_ID_ARG_NAME);
            
            var package = PackagesManager.Get(packageId, UserName, null);
            if (null == package)
            {
                output = GetErrorJson(SkipadErrors.NoResults);
            }
            else
            {
                output.Put("themeId", package.Id);
                output.Put("themeName", package.Name);
                output.Put("themeExternalId", package.ExternalId);
                output.Put("modifyDate", package.ModifyDate.ToString(DATE_TIME_FORMAT));
            }

            return output;
        }
    }
}