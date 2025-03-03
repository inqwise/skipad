package com.skipad.collector.controller;

import static io.netty.handler.codec.http.HttpHeaders.Names.CACHE_CONTROL;
import static io.netty.handler.codec.http.HttpHeaders.Names.CONTENT_TYPE;

import java.io.IOException;
import java.io.StringWriter;

import org.restexpress.Request;
import org.restexpress.Response;

import com.skipad.collector.common.ExtendedQueryStringDecoder;

public class ClientAccessPolicyController extends Controller<String> {

	private String resultString = null;
	
	private static Controller<?> instance;
	public static Controller<?> getInstance() {
		if(null == instance){
			synchronized (ClientAccessPolicyController.class) {
				if(null == instance){
					instance = new ClientAccessPolicyController();
				}
			}
		}
		return instance;
	}
	
	private ClientAccessPolicyController() {
		StringWriter sw = new StringWriter();
		sw.write("<?xml version=\"1.0\" ?>");
		sw.write("<access-policy>");
		sw.write("<cross-domain-access>");
		sw.write("<policy>");
		sw.write("<allow-from http-request-headers=\"*\">");
		sw.write("<domain uri=\"http://*\" />");
		sw.write("</allow-from>");
		sw.write("<grant-to>");
		sw.write("<resource path=\"/\" include-subpaths=\"true\" />");
		sw.write("</grant-to>");
		sw.write("</policy>");
		sw.write("</cross-domain-access>");
		sw.write("</access-policy>");
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
