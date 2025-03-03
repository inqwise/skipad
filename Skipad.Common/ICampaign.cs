using System;
using Jayrock.Json;

namespace Inqwise.Skipad.Common
{
    public interface ICampaign
    {
        int Id { get; }
        string Name { get; }
        string Description { get; }
        DateTime InsertDate { get; }
        DateTime ModifyDate { get; }
        int? PackageId { get; }
        JsonObject ToJson();
    }
}