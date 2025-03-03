package com.skipad.collector.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;

import com.inqwise.infrastructure.dao.DAOException;
import com.inqwise.infrastructure.dao.DAOUtil;
import com.inqwise.infrastructure.dao.Database;
import com.inqwise.infrastructure.dao.IResultSetCallback;
import com.inqwise.infrastructure.dao.SqlParam;

public class PackagesDataAccess {

	private static final String PACKAGE_EXTERNAL_ID_PARAM = "PackageExternalId";

	public static void getReader(String externalId,
			IResultSetCallback callback) throws DAOException {
		Connection connection = null;
        CallableStatement call = null;
        ResultSet resultSet = null;

        try{
            SqlParam[] params = {
                    new SqlParam(PACKAGE_EXTERNAL_ID_PARAM, externalId),
                    new SqlParam("UserName", null),
                    new SqlParam("AccountPropertyPackageId", null),
            };

            Database factory = DAOFactory.getInstance(Databases.SkipadTag);
            call = factory.GetProcedureCall("AccountPropertyPackages_GetPackageData", params);
            connection = call.getConnection();
            call.execute();
            
            int count = 1;
            do{
            	resultSet = call.getResultSet();
            	if(null != resultSet){
            		callback.call(resultSet, count++);
            	}
            }while(call.getMoreResults());

        } catch (Exception e) {
            throw null == call ? new DAOException(e) : new DAOException(call, e);
        } finally {
            DAOUtil.close(resultSet);
            DAOUtil.close(call);
            DAOUtil.close(connection);
        }
		
	}

}
