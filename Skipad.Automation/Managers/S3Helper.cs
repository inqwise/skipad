using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using System.IO.Compression;
using System.Linq;
using Amazon;
using Amazon.S3;
using Amazon.S3.Model;
using Jayrock.Json;
using Jayrock.Json.Conversion;
using Microsoft.SqlServer.Server;

namespace Inqwise.Skipad.Automation.Managers
{
    public class S3Helper
    {
        private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();

        private static void CopyFile(IAmazonS3 storage, S3Object s3Object, string newFolder, string bucketName)
        {
            var fileName = Path.GetFileName(s3Object.Key);
            var destinationKey = newFolder + "/" + fileName;
            storage.CopyObject(new CopyObjectRequest()
                {
                    SourceBucket = bucketName,
                    SourceKey = s3Object.Key,
                    DestinationBucket = bucketName,
                    DestinationKey = destinationKey,
                    CannedACL = S3CannedACL.Private,
                });
        }

        public static bool ReadS3Data(string accessKey, string secretKey, string bucketName, string prefix,  Func<IEnumerable<KeyValuePair<string, Type>>, IEnumerable<JsonObject>, DataTable> prepareDataTable, string[] expectedColumns, string failureFolderName)
        {
            int countOfObjects;
            string fileName = null;
            S3Object o;
            bool hasMore = false;

            var s3Config = new AmazonS3Config
            {
                UseHttp = true,
                ServiceURL = "http://s3.amazonaws.com",
            };

            using (var storage = AWSClientFactory.CreateAmazonS3Client(accessKey, secretKey, s3Config))
            {
                var listObjectsRequest = new ListObjectsRequest();
                listObjectsRequest.BucketName = bucketName;
                listObjectsRequest.Prefix = prefix;
                listObjectsRequest.MaxKeys = 2;

                ListObjectsResponse listObjectsResponse = storage.ListObjects(listObjectsRequest);

                countOfObjects = listObjectsResponse.S3Objects.Count;
                hasMore = countOfObjects > 1;
                o = listObjectsResponse.S3Objects.FirstOrDefault();
                
                
                Log.Debug("ReadS3Data: Prefix: '{0}' Count of objects: {1}", prefix, countOfObjects);
                
                if (null != o)
                {
                    Log.Info("ReadS3Data: Found data in Prefix: '{0}'", prefix);
                    var getObjectRequest = new GetObjectRequest();
                    getObjectRequest.BucketName = bucketName;
                    getObjectRequest.Key = o.Key;
                    fileName = o.Key;
                    GetObjectResponse getObjectResponse = storage.GetObject(getObjectRequest);
                    bool isDelete = true;
                    try
                    {
                        var archive = new ZipArchive(getObjectResponse.ResponseStream);
                        StreamReader sr;
                        foreach (var zipArchiveEntry in archive.Entries)
                        {
                            Log.Debug("ReadS3Data: FileName: {0}", zipArchiveEntry.FullName);
                            sr = new StreamReader(zipArchiveEntry.Open());

                            string stringLine = null;
                            var list = new List<JsonObject>();
                            List<KeyValuePair<String, Type>> header = null;
                            while ((stringLine = sr.ReadLine()) != null)
                            {
                                var jo = JsonConvert.Import<JsonObject>(stringLine);
                                list.Add(jo);
                                if (null == header)
                                {
                                    header = new List<KeyValuePair<string, Type>>();
                                    foreach (string name in jo.Names)
                                    {
                                        if (null == expectedColumns ||
                                            expectedColumns.Contains(name, StringComparer.OrdinalIgnoreCase))
                                        {
                                            Type type = (name == "timeZone" ? typeof(String) : GetJsonType(jo[name])); // FIX for client
                                            header.Add(new KeyValuePair<string, Type>(name, type));
                                        }
                                    }
                                }
                            }

                            if (null != header)
                            {
                                var t = prepareDataTable(header, list);

                                Console.WriteLine(t);
                            }
                        }
                    }
                    catch (System.Net.WebException ex)
                    {
                        Log.WarnException(
                            String.Format("ReadS3Data : Failed to handle filename: '{0}'. Retry later",
                                          fileName), ex);
                        isDelete = false;
                    }
                    catch (Exception ex)
                    {
                        CopyFile(storage, o, failureFolderName, bucketName);
                        Log.ErrorException(
                            String.Format("ReadS3Data : Failed to handle filename: '{0}'. Has been moved to: '{1}'",
                                          fileName,
                                          failureFolderName), ex);
                    }

                    if (isDelete)
                    {
                        var deleteObjectRequest = new DeleteObjectRequest { BucketName = bucketName, Key = o.Key };
                        storage.DeleteObject(deleteObjectRequest); 
                    }
                }
            }

            return hasMore;
        }

        private static Type GetJsonType(object o)
        {
            Type result = null;
            string str;
            if (o is JsonNumber)
            {
                result = typeof(Int32);
            }
            else if (o is JsonString)
            {
                result = typeof(string);
            }
            else if (o is JsonNull)
            {
                result = null;
            }
            else if (null != (str = o as string))
            {
                DateTime date;
                //if (DateTime.TryParseExact(str, "EEE MMM dd HH:mm:ss z yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out date))
                result = DateTime.TryParse(str, out date) ? typeof(DateTime) : typeof(string);
            }

            return result;
        }

