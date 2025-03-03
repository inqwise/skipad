using Jayrock.Json;

namespace Inqwise.Skipad.Common
{
    public enum ResourceFilePathType
    {
        Undefined = 0,
        Relative = 1,
        Absolute = 2,
    }

    public interface IResourceFile
    {
        long Id { get; }
        string Path { get; }
        string ContentType { get; }
        int? Width { get; }
        int? Height { get; }
        int? Bitrate { get; }
        string Extension { get; }
        JsonObject ToJson();
        long ResourceId { get; }
        ResourceFilePathType PathType { get; }
        IResource Resource { get; }
        IResourceFile Thumbnail { get; }
    }
}