using System;
using System.Collections.Generic;
using Jayrock.Json;

namespace Inqwise.Skipad.Common
{
    public enum ResourceType : short
    {
        Undefined = 0,
        Video = 1,
        Image = 2,
        Javascript = 3,
        Flash = 4,
        Audio = 5,
    }

    public enum ResourceRole : short
    {
        Undefined = 0,
        SliderValid = 1,
    }

    public interface IResource : IEnumerable<IResourceFile>
    {
        long Id { get; }
        string Name { get; }
        string Description { get; }
        ResourceType ResourceType { get; }
        DateTime InsertDate { get; }
        JsonObject ToJson();
        string ClickUrl { get; }
        IEnumerable<IResourceFile> Files { get; }
        long? AdId { get; }
        TimeSpan? Duration { get; }
        string FolderName { get; }
        ResourceRole Role { get; }
        long Copy(string username);
    }
}