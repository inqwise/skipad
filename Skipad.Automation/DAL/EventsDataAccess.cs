using System;
using System.Data;
using System.Data.SqlClient;

namespace Inqwise.Skipad.Automation.DAL
{
    public class EventsDataAccess : DataAccess
    {
        private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();

        private const string INSERT_EVENTS_SP_NAME = "SP_AddNewEvents";
        private const string EVENTS_PARAM_NAME = "@EventsList";
        public static void InsertEvents(DataTable skipAdEvents)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = (SqlCommand) db.GetStoredProcCommand(INSERT_EVENTS_SP_NAME))
            {
                var eventsParam = new SqlParameter(EVENTS_PARAM_NAME, SqlDbType.Structured);
                eventsParam.Value = skipAdEvents;
                command.Parameters.Add(eventsParam);
                command.CommandTimeout = 180;

                db.ExecuteNonQuery(command);
            }
        }

        public static void InsertEventsBulk(DataTable skipAdEvents)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);

            using (var connection = (SqlConnection) db.CreateConnection())
            {
                SqlTransaction transaction = null;
                connection.Open();
                try
                {
                    using (transaction = connection.BeginTransaction())
                    {
                        using (var bulkCopy = new SqlBulkCopy(connection, SqlBulkCopyOptions.Default, transaction))
                        {
                            bulkCopy.DestinationTableName = "SkipAdTemp.dbo.EventsQueue";
                            bulkCopy.BatchSize = 500;
                            foreach (DataColumn column in skipAdEvents.Columns)
                            {
                                bulkCopy.ColumnMappings.Add(column.ColumnName, column.ColumnName);
                            }
                            // Write from the source to the destination.
                            bulkCopy.WriteToServer(skipAdEvents);
                            transaction.Commit();
                        }
                    }
                }
                catch (Exception ex)
                {
                    try
                    {
                        if (null != transaction) transaction.Rollback();
                    }
                    catch (Exception subEx)
                    {
                        Log.Error(subEx);
                    }
                    throw;
                }
                finally
                {
                    connection.Close();
                }
            }
        }
    }
}