namespace Inqwise.Skipad.Common
{
    public interface IExternalTargetEvent
    {
        string Url { get; }
        int EventTypeId { get; }
    }
}