        private static Exception InvalidDataTypeCode(TypeCode code)
        {
            return new ArgumentException("Invalid type: " + code);
        }

        private static Exception UnknownDataType(Type clrType)
        {
            return new ArgumentException("Unknown type: " + clrType);
        }

        private static SqlMetaData SqlMetaDataFromColumn(DataColumn column, out bool coerceToString)
        {
            coerceToString = false;
            SqlMetaData sql_md = null;
            Type clrType = column.DataType;
            string name = column.ColumnName;
            switch (Type.GetTypeCode(clrType))
            {
                case TypeCode.Boolean: sql_md = new SqlMetaData(name, SqlDbType.Bit); break;
                case TypeCode.Byte: sql_md = new SqlMetaData(name, SqlDbType.TinyInt); break;
                case TypeCode.Char: sql_md = new SqlMetaData(name, SqlDbType.NVarChar, 1); break;
                case TypeCode.DateTime: sql_md = new SqlMetaData(name, SqlDbType.DateTime); break;
                case TypeCode.DBNull: throw InvalidDataTypeCode(TypeCode.DBNull);
                case TypeCode.Decimal: sql_md = new SqlMetaData(name, SqlDbType.Decimal, 18, 0); break;
                case TypeCode.Double: sql_md = new SqlMetaData(name, SqlDbType.Float); break;
                case TypeCode.Empty: throw InvalidDataTypeCode(TypeCode.Empty);
                case TypeCode.Int16: sql_md = new SqlMetaData(name, SqlDbType.SmallInt); break;
                case TypeCode.Int32: sql_md = new SqlMetaData(name, SqlDbType.Int); break;
                case TypeCode.Int64: sql_md = new SqlMetaData(name, SqlDbType.BigInt); break;
                case TypeCode.SByte: throw InvalidDataTypeCode(TypeCode.SByte);
                case TypeCode.Single: sql_md = new SqlMetaData(name, SqlDbType.Real); break;
                case TypeCode.String: sql_md = new SqlMetaData(name, SqlDbType.NVarChar, column.MaxLength);
                    break;
                case TypeCode.UInt16: throw InvalidDataTypeCode(TypeCode.UInt16);
                case TypeCode.UInt32: throw InvalidDataTypeCode(TypeCode.UInt32);
                case TypeCode.UInt64: throw InvalidDataTypeCode(TypeCode.UInt64);
                case TypeCode.Object:
                    sql_md = SqlMetaDataFromObjectColumn(name, column, clrType);
                    if (sql_md == null)
                    {
                        // Unknown type, try to treat it as string;
                        sql_md = new SqlMetaData(name, SqlDbType.NVarChar, column.MaxLength);
                        coerceToString = true;
                    }
                    break;

                default: throw UnknownDataType(clrType);
            }

            return sql_md;
        }

        private static SqlMetaData SqlMetaDataFromObjectColumn(string name, DataColumn column, Type clrType)
        {
            SqlMetaData sql_md = null;
            if (clrType == typeof(System.Byte[]) || clrType == typeof(SqlBinary) || clrType == typeof(SqlBytes) ||
                clrType == typeof(System.Char[]) || clrType == typeof(SqlString) || clrType == typeof(SqlChars))
                sql_md = new SqlMetaData(name, SqlDbType.VarBinary, column.MaxLength);
            else if (clrType == typeof(System.Guid))
                sql_md = new SqlMetaData(name, SqlDbType.UniqueIdentifier);
            else if (clrType == typeof(System.Object))
                sql_md = new SqlMetaData(name, SqlDbType.Variant);
            else if (clrType == typeof(SqlBoolean))
                sql_md = new SqlMetaData(name, SqlDbType.Bit);
            else if (clrType == typeof(SqlByte))
                sql_md = new SqlMetaData(name, SqlDbType.TinyInt);
            else if (clrType == typeof(SqlDateTime))
                sql_md = new SqlMetaData(name, SqlDbType.DateTime);
            else if (clrType == typeof(SqlDouble))
                sql_md = new SqlMetaData(name, SqlDbType.Float);
            else if (clrType == typeof(SqlGuid))
                sql_md = new SqlMetaData(name, SqlDbType.UniqueIdentifier);
            else if (clrType == typeof(SqlInt16))
                sql_md = new SqlMetaData(name, SqlDbType.SmallInt);
            else if (clrType == typeof(SqlInt32))
                sql_md = new SqlMetaData(name, SqlDbType.Int);
            else if (clrType == typeof(SqlInt64))
                sql_md = new SqlMetaData(name, SqlDbType.BigInt);
            else if (clrType == typeof(SqlMoney))
                sql_md = new SqlMetaData(name, SqlDbType.Money);
            else if (clrType == typeof(SqlDecimal))
                sql_md = new SqlMetaData(name, SqlDbType.Decimal, SqlDecimal.MaxPrecision, 0);
            else if (clrType == typeof(SqlSingle))
                sql_md = new SqlMetaData(name, SqlDbType.Real);
            else if (clrType == typeof(SqlXml))
                sql_md = new SqlMetaData(name, SqlDbType.Xml);
            else
                sql_md = null;

            return sql_md;
        }
    }
}