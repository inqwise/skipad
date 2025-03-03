package com.skipad.collector.controller;

import static io.netty.handler.codec.http.HttpHeaders.Names.CACHE_CONTROL;
import static io.netty.handler.codec.http.HttpHeaders.Names.CONTENT_TYPE;
import static io.netty.handler.codec.http.HttpResponseStatus.INTERNAL_SERVER_ERROR;
import static io.netty.handler.codec.http.HttpResponseStatus.NOT_FOUND;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.http.HttpHeaders.Values;
import io.netty.handler.codec.http.HttpRequest;
import io.netty.handler.codec.http.HttpHeaders.Names;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.transaction.TransactionRolledbackException;

import org.jboss.netty.handler.codec.http.HttpResponseStatus;
import org.restexpress.Request;
import org.restexpress.Response;

import com.inqwise.infrastructure.systemFramework.ApplicationLog;
import com.skipad.collector.common.ExtendedQueryStringDecoder;
import com.skipad.collector.systemFramework.NetworkHelper;

public abstract class Controller<TResult> {
	protected static final int RESOURCE_ID = 1;
	protected static final String VIDEO_LOAD_ERROR_CODE = "videoload";
	protected static final String IMAGE_LOAD_ERROR_CODE = "imageload";
	protected static final String AU_ID_KEY = "adid";
	protected static final String SOURCE_ID_KEY = "source";
	protected static final String MS_FROM_START_KEY = "time";
	protected static final String NUMERATOR_KEY = "cin";
	protected static final String ERROR_CODE_KEY = "error";
	protected static final String CID_KEY = "cid";
	protected static final String EVENT_ID_KEY = "ev";
	protected static final String RATE_INDEX_KEY = "rate";
	
	protected static ApplicationLog logger = ApplicationLog.getLogger(Controller.class);
	
	public TResult read(Request request, Response response){
		TResult result = null;
		try {
		ExtendedQueryStringDecoder qs = new ExtendedQueryStringDecoder(request.getUrl());
		
		String origin = request.getHeader(Names.ORIGIN);
		if(null == origin){
			origin = request.getHeader("origin");
		}
		
		if(null == origin){
			origin = "*";
		}
		
	    response.addHeader("srv", NetworkHelper.getLocalHostName());
	    
	    result = process(request, response, qs);
	    
	    response.addHeader(Names.ACCESS_CONTROL_ALLOW_CREDENTIALS, "true");
	    response.addHeader(Names.ACCESS_CONTROL_ALLOW_HEADERS, "content-type, depth, user-agent, x-file-size, x-requested-with, if-modified-since, x-file-name");
	    response.addHeader(Names.ACCESS_CONTROL_ALLOW_METHODS, "GET");
	    response.addHeader(Names.ACCESS_CONTROL_ALLOW_ORIGIN, origin);
	    response.addHeader("P3P", "CP=\"DSP COR NOI PSAo PSDo CUR ADMa DEVa OUR BUS UNI NAV INT COM STA PUR DEM PRE HEA FIN OTC POL\"");
	    
		} catch (Throwable e) {
			logger.error(e, "read: Unexpected error occured. Request Url: '%s'", request.getUrl());
			response.setResponseStatus(HttpResponseStatus.INTERNAL_SERVER_ERROR);
	    	response.addHeader(CONTENT_TYPE, "text/plain; charset=UTF-8");
		} 
		
	    return result;
	}
	
	public abstract TResult process(Request request, Response response, ExtendedQueryStringDecoder queryStringDecoder) throws IOException;
	
	protected static String getClientIp(Request request){
		return NetworkHelper.getClientIp(request);
	}
	
	protected static String getFirstOrDefault(String key, Map<String, List<String>> params, Integer maxLength){
    	String result = null;
    	List<String> list = params.get(key);
    	if(null != list){
    		result = list.get(0);
    	}
    	
    	if(null != maxLength && null != result && result.length() > maxLength){
    		result = result.substring(0, maxLength - 1);
    	}
    	
    	return result;
    }
	
	protected String getFirstOrDefault(String key, Map<String, List<String>> params){
		return getFirstOrDefault(key, params, null);
	}
	
}
