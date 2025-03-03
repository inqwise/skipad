using System;
using System.Collections.Generic;
using Jayrock.Json;

namespace Inqwise.Skipad.Common
{
    public interface IAd : IEnumerable<IResource>
    {
        long Id { get; }
        string Name { get; }
        Guid? Auid { get; }
        int CampaignId { get; }
        IResource Video { get; }
        IResource Image { get; }
        string Description { get; }
        DateTime ModifyDate { get; }
        JsonObject ToJson();
        IEnumerable<IResource> Resources { get; }
        string CampaignName { get; }
        string ExternalTagUrl { get; }
        string SurveyUrl { get; }
        long Copy(string name, string username);
        AdType AdType { get; }
        IResource Audio { get; }
        bool IsActive { get; }
    }
}