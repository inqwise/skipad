namespace Inqwise.Skipad.Common
{
    public interface ICreateResourceFileRequest
    {
        long? ResourceFileId { get; }
        bool IsThumbnail { get; }
        string Path { get; }
        string ContentType { get; }
        string Extension { get; }
        int? Width { get; }
        int? Height { get; }
        double? Bitrate { get; }
        ResourceFilePathType PathType { get; }
        string Name { get; }
    }
}