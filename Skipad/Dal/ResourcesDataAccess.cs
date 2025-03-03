using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics.Eventing.Reader;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using Inqwise.Skipad.Common;

namespace Inqwise.Skipad.Dal
{
    public class ResourcesDataAccess : DataAccess
    {
        private const string RESOURCE_FILE_NAME_PARAM_NAME = "@ResourceFileName";
        private const string IS_THUMBNAIL_PARAM_NAME = "@IsThumbnail";
        private const string DELETE_RESOURCE_FILES_SP_NAME = "[dbo].[ResourceFiles_DeleteResourceFile]";
        private const string RESOURCE_FILE_ID_PARAM_NAME = "@ResourceFileId";
        private const string BITRATE_PARAM_NAME = "@Bitrate";
        private const string HEIGHT_PARAM_NAME = "@Height";
        private const string WIDTH_PARAM_NAME = "@Width";
        private const string EXTENSION_PARAM_NAME = "@Extension";
        private const string CONTENT_TYPE_PARAM_NAME = "@ContentType";
        private const string PATH_PARAM = "@Path";
        private const string PATH_TYPE_ID_NAME = "@PathTypeId";
        private const string FOLDER_PATH_PARAM_NAME = "@PathFolder";
        private const string DURATION_PARAM_NAME = "@Duration";
        private const string RESOURCE_TYPE_ID_PARAM_NAME = "@ResourceTypeId";
        private const string RESOURCE_NAME_PARAM_NAME = "@ResourceName";
        private const string RESOURCE_DESC_PARAM_NAME = "@ResourceDesc";
        private const string RESOURCE_ID_PARAM_NAME = "@ResourceId";
        private const string RESOURCE_FILES_IDS_PARAM_NAME = "@ResourceFiles";
        private const string RESOURCE_ROLE_ID_PARAM_NAME = "@ResourceRoleId";

        private const string INSERT_RESOURCE_SP_NAME = "Resources_AddNewResource";
        private const string GET_RESOURCES_SP_NAME = "Resources_GetData";
        private const string GET_RESOURCE_SP_NAME = "Resources_GetData";
        private const string DELETE_RESOURCE_SP_NAME = "Resources_DeleteResource";
        private const string UPDATE_RESOURCE_SP_NAME = "Resources_UpdateResource";
        

        private const string INSERT_RESOURCE_FILE_SP_NAME = "ResourceFiles_AddNewResourceFile";

