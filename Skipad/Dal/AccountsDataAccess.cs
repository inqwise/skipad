using System.Data;

namespace Inqwise.Skipad.Dal
{
    public class AccountsDataAccess : DataAccess
    {
        // PARAMS
        private const string ACCOUNT_ID_PARAM_NAME = "@AccountId";
        private const string ACCOUNT_EXTERNAL_ID_PREFIX_PARAM_NAME = "@ExternalIdPrefix";
        private const string ACCOUNT_NAME_PARAM_NAME = "@AccountName";
        private const string USERNAME_PARAM_NAME = "@UserName";

        // PROCS
        private const string INSERT_ACCOUNT_SP_NAME = "Accounts_AddNewAccount";
        private const string UPDATE_ACCOUNT_SP_NAME = "[dbo].[Accounts_UpdateAccount]";
        private const string GET_ACCOUNTS_SP_NAME = "[dbo].[Accounts_GetAccounts]";
        private const string GET_ACCOUNT_SP_NAME = "[dbo].[Accounts_GetAccounts]";

        public static int Insert(string username, string accountName, string accountExternalIdPrefix)
        {
            int id;

            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(INSERT_ACCOUNT_SP_NAME))
            {
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, ACCOUNT_NAME_PARAM_NAME, DbType.String, accountName);
                db.AddInParameter(command, ACCOUNT_EXTERNAL_ID_PREFIX_PARAM_NAME, DbType.String, accountExternalIdPrefix);
                db.AddOutParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, sizeof(int));
                db.ExecuteNonQuery(command);

                id = (int)db.GetParameterValue(command, ACCOUNT_ID_PARAM_NAME);
            }

            return id;
        }

        public static void Update(int accountId, string accountName, string username)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(UPDATE_ACCOUNT_SP_NAME))
            {
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, ACCOUNT_NAME_PARAM_NAME, DbType.String, accountName);
                db.ExecuteNonQuery(command);
            }
        }

        public static IDataReader GetMenyDataReader(string username)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(GET_ACCOUNTS_SP_NAME))
            {
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                return db.ExecuteReader(command);
            }
        }

        public static IDataReader GetDataReader(int id, string username)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(GET_ACCOUNT_SP_NAME))
            {
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, id);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                return db.ExecuteReader(command);
            }
        }
    }
}