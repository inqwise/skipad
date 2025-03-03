using System.Linq;
using Jayrock.Json;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Common.Errors;
using Inqwise.Skipad.Managers;

namespace Handlers
{
    public class TargetEventsHandler : BaseHandler<JsonObject>
    {
        // FUNCTIONS
        private const string GET_MENY_METHOD_NAME = "getList";
        private const string MODIFY_METHOD_NAME = "modify";
        
        protected override JsonObject Process(string methodName, JsonObject args)
        {
            JsonObject output;
            switch (methodName)
            {
                case GET_MENY_METHOD_NAME:
                    output = GetMeny(args);
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

        private struct UpdateExternalTargetEvent : IUpdateExternalTargetEventArgs
        {
            public int EventTypeId { get; set; }
            public string Url { get; set; }
        }

        private JsonObject Modify(JsonObject args)
        {
            var accountId = args.GetInt("accountId");
            var adId = args.GetInt("adId");
            var eventsArr = (JsonArray)args["list"];
            var events = (from JsonObject eventJo in eventsArr
                              select new UpdateExternalTargetEvent
                              {
                                  EventTypeId = eventJo.GetInt("propertyTypeId"),
                                  Url = eventJo.OptStringTrim("value")
                              }).Cast<IUpdateExternalTargetEventArgs>();


            ExternalTargetEventsManager.Modify(adId, accountId, UserName, events);

            return GetJsonOk();
        }

        private JsonObject GetMeny(JsonObject args)
        {
            JsonObject output = null;

            //var accountId = args.GetInt("accountId");
            var adId = args.GetInt("adId");
            var targetEvents = ExternalTargetEventsManager.GetMeny(adId);

            if (null == targetEvents || !targetEvents.Any())
            {
                output = GetErrorJson(SkipadErrors.NoResults);
            }
            else
            {
                output = new JsonObject();
                var ja = new JsonArray();
                foreach (var targetEvent in targetEvents)
                {
                    var jo = new JsonObject();

                    jo.Put("url", targetEvent.Url);
                    jo.Put("eventTypeId", targetEvent.EventTypeId);
                    ja.Add(jo);
                }

                output.Put(LIST_PARAM_NAME, ja);
            }

            return output;
        }
    }
}