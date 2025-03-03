package com.skipad.collector;

import com.inqwise.infrastructure.systemFramework.ApplicationLog;

public class HttpServer {
	static ApplicationLog logger = ApplicationLog.getLogger(HttpServer.class);

	private static HttpServer instance;

	public static HttpServer getInstance() {
		return instance;
	}

	public static void main(String[] args) throws Exception {
		start();
	}
	
	public static void start(){
		
		RestExpressService.start();
		logger.info("Add Shutdown Hook");
		Runtime.getRuntime().addShutdownHook(new Thread() {
		    public void run() { HttpServer.stop(); }
		});

		logger.info("Started");
	}
	
	public static void stop(){
		RestExpressService.stop();
	}
}
