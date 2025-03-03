package com.skipad.collector.managers;

import java.net.UnknownHostException;
import java.util.Date;

import org.json.JSONException;
import org.json.JSONObject;

import com.inqwise.infrastructure.systemFramework.ApplicationLog;
import com.skipad.collector.common.IRequestArgs;

public class RequestsManager {
	private static final String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss.S";
	static ApplicationLog logger = ApplicationLog.getLogger(RequestsManager.class);
	
	public static void insertRequest(IRequestArgs args){
    	try{
    		DataLogger.insert(generateRequestJson(args));
		} catch (Exception ex){
			logger.error(ex, "insertRequest: Unexpected error occured");
		}
    }
    
    private static String generateRequestJson(IRequestArgs args) throws JSONException, UnknownHostException{
		JSONObject jo = new JSONObject();
		jo.put("timestamp", org.apache.http.impl.cookie.DateUtils.formatDate(new Date(), DATE_FORMAT));
		jo.put("cId", args.getCid());
		jo.put("auId", args.getAuid());
		jo.put("hostName", java.net.InetAddress.getLocalHost().getHostName());
		jo.put("clientIp", args.getClientIp());
		jo.put("browserType", args.getBrowserType());
		jo.put("browserVersion", args.getBrowserVersion());
		jo.put("flashVersion", args.getFlashVersion());
		jo.put("clientLanguage", args.getLanguage());
		jo.put("operationSystem", args.getOperationSystem());
		jo.put("targetUrl", args.getTargetUrl());
		jo.put("timeZone", args.getTimeZone());
		jo.put("clientUid", args.getClientUid());
		jo.put("skipRollHeight", args.getSkipRollHeight());
		jo.put("skipRollWidth", args.getSkipRollWidth());
		
		jo.put("countrySymbol", args.getCountrySymbol()); // ISO2
		jo.put("postalCode", args.getPostalCode());
		jo.put("cityName", args.getCity());
		jo.put("targetDomain", args.getTargetDomain());
		
		/*
		 final String browserType = getFirstOrDefault("bt", params);
			final String browserVersion = getFirstOrDefault("bv", params);
			final String flashVersion = getFirstOrDefault("fv", params);
			final String language = getFirstOrDefault("lng", params);
			final String operationSystem = getFirstOrDefault("os", params);
			final String targetUrl = getFirstOrDefault("ru", params);
			final String timeZone = getFirstOrDefault("tz", params);
			final String clientUid = getFirstOrDefault("uu", params);
			final String skipRollHeight = getFirstOrDefault("srh", params);
			final String skipRollWidth = getFirstOrDefault("srw", params);
		 */
		
		return jo.toString();
	}
    
    private static class DataLogger{
    	private static final ApplicationLog logger = ApplicationLog.getLogger(DataLogger.class);
		public static void insert(String data){
			logger.info(data);
		}
	}
}
