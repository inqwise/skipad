package com.skipad.collector.controller;

import static io.netty.handler.codec.http.HttpHeaders.Names.CACHE_CONTROL;
import static io.netty.handler.codec.http.HttpHeaders.Names.CONTENT_TYPE;

import java.io.IOException;
import java.io.StringWriter;

import org.restexpress.Request;
import org.restexpress.Response;

import com.skipad.collector.common.ExtendedQueryStringDecoder;

public class CrossDomainController extends Controller<String> {

	private String resultString = null;
	
	private static Controller<?> instance;
	public static Controller<?> getInstance() {
		if(null == instance){
			synchronized (CrossDomainController.class) {
				if(null == instance){
					instance = new CrossDomainController();
				}
			}
		}
		return instance;
	}
	
	private CrossDomainController() {
		StringWriter sw = new StringWriter();
		sw.write("<?xml version=\"1.0\" ?>");
		sw.write("<cross-domain-policy>");
		sw.write("<allow-access-from domain=\"*\" />");
		sw.write("<allow-http-request-headers-from domain=\"*\" headers=\"*\"/>");
		sw.write("</cross-domain-policy>");
		resultString = sw.toString();
	}
	
	@Override
	public String process(Request request, Response response,
			ExtendedQueryStringDecoder queryStringDecoder) throws IOException {
		
		response.addHeader(CONTENT_TYPE, "text/xml; charset=UTF-8");
		response.addHeader(CACHE_CONTROL, "max-age=3600");
		
		return resultString; 
	}

}
