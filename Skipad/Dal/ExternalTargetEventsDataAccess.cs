using System.Collections.Generic;
using System.Data;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using Inqwise.Skipad.Common;

namespace Inqwise.Skipad.Dal
{
    public class ExternalTargetEventsDataAccess : DataAccess
    {
        private const string ENTITY_ID_PARAM_NAME = "@EntityId";
        private const string ENTITY_TYPE_ID_PARAM_NAME = "@EntityTypeId";
        private const string ACCOUNT_ID_PARAM_NAME = "@AccountId";
        private const string USERNAME_PARAM_NAME = "@UserName";
        private const string EXTERNAL_TARGET_EVENTS_PARAM_NAME = "@TargetEventsList";
        

        private const string GET_EXTERNAL_TARGET_EVENTS_SP_NAME = "ExternalTargetEvents_GetByEntityId";
        private const string UPDATE_EXTERNAL_TARGET_EVENTS_SP_NAME = "ExternalTargetEvents_SetData";

        public static IDataReader GetMenyDataReader(long adId)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(GET_EXTERNAL_TARGET_EVENTS_SP_NAME))
            {
                db.AddInParameter(command, ENTITY_ID_PARAM_NAME, DbType.Int64, adId);
                db.AddInParameter(command, ENTITY_TYPE_ID_PARAM_NAME, DbType.Int32, 2/*1-Campaign, 2-Ad*/);

                return db.ExecuteReader(command);
            }
        }

        public static void Update(long adId, int accountId, string username, IEnumerable<IUpdateExternalTargetEventArgs> args)
        {
            var db = (SqlDatabase)Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(UPDATE_EXTERNAL_TARGET_EVENTS_SP_NAME))
            {
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, ENTITY_ID_PARAM_NAME, DbType.Int64, adId);
                db.AddInParameter(command, ENTITY_TYPE_ID_PARAM_NAME, DbType.Int32, 2/*1-Campaign, 2-Ad*/);

                var table = BuildTargetEventsDataTable(args);
                db.AddInParameter(command, EXTERNAL_TARGET_EVENTS_PARAM_NAME, SqlDbType.Structured, table);

                db.ExecuteNonQuery(command);
            }
        }

        private static DataTable BuildTargetEventsDataTable(IEnumerable<IUpdateExternalTargetEventArgs> args)
        {
            var table = new DataTable("TargetEventsTable");
            var urlColumn = table.Columns.Add("URL", typeof(string));
            var eventTypeIdColumn = table.Columns.Add("EventTypeId", typeof(int));

            foreach (var arg in args)
            {
                var row = table.NewRow();
                row[urlColumn] = arg.Url;
                row[eventTypeIdColumn] = arg.EventTypeId;
                table.Rows.Add(row);
            }

            return table;
        }
    }
}