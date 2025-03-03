package com.skipad.collector.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;

import com.inqwise.infrastructure.dao.DAOException;
import com.inqwise.infrastructure.dao.DAOUtil;
import com.inqwise.infrastructure.dao.Database;
import com.inqwise.infrastructure.dao.IResultSetCallback;
import com.inqwise.infrastructure.dao.SqlParam;

public class AdsDataAccess {
	private static final String AD_ID_PARAM = "Ads_Id";
	private static final String AUID_PARAM = "AUID";

	public static void getReader(Long id, String auid, IResultSetCallback callback) throws DAOException{
		Connection connection = null;
        CallableStatement call = null;
        ResultSet resultSet = null;

        try{
            SqlParam[] params = {
                    new SqlParam(AD_ID_PARAM, id),
                    new SqlParam(AUID_PARAM, auid),
                    new SqlParam("Username", null),
            };

            Database factory = DAOFactory.getInstance(Databases.SkipadTag);
            call = factory.GetProcedureCall("Ads_GetAd", params);
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
