namespace Inqwise.Skipad.Common
{
    public interface IProperty
    {
        int PropertyGroupId { get; }
        int PropertyTypeId { get; }
        string Key { get; }
        int ValueTypeId { get; }
        string Value { get; }
        string PropertyTypeName { get; }
        bool Inherited { get; }
        string PropertyTypeDescription { get; }
        string PropertyTypeExample { get; }
        bool IsAdvanced { get; }
    }
}