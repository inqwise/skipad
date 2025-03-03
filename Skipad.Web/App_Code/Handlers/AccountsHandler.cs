using System;
using Jayrock.Json;
using Inqwise.Skipad.Common.Errors;
using Inqwise.Skipad.Managers;

namespace Handlers
{
    public class AccountsHandler : BaseHandler<JsonObject>
    {
        // ARGS
        private const string ACCOUNT_NAME_ARG_NAME = "name";
        private const string ACCOUNT_ID_ARG_NAME = "accountId";
        private const string CREATE_DATE_ARG_NAME = "createDate";
        private const string ACCOUNT_EXTERNAL_ID_ARG_NAME = "externalId";
        private const string PACKAGE_ID_ARG_NAME = "themeId";

        // FUNCTIONS
        private const string GET_METHOD_NAME = "get";
        private const string MODIFY_METHOD_NAME = "update";

        protected override JsonObject Process(string methodName, JsonObject args)
        {
            JsonObject output;
            switch (methodName)
            {
                case GET_METHOD_NAME:
                    output = Get(args);
                    break;
                case MODIFY_METHOD_NAME:
                    output = Modify(args);
                    break;
                default:
                    output = GetMethodNotFoundJson(methodName);
                    break;
            }

            return output;
        }

        private JsonObject Modify(JsonObject args)
        {
            int id = args.GetInt(ACCOUNT_ID_ARG_NAME);
            string accountName = args.GetString(ACCOUNT_NAME_ARG_NAME);
            AccountsManager.Modify(id, accountName, UserName);
            return GetJsonOk();
        }

        private JsonObject Get(JsonObject args)
        {
            JsonObject output;
            int id = args.GetInt(ACCOUNT_ID_ARG_NAME);
            var account = AccountsManager.Get(id, UserName);

            if (null == account)
            {
                output = GetErrorJson(SkipadErrors.NoResults);
            }
            else
            {
                output = new JsonObject();
                output.Put(ACCOUNT_EXTERNAL_ID_ARG_NAME, account.ExternalId);
                output.Put(CREATE_DATE_ARG_NAME, account.CreateDate.ToString(DATE_FORMAT));
                output.Put(ACCOUNT_ID_ARG_NAME, account.Id);
                output.Put(ACCOUNT_NAME_ARG_NAME, account.Name);
                output.Put(PACKAGE_ID_ARG_NAME, account.PackageId);
            }
            return output;
        }
    }
}