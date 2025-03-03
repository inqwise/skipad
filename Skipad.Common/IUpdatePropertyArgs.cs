namespace Inqwise.Skipad.Common
{
    public interface IUpdatePropertyArgs
    {
        int PropertyTypeId { get; }
        string Value { get; }
    }
}