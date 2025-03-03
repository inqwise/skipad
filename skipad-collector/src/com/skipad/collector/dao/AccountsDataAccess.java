package com.skipad.collector.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;

import com.inqwise.infrastructure.dao.DAOException;
import com.inqwise.infrastructure.dao.DAOUtil;
import com.inqwise.infrastructure.dao.Database;
import com.inqwise.infrastructure.dao.IResultSetCallback;
import com.inqwise.infrastructure.dao.SqlParam;

public class AccountsDataAccess {

	private static final String ACCOUNT_EXTERNAL_ID_PARAM = "AccountExternalId";

	public static void getReader(String externalId,
			IResultSetCallback callback) throws DAOException {
		Connection connection = null;
        CallableStatement call = null;
        ResultSet resultSet = null;

        try{
            SqlParam[] params = {
                    new SqlParam(ACCOUNT_EXTERNAL_ID_PARAM, externalId),
            };

            Database factory = DAOFactory.getInstance(Databases.SkipadTag);
            call = factory.GetProcedureCall("Accounts_GetAccountDetails", params);
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
