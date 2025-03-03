using System.Collections.Generic;
using System.Data;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using Inqwise.Skipad.Common;

namespace Inqwise.Skipad.Dal
{
    public class PropertiesDataAccess : DataAccess
    {
        // PARAMS
        private const string GROUP_ID_PARAM_NAME = "@PropertyGroupId";
        private const string ACCOUNT_ID_PARAM_NAME = "@AccountId";
        private const string USERNAME_PARAM_NAME = "@UserName";
        private const string PROPERTIES_PARAM_NAME = "@TblAccountProperties";
        private const string PACKAGE_ID_PARAM_NAME = "@AccountPropertyPackageId";
        
        // PROCS
        private const string GET_GROUPS_SP_NAME = "[dbo].[PropertyGroups_GetData]";
        private const string GET_PROPERTIES_SP_NAME = "[dbo].[PropertyGroups_GetAccountProperties]";
        private const string UPDATE_PROPERTIES_SP_NAME = "[dbo].[PropertyGroups_SetAccountProperties]";

        public static IDataReader GetGroupsDataReader()
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(GET_GROUPS_SP_NAME))
            {
                return db.ExecuteReader(command);
            }
        }

        public static IDataReader GetPropertiesDataReader(int accountId, string username, int groupId, int packageId)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(GET_PROPERTIES_SP_NAME))
            {
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                db.AddInParameter(command, GROUP_ID_PARAM_NAME, DbType.Int32, groupId);
                db.AddInParameter(command, PACKAGE_ID_PARAM_NAME, DbType.Int32, packageId);
                return db.ExecuteReader(command);
            }
        }

        public static void UpdateProperties(int accountId, string username, int groupId, IEnumerable<IUpdatePropertyArgs> args, int packageId)
        {
            var db = (SqlDatabase)Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(UPDATE_PROPERTIES_SP_NAME))
            {
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, PACKAGE_ID_PARAM_NAME, DbType.Int32, packageId);

                var table = BuildResourcesDataTable(groupId, args);
                db.AddInParameter(command, PROPERTIES_PARAM_NAME, SqlDbType.Structured, table);
                
                db.ExecuteNonQuery(command);
            }
        }

        private static DataTable BuildResourcesDataTable(int propertyGroupId, IEnumerable<IUpdatePropertyArgs> args)
        {
            var table = new DataTable("AccountPropertiesTable");
            var groupTypeIdColumn = table.Columns.Add("PropertyGroupId", typeof(int));
            var propertyTypeIdColumn = table.Columns.Add("PropertyTypeId", typeof(int));
            var valueColumn = table.Columns.Add("PropertyValue", typeof(string));

            foreach (var arg in args)
            {
                var row = table.NewRow();
                row[groupTypeIdColumn] = propertyGroupId;
                row[propertyTypeIdColumn] = arg.PropertyTypeId;
                row[valueColumn] = arg.Value;
                table.Rows.Add(row);
            }

            return table;
        }
    }
}