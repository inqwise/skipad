using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using Jayrock.Json;
using Inqwise.Skipad.Automation.DAL;

namespace Inqwise.Skipad.Automation.Managers
{
    public class SkipadRequestsManager
    {
        private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();

        private static readonly Lazy<string[]> _expectedColumnNames = new Lazy<string[]>(() => ConfigurationManager.AppSettings["Requests:ExpectedColumnNames"].SplitOrDefault());

        public static string[] ExpectedColumnNames
        {
            get { return _expectedColumnNames.Value; }
        }

        private static readonly Lazy<string> _failureFolderName = new Lazy<string>(() => ConfigurationManager.AppSettings["Requests:FailureFolder"] ?? "failures");

        public static string FailureFolderName
        {
            get { return _failureFolderName.Value; }
        }

        public static bool HandleSingleS3Object()
        {
            return S3Helper.ReadS3Data(ApplicationConfig.Amazon.AccessKey.Value, ApplicationConfig.Amazon.SecretKey.Value, ApplicationConfig.Amazon.BuckletName.Value, ApplicationConfig.Amazon.RequestsPrefix.Value, PrepareAndSendDataTable, ExpectedColumnNames, FailureFolderName);
        }

        private static DataTable PrepareAndSendDataTable(IEnumerable<KeyValuePair<string, Type>> header, IEnumerable<JsonObject> list)
        {
            var t = new DataTable("table1");
            var columns = new Dictionary<string, DataColumn>();

           foreach (var headerItem in header)
            {
                var dataColumn = new DataColumn(headerItem.Key, headerItem.Value);
                columns.Add(headerItem.Key, dataColumn);
                t.Columns.Add(dataColumn);
            }

            foreach (var item in list)
            {
                var row = t.NewRow();
                foreach (string name in item.Names)
                {
                    DataColumn column;
                    if (columns.TryGetValue(name, out column))
                    {
                        object value;
                        if ((value = item[name]) == JsonNull.Value || "null".Equals(value))
                        {
                            row[column] = DBNull.Value;
                        }
                        else
                        {
                            row[column] = value ?? DBNull.Value;
                        }
                    }
                }
                t.Rows.Add(row);
            }

            SendDataTable(t);

            return t;
        }

        private static void SendDataTable(DataTable dt)
        {
            Log.Debug("Start SendDataTable");
            var sw = Stopwatch.StartNew();
            RequestsDataAccess.InsertBulk(dt);
            sw.Stop();
            Log.Debug("SendDataTable took {0} msec", sw.ElapsedMilliseconds);
        }
    }
}
