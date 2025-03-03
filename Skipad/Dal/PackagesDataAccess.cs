using System;
using System.Data;
using Inqwise.Skipad.Common;

namespace Inqwise.Skipad.Dal
{
    public class PackagesDataAccess : DataAccess
    {
        
        // PARAMS
        private const string ACCOUNT_ID_PARAM_NAME = "@AccountId";
        private const string USERNAME_PARAM_NAME = "@UserName";
        private const string PACKAGE_ID_PARAM_NAME = "@AccountPropertyPackageId";
        private const string PACKAGE_EXTERNAL_ID_PREFIX_PARAM_NAME = "@ExternalIdPrefix";
        private const string PACKAGE_NAME_PARAM_NAME = "@PackageName";
        private const string ENTITY_ID_PARAM_NAME = "@EntityId";
        private const string PACKAGE_LEVEL_ID_PARAM_NAME = "@PackageLevelId";
        private const string PACKAGE_EXTERNAL_ID_PARAM_NAME = "@PackageExternalId";
        private const string TO_ASSIGN_FLAG_PARAM_NAME = "@ToAssignFlag";

        // PROCS
        private const string GET_PACKAGES_SP_NAME = "AccountPropertyPackages_GetList";
        private const string INSERT_PACKAGE_SP_NAME = "AccountPropertyPackages_InsertNewPackage";
        private const string DELETE_PACKAGE_SP_NAME = "AccountPropertyPackages_DeletePackage";
        private const string GET_PACKAGE_SP_NAME = "AccountPropertyPackages_GetPackageData";
        private const string ASSIGN_PACKAGE_SP_NAME = "AccountPropertyPackages_AssignEntity";
        private const string UPDATE_PACKAGE_SP_NAME = "AccountPropertyPackages_UpdatePackage";
        
        public static IDataReader GetMenyDataReader(int accountId, string userName)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(GET_PACKAGES_SP_NAME))
            {
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, userName);
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                return db.ExecuteReader(command);
            }
        }

        public static int Insert(int accountId, string externalIdPrefix, string packageName, PackageLevel packageLevel)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(INSERT_PACKAGE_SP_NAME))
            {
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                db.AddInParameter(command, PACKAGE_EXTERNAL_ID_PREFIX_PARAM_NAME, DbType.String, externalIdPrefix);
                db.AddInParameter(command, PACKAGE_NAME_PARAM_NAME, DbType.String, packageName);
                db.AddInParameter(command, PACKAGE_LEVEL_ID_PARAM_NAME, DbType.Int32, (int) packageLevel);
                
                return Convert.ToInt32(db.ExecuteScalar(command));
            }
        }

        public static void Delete(int packageId, int accountId, string userName)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(DELETE_PACKAGE_SP_NAME))
            {
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, userName);
                db.AddInParameter(command, PACKAGE_ID_PARAM_NAME, DbType.Int32, packageId);
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                db.ExecuteNonQuery(command);
            }
        }

        public static void Update(int packageId, string packageName, string userName)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(UPDATE_PACKAGE_SP_NAME))
            {
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, userName);
                db.AddInParameter(command, PACKAGE_ID_PARAM_NAME, DbType.Int32, packageId);
                db.AddInParameter(command, PACKAGE_NAME_PARAM_NAME, DbType.String, packageName);
                db.ExecuteNonQuery(command);
            }
        }

        public static void Assign(int? packageId, int accountId, string userName, int? entityId, int? levelId)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(ASSIGN_PACKAGE_SP_NAME))
            {
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, userName);
                db.AddInParameter(command, PACKAGE_ID_PARAM_NAME, DbType.Int32, packageId);
                db.AddInParameter(command, ACCOUNT_ID_PARAM_NAME, DbType.Int32, accountId);
                db.AddInParameter(command, TO_ASSIGN_FLAG_PARAM_NAME, DbType.Boolean, null != packageId);
                db.AddInParameter(command, ENTITY_ID_PARAM_NAME, DbType.Int32, entityId);
                db.AddInParameter(command, PACKAGE_LEVEL_ID_PARAM_NAME, DbType.Int32, levelId);
                
                db.ExecuteNonQuery(command);
            }
        }

        internal static IDataReader GetDataReader(int? packageId, string userName, string packageExternalId)
        {
            var db = Factory.Create(SKIPAD_DB_NAME);
            using (var command = db.GetStoredProcCommand(GET_PACKAGE_SP_NAME))
            {
                db.AddInParameter(command, PACKAGE_ID_PARAM_NAME, DbType.Int32, packageId);
                db.AddInParameter(command, USERNAME_PARAM_NAME, DbType.String, userName);
                db.AddInParameter(command, PACKAGE_EXTERNAL_ID_PARAM_NAME, DbType.String, packageExternalId);
                return db.ExecuteReader(command);
            }
        }
    }
}