        private const string USERNAME_PARAM_NAME = "@Username";

        
        public static IDataReader GetMenyDataReader(string username, ResourceType? resourceType)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(GET_RESOURCES_SP_NAME))
            {
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                if (resourceType.HasValue)
                {
                    db.AddInParameter(command, RESOURCE_TYPE_ID_PARAM_NAME, DbType.Int32, (int)resourceType); 
                }
                return db.ExecuteReader(command);
            }
        }

        public static IDataReader GetDataReader(long id, string username)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(GET_RESOURCE_SP_NAME))
            {
                db.AddInParameter(command, RESOURCE_ID_PARAM_NAME, DbType.Int64, id);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);

                return db.ExecuteReader(command);
            }
        }

        public static long Insert(string name, string description, string username, ResourceType resourceType, TimeSpan? duration, string workFolder, ResourceRole role)
        {
            long id;

            var db = (SqlDatabase)Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(INSERT_RESOURCE_SP_NAME))
            {
                db.AddInParameter(command, RESOURCE_NAME_PARAM_NAME, DbType.String, name);
                db.AddInParameter(command, RESOURCE_DESC_PARAM_NAME, DbType.String, description);
                db.AddInParameter(command, RESOURCE_TYPE_ID_PARAM_NAME, DbType.Int32, (int)resourceType);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, DURATION_PARAM_NAME, SqlDbType.Time, duration); 
                db.AddInParameter(command, FOLDER_PATH_PARAM_NAME, DbType.String, workFolder);

                if (role != ResourceRole.Undefined)
                {
                    db.AddInParameter(command, RESOURCE_ROLE_ID_PARAM_NAME, DbType.Int32, (int)role); 
                }

                db.AddOutParameter(command, RESOURCE_ID_PARAM_NAME, DbType.Int64, sizeof(long));

                db.ExecuteNonQuery(command);

                id = (long)db.GetParameterValue(command, RESOURCE_ID_PARAM_NAME);
            }

            return id;
        }

        /*
        private static DataTable BuildResourceFilesDataTable(IEnumerable<ICreateResourceFileRequest> resurceFiles)
        {
            var table = new DataTable("FilesTable");
            var pathTypeIdColumn = table.Columns.Add("PathTypeId", typeof(int));
            var pathColumn = table.Columns.Add("Path", typeof (string));
            var contentTypeColumn = table.Columns.Add("ContentType", typeof(string));
            var extensionColumn = table.Columns.Add("Extension", typeof(string));
            var widthColumn = table.Columns.Add("Width", typeof(int));
            var heightColumn = table.Columns.Add("Height", typeof(int));
            var bitrateColumn = table.Columns.Add("Bitrate", typeof(int));

            foreach (var resourceFile in resurceFiles)
            {
                var row = table.NewRow();
                row[pathTypeIdColumn] = resourceFile.PathType;
                row[pathColumn] = resourceFile.Path as object ?? DBNull.Value;
                row[contentTypeColumn] = resourceFile.ContentType;
                row[extensionColumn] = resourceFile.Extension;
                row[widthColumn] = resourceFile.Width;
                row[heightColumn] = resourceFile.Height;
                row[bitrateColumn] = resourceFile.Bitrate as object ?? DBNull.Value;
                table.Rows.Add(row);
            }

            return table;
        }
        */

        public static void Delete(long id, string username)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(DELETE_RESOURCE_SP_NAME))
            {
                db.AddInParameter(command, RESOURCE_ID_PARAM_NAME, DbType.Int64, id);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.ExecuteNonQuery(command);
            }
        }

        public static void Update(long id, string name, string description, string username)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(UPDATE_RESOURCE_SP_NAME))
            {
                db.AddInParameter(command, RESOURCE_ID_PARAM_NAME, DbType.Int64, id);
                db.AddInParameter(command, RESOURCE_NAME_PARAM_NAME, DbType.String, name);
                db.AddInParameter(command, RESOURCE_DESC_PARAM_NAME, DbType.String, description);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);

                db.ExecuteNonQuery(command);
            }
        }

        public static long AddFile(ICreateResourceFileRequest request, long resourceId, string username)
        {
            long id;

            var db = (SqlDatabase)Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(INSERT_RESOURCE_FILE_SP_NAME))
            {
                db.AddInParameter(command, RESOURCE_ID_PARAM_NAME, DbType.Int64, resourceId);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                db.AddInParameter(command, PATH_TYPE_ID_NAME, DbType.Int32, (int)request.PathType);
                db.AddInParameter(command, PATH_PARAM, DbType.String, request.Path);
                db.AddInParameter(command, CONTENT_TYPE_PARAM_NAME, SqlDbType.NVarChar, request.ContentType);
                db.AddInParameter(command, EXTENSION_PARAM_NAME, DbType.String, request.Extension);
                
                db.AddInParameter(command, WIDTH_PARAM_NAME, DbType.Int32, request.Width);
                db.AddInParameter(command, HEIGHT_PARAM_NAME, DbType.Int32, request.Height);
                db.AddInParameter(command, BITRATE_PARAM_NAME, DbType.Double, request.Bitrate);
                db.AddInParameter(command, IS_THUMBNAIL_PARAM_NAME, DbType.Boolean, request.IsThumbnail);

                var resourceFileIdParam = new SqlParameter(RESOURCE_FILE_ID_PARAM_NAME, request.ResourceFileId)
                    {
                        Direction = ParameterDirection.InputOutput,
                        Size = sizeof (long),
                    };
                command.Parameters.Add(resourceFileIdParam);
                db.AddInParameter(command, RESOURCE_FILE_NAME_PARAM_NAME, DbType.String, request.Name);

                db.ExecuteNonQuery(command);

                id = Convert.ToInt64(db.GetParameterValue(command, RESOURCE_FILE_ID_PARAM_NAME));
            }

            return id;
        }

        public static IEnumerable<string> DeleteFiles(IEnumerable<long> ids, object username)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            List<string> result;
            using (var command = db.GetStoredProcCommand(DELETE_RESOURCE_FILES_SP_NAME))
            {
                db.AddInParameter(command, RESOURCE_FILES_IDS_PARAM_NAME, DbType.String, string.Join(",", ids));
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, username);
                using (var reader = db.ExecuteReader(command))
                {
                    result = new List<string>();
                    while (reader.Read())
                    {
                        var path = Convert.ToString(reader["Path"]);
                        result.Add(path);
                    }
                }
            }

            return result;
        }

        public static void AddFile(long resourceFileId, long resourceId, string username)
        {
            throw new NotImplementedException();
        }
    }
}