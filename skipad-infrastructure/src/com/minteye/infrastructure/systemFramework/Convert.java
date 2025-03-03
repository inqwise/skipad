package com.inqwise.infrastructure.systemFramework;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class Convert {
	public static Date toDate(Timestamp timestamp){
		if(null == timestamp){
			return null;
		} else {
			long milliseconds = timestamp.getTime() + (timestamp.getNanos() / 1000000);
		    return new Date(milliseconds);
		}
	}
	
	public static java.util.Date toDate(java.sql.Date date) {
		if(null == date){
			return null;
		} else{
			return new java.util.Date(date.getTime());
		}
	}

	public static Map<String, List<String>> fromQueryString(String query) 
	        throws UnsupportedEncodingException { 
	    Map<String, List<String>> params = new HashMap<String, List<String>>(); 
	     
	    if (null != query) { 
	        for (String param : query.split("&")) { 
	            String pair[] = param.split("="); 
	            String key = URLDecoder.decode(pair[0], "UTF-8"); 
	            String value = ""; 
	            if (pair.length > 1) { 
	                value = URLDecoder.decode(pair[1], "UTF-8"); 
	            } 
	            List<String> values = params.get(key); 
	            if (values == null) { 
	                values = new ArrayList<String>(); 
	                params.put(key, values); 
	            } 
	            values.add(value); 
	        } 
	    } 
	    return params; 
	}
}
