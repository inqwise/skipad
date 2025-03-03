using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using Jayrock.Json;
using Inqwise.Skipad.Automation.DAL;

namespace Inqwise.Skipad.Automation.Managers
{
    public class SkipadEventsManager
    {
        private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();

        private static readonly Lazy<string[]> _expectedColumnNames = new Lazy<string[]>(() => ConfigurationManager.AppSettings["Events:ExpectedColumnNames"].SplitOrDefault());

        public static string[] ExpectedColumnNames
        {
            get { return _expectedColumnNames.Value; }
        }

        private static readonly Lazy<string> _failureFolderName = new Lazy<string>(() => ConfigurationManager.AppSettings["Events:FailureFolder"] ?? "failures");

        public static string FailureFolderName
        {
            get { return _failureFolderName.Value; }
        }

        public static bool HandleSingleS3Object()
        {
            return S3Helper.ReadS3Data(ApplicationConfig.Amazon.AccessKey.Value, ApplicationConfig.Amazon.SecretKey.Value, ApplicationConfig.Amazon.BuckletName.Value, ApplicationConfig.Amazon.EventsPrefix.Value, PrepareAndSendDataTable, ExpectedColumnNames, FailureFolderName);
        }

        private static DataTable PrepareAndSendDataTable(IEnumerable<KeyValuePair<string, Type>> header, IEnumerable<JsonObject> list)
        {
            int count = 0;
            var t = new DataTable("table1");
            var columns = new Dictionary<string, DataColumn>();

            var rowIdColumn = new DataColumn("rowId", typeof(int));
            t.Columns.Add(rowIdColumn);
            foreach (var headerItem in header)
            {
                var dataColumn = new DataColumn(headerItem.Key, headerItem.Value);
                columns.Add(headerItem.Key, dataColumn);
                t.Columns.Add(dataColumn);
            }

            foreach (var item in list)
            {
                var row = t.NewRow();
                row[rowIdColumn] = ++count;
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
            EventsDataAccess.InsertEventsBulk(dt);
            sw.Stop();
            Log.Debug("SendDataTable took {0} msec", sw.ElapsedMilliseconds);
        }
    }
}