package com.skipad.collector.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;

import com.inqwise.infrastructure.dao.DAOException;
import com.inqwise.infrastructure.dao.DAOUtil;
import com.inqwise.infrastructure.dao.Database;
import com.inqwise.infrastructure.dao.SqlParam;

public class EventsDataAccess {
	private static final String EVENT_ID_PARAM = "p_EventId";
	private static final String CID_PARAM = "p_CId";
	private static final String AUID_PARAM = "p_AUId";
	private static final String SOURCE_ID_PARAM = "p_SourceId";
	private static final String RESOURCE_ID_PARAM = "p_ResourceId";

	public static void insertEvent(int eventId, String cId, String auId, String sourceId, int resourceId) throws DAOException{
		Connection connection = null;
        CallableStatement call = null;
        ResultSet resultSet = null;

        try{
            SqlParam[] params = {
                    new SqlParam(EVENT_ID_PARAM, eventId),
                    new SqlParam(CID_PARAM, cId),
                    new SqlParam(AUID_PARAM, auId),
                    new SqlParam(SOURCE_ID_PARAM, sourceId),
                    new SqlParam(RESOURCE_ID_PARAM, resourceId),
            };

            Database factory = DAOFactory.getInstance(Databases.Skipad);
            call = factory.GetProcedureCall("USP_AddNewEvent", params);
            connection = call.getConnection();
            call.execute();

        } catch (Exception e) {
            throw null == call ? new DAOException(e) : new DAOException(call, e);
        } finally {
            DAOUtil.close(resultSet);
            DAOUtil.close(call);
            DAOUtil.close(connection);
        } 
	}
}
