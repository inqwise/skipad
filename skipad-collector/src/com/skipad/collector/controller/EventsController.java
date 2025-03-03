package com.skipad.collector.controller;

import static io.netty.handler.codec.http.HttpHeaders.Names.CONTENT_TYPE;
import io.netty.handler.codec.http.HttpHeaders.Names;
import io.netty.handler.codec.http.HttpHeaders.Values;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.math.NumberUtils;
import org.restexpress.Request;
import org.restexpress.Response;

import com.skipad.collector.common.ExtendedQueryStringDecoder;
import com.skipad.collector.managers.EventsManager;

public class EventsController extends Controller<Object> {

	private static Controller<?> instance;
	public static Controller<?> getInstance() {
		if(null == instance){
			synchronized (EventsController.class) {
				if(null == instance){
					instance = new EventsController();
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
		
		String cid = null;
		String sourceId = null;
		Integer eventId = 0;
		String auid = null;
		Integer numerator = null;
		Integer msFromStart = null;
		Integer rateIndex = null;
		
		Map<String, List<String>> params = queryStringDecoder.parameters();
        
        if (!params.isEmpty()) {
        	cid = getFirstOrDefault(CID_KEY, params);
        	sourceId = getFirstOrDefault(SOURCE_ID_KEY, params);
        	if(null == sourceId){
	    		sourceId = "";
	    	}
        	eventId = NumberUtils.createInteger(getFirstOrDefault(EVENT_ID_KEY, params));
        	auid = getFirstOrDefault(AU_ID_KEY, params);
        	auid = getFirstOrDefault(AU_ID_KEY, params);
	    	if(null == auid){
	    		auid = "";
	    	}
        	numerator = NumberUtils.createInteger(getFirstOrDefault(NUMERATOR_KEY, params));
        	msFromStart = NumberUtils.createInteger(getFirstOrDefault(MS_FROM_START_KEY, params));
        	rateIndex = NumberUtils.createInteger(getFirstOrDefault(RATE_INDEX_KEY, params));
        }

        if(null != cid){
        	// Save event
        	EventsManager.insertEvent(eventId, cid, auid, sourceId, 1, numerator, msFromStart, rateIndex);
        }
		return null;
	}

}
