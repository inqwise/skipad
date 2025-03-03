package com.skipad.collector.managers;

import java.net.UnknownHostException;
import java.util.Date;

import org.json.JSONException;
import org.json.JSONObject;

import com.inqwise.infrastructure.systemFramework.ApplicationLog;
import com.skipad.collector.common.EventType;

public class EventsManager {
	private static final String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss.S";
	static ApplicationLog logger = ApplicationLog.getLogger(EventsManager.class);
	public static void insertEvent(int eventId, String cId, String auId, String sourceId, Integer resourceId, Integer numerator, Integer msFromStart, Integer rateIndex){
		try{
			if(eventId == EventType.Rate.getValue()){
				if(null == rateIndex){
					throw new Exception(String.format("Received event 'rate' #30 without rateIndex. auid: '%s', sourceId: '%s'", auId, sourceId));
				}
				
				if(rateIndex < 1 || rateIndex > 9){
					throw new Exception(String.format("Received event 'rate' #30 with rateIndex out of range [1-9]. auid: '%s', sourceId: '%s', rateIndex: '%s'", auId, sourceId, rateIndex));
				}
				
				eventId = eventId + rateIndex;
				
			}
			
			DataLogger.insert(generateEventJson(eventId, cId, auId, sourceId, resourceId, numerator, msFromStart));
			
			//EventsDataAccess.insertEvent(eventId, cId, auId, sourceId, resourceId);
		} catch (Exception ex){
			logger.error(ex, "insertEvent: Unexpected error occured");
		}
	}
	
	private static String generateEventJson(Integer eventId, String cId, String auId, String sourceId, Integer resourceId, Integer numerator, Integer msFromStart) throws JSONException, UnknownHostException{
		JSONObject jo = new JSONObject();
		jo.put("timestamp", org.apache.http.impl.cookie.DateUtils.formatDate(new Date(), DATE_FORMAT));
		jo.put("eventId", eventId);
		jo.put("cId", cId);
		jo.put("auId", auId);
		jo.put("sourceId", sourceId);
		jo.put("resourceId", resourceId);
		jo.put("hostName", java.net.InetAddress.getLocalHost().getHostName());
		jo.put("cidNumerator", numerator);
		jo.put("msFromStart", msFromStart);
		
		return jo.toString();
	}
	
	private static class DataLogger{
		private static final ApplicationLog logger = ApplicationLog.getLogger(DataLogger.class);
		public static void insert(String data){
			logger.info(data);
		}
	}
}
