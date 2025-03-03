using System;

namespace Inqwise.Skipad.Common
{
    public enum PackageLevel
    {
        Default = 0,
        Account = 1,
        Campaign = 2,
    }

    public interface IPackage
    {
        int Id { get; }
        string Name { get; }
        int AccountId { get; }
        PackageLevel? PackageLevel { get; }
        string ExternalId { get; }
        DateTime ModifyDate { get; }
    }
}