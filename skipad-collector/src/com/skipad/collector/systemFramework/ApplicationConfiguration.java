package com.skipad.collector.systemFramework;

import org.restexpress.RestExpress;

import com.inqwise.infrastructure.systemFramework.BaseApplicationConfiguration;

public class ApplicationConfiguration extends BaseApplicationConfiguration {
	 
	public final static class Vpaid{
		private static final String JS_LINEAR_RENDERER_URL_KEY = "vpaid.js-linear-renderer-url";
		private static final String FLASH_LINEAR_RENDERER_URL_KEY = "vpaid.flash-linear-renderer-url";
		
		private static String jsLinearRendererUrl; 
		public static String getJsLinearRendererUrl() {
			if(null == jsLinearRendererUrl){
				jsLinearRendererUrl = getValue(JS_LINEAR_RENDERER_URL_KEY, true);
			}
			return jsLinearRendererUrl;
		}
		
		private static String flashLinearRendererUrl; 
		public static String getFlashLinearRendererUrl() {
			if(null == flashLinearRendererUrl){
				flashLinearRendererUrl = getValue(FLASH_LINEAR_RENDERER_URL_KEY, true);
			}
			return flashLinearRendererUrl;
		}	
	}
	
	private static final String BASE_URL_KEY = "base-url";
	private static String baseUrl;
	public static String getBaseUrl(){
		if(null == baseUrl){
			baseUrl = getValue(BASE_URL_KEY, true);
		}
		return baseUrl;
	}
	
	public final static class Service {

		private static final String BASE_URL_KEY = "service.baseUrl";
		public static String getBaseUrl() {
			return getValue(BASE_URL_KEY, "");
		}
		
		private static final String EXECUTOR_THREAD_POOL_SIZE_KEY = "service.thredPoolSize";
		public static int getExecutorThreadPoolSize() {
			return Integer.parseInt(getValue(EXECUTOR_THREAD_POOL_SIZE_KEY, "0"));
		}
		
		private static final String PORT_KEY = "service.port";
		public static int getPort() {
			return Integer.parseInt(getValue(PORT_KEY, String.valueOf(RestExpress.DEFAULT_PORT)));
		}
		
		private static final String NAME_KEY = "service.name";
		public static String getName() {
			return getValue(NAME_KEY, "inqwise-collector");
		}
	}
	
	public final static class Metrics {
		private static final String IS_ENABLED_KEY = "metrics.enabled";
		public static boolean isEnabled() {
			return getValue(IS_ENABLED_KEY, "false").equalsIgnoreCase("true");
		}
		
		private static final String IS_GRAPHITE_ENABLED_KEY = "metrics.graphite.enabled";
		public static boolean isGraphiteEnabled() {
			return getValue(IS_GRAPHITE_ENABLED_KEY, "false").equalsIgnoreCase("true");
		}
		
		private static final String GRAPHITE_HOST_KEY = "metrics.graphite.host";
		public static String getGraphiteHost() {
			return getValue(GRAPHITE_HOST_KEY, true);
		}
		
		private static final String PREFIX_KEY = "metrics.prefix";
		public static String getPrefix() {
			return getValue(PREFIX_KEY, true);
		}
		
		private static final String PUBLISH_IN_SECONDS_KEY = "metrics.publishInSeconds";
		public static long getPublishSeconds() {
			return Integer.parseInt(getValue(PUBLISH_IN_SECONDS_KEY, "5"));
		}
		
		private static final String GRAPHITE_PORT_KEY = "metrics.graphite.port";
		public static int getGraphitePort() {
			return Integer.parseInt(getValue(GRAPHITE_PORT_KEY, true));
		}
	}
}
