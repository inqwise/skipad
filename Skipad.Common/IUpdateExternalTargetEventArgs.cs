namespace Inqwise.Skipad.Common
{
    public interface IUpdateExternalTargetEventArgs
    {
        int EventTypeId { get; }
        string Url { get; }
    }
}