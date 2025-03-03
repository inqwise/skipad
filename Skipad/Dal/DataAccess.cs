using Microsoft.Practices.EnterpriseLibrary.Data;

namespace Inqwise.Skipad.Dal
{
    public abstract class DataAccess
    {
        protected const string SKIPAD_DB_NAME = "SKIPAD";
        protected static DatabaseProviderFactory Factory = new DatabaseProviderFactory();
    }
}