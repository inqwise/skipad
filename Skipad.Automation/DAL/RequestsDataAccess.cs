using System;
using System.Data;
using System.Data.SqlClient;

namespace Inqwise.Skipad.Automation.DAL
{
    public class RequestsDataAccess : DataAccess
    {
        private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();

        public static void InsertBulk(DataTable skipAdRequests)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);

            using (var connection = (SqlConnection)db.CreateConnection())
            {
                SqlTransaction transaction = null;
                connection.Open();
                try
                {
                    using (transaction = connection.BeginTransaction())
                    {
                        using (var bulkCopy = new SqlBulkCopy(connection, SqlBulkCopyOptions.Default, transaction))
                        {
                            bulkCopy.DestinationTableName = "SkipAdTemp.dbo.RequestsQueue";
                            bulkCopy.BatchSize = 500;

                            foreach (DataColumn column in skipAdRequests.Columns)
                            {
                                bulkCopy.ColumnMappings.Add(column.ColumnName, column.ColumnName);
                            }
                            // Write from the source to the destination.
                            bulkCopy.WriteToServer(skipAdRequests);
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