package com.skipad.collector.controller;

import static io.netty.handler.codec.http.HttpHeaders.Names.CONTENT_TYPE;
import io.netty.handler.codec.http.HttpHeaders.Names;
import io.netty.handler.codec.http.HttpHeaders.Values;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.math.NumberUtils;
import org.json.JSONObject;
import org.restexpress.Request;
import org.restexpress.Response;

import com.skipad.collector.common.ExtendedQueryStringDecoder;
import com.skipad.collector.managers.EventsManager;

public class ErrorsController extends Controller<Object> {
	
	private static Controller<?> instance;
	public static Controller<?> getInstance() {
		if(null == instance){
			synchronized (ErrorsController.class) {
				if(null == instance){
					instance = new ErrorsController();
				}
			}
		}
		return instance;
	}
		
	@Override
	public Object process(Request request, Response response,
			ExtendedQueryStringDecoder queryStringDecoder) throws IOException {
		
		response.addHeader(CONTENT_TYPE, "text/plain; charset=UTF-8");
		response.addHeader(Names.CACHE_CONTROL, Values.NO_CACHE);
		
		Map<String, List<String>> params = queryStringDecoder.parameters();
		String cid = null;
		String errorCode = null;
		String auid = null;
		Integer numerator = null;
		Integer msFromStart = null;
		Integer eventId = null;
		String sourceId = null;
		
		if(!params.isEmpty()){
			cid = getFirstOrDefault(CID_KEY, params);
			errorCode = getFirstOrDefault(ERROR_CODE_KEY, params);
			numerator = NumberUtils.createInteger(getFirstOrDefault(NUMERATOR_KEY, params));
	    	msFromStart = NumberUtils.createInteger(getFirstOrDefault(MS_FROM_START_KEY, params));
	    	sourceId = getFirstOrDefault(SOURCE_ID_KEY, params);
	    	if(null == sourceId){
	    		sourceId = "f";
	    	}
	    	auid = getFirstOrDefault(AU_ID_KEY, params);
	    	if(null == auid){
	    		auid = "";
	    	}
		}
		
		if(null != cid){
			switch(errorCode.toLowerCase()){
			case IMAGE_LOAD_ERROR_CODE:
				eventId = 91;
				break;
			case VIDEO_LOAD_ERROR_CODE:
				eventId = 92;
				break;
			default:
				// General Error
				eventId = 90;
				break;
			}
		}
		
		if(null != eventId){
        	// Save event
        	EventsManager.insertEvent(eventId, cid, auid, sourceId, RESOURCE_ID, numerator, msFromStart, null);
        } 
		
		if ((null == eventId || eventId == 90 /*GeneralError*/) && !params.isEmpty()) {
        	JSONObject jo = new JSONObject(params);
        	logger.error("ErrorsHandler: received error. Details: %s", jo);
        }
		
		return null;
	}
}
