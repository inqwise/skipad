using System;

namespace Inqwise.Skipad.Common
{
    public interface IAccount
    {
        long Id { get; }
        string ExternalId { get; }
        string Name { get; }
        DateTime CreateDate { get; }
        bool? IsDefault { get; }
        int? PackageId { get; }
    }
}