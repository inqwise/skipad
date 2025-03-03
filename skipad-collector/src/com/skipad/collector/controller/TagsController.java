package com.skipad.collector.controller;

import static io.netty.handler.codec.http.HttpHeaders.Names.CACHE_CONTROL;
import static io.netty.handler.codec.http.HttpHeaders.Names.CONTENT_TYPE;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.handler.codec.http.HttpHeaders;
import io.netty.handler.codec.http.HttpHeaders.Names;
import io.netty.handler.codec.http.HttpHeaders.Values;
import io.netty.util.CharsetUtil;

import java.io.IOException;
import java.io.StringWriter;
import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.sound.sampled.TargetDataLine;

import org.apache.commons.lang3.StringUtils;
import org.jboss.netty.handler.codec.http.HttpResponseStatus;
import org.json.JSONException;
import org.json.JSONObject;
import org.restexpress.Request;
import org.restexpress.Response;
import org.simpleframework.xml.Serializer;
import org.simpleframework.xml.convert.AnnotationStrategy;
import org.simpleframework.xml.core.Persister;
import org.simpleframework.xml.stream.Format;

import com.maxmind.geoip.Location;
import com.inqwise.infrastructure.systemFramework.ApplicationLog;
import com.skipad.collector.common.ExtendedQueryStringDecoder;
import com.skipad.collector.common.IAd;
import com.skipad.collector.common.IPackage;
import com.skipad.collector.common.IRequestArgs;
import com.skipad.collector.common.OutputType;
import com.skipad.collector.managers.AdsManager;
import com.skipad.collector.managers.PackagesManager;
import com.skipad.collector.managers.RequestsManager;
import com.skipad.collector.systemFramework.ApplicationConfiguration;
import com.skipad.collector.systemFramework.GeoIpManager;

public class TagsController extends Controller<String> {

	private static final String TAG_URL_FORMAT = "%s/tag?auid=%s&otp=%s";
	static ApplicationLog logger = ApplicationLog.getLogger(TagsController.class);
	
	private static Controller<?> instance;
	public static Controller<?> getInstance() {
		if(null == instance){
			synchronized (TagsController.class) {
				if(null == instance){
					instance = new TagsController();
				}
			}
		}
		return instance;
	}
	
	@Override
	public String process(Request request, Response response,
			ExtendedQueryStringDecoder queryStringDecoder) throws IOException {
		String result = null;
		final String clientIp = getClientIp(request);
		response.addHeader(Names.CACHE_CONTROL, Values.NO_CACHE);
		
		Map<String, List<String>> params = queryStringDecoder.parameters();
		
		if (!params.isEmpty()) {
			String auid = request.getHeader("auid");
			if(null == auid){
				auid = getFirstOrDefault("auid", params);
			}
			final String browserType = getFirstOrDefault("bt", params);
			final String browserVersion = getFirstOrDefault("bv", params);
			final String flashVersion = getFirstOrDefault("fv", params);
			final String language = getFirstOrDefault("lng", params);
			final String operationSystem = getFirstOrDefault("os", params);
			String targetUrl = getFirstOrDefault("ru", params);
			final String timeZone = getFirstOrDefault("tz", params);
			final String clientUid = getFirstOrDefault("uu", params);
			final String skipRollHeight = getFirstOrDefault("srh", params, 10);
			final String skipRollWidth = getFirstOrDefault("srw", params, 10);
			String strOutputTypeId = request.getHeader("otp");
			if(null == strOutputTypeId){
				strOutputTypeId = getFirstOrDefault("otp", params);
			}
			final String noCacheStr = getFirstOrDefault("nocache", params);
			
			Location location = GeoIpManager.getInstance().getLocation(clientIp);
			final String countrySymbol = (null == location ? null : location.countryCode);
			final String city = (null == location ? null : location.city);
			final String postalCode = (null == location ? null : location.postalCode);
			final OutputType outputType = OutputType.fromString(strOutputTypeId);
			final boolean noCache = Boolean.parseBoolean(noCacheStr);
			//final String externalAccountId = getFirstOrDefault("pid", params);
			final String externalPackageId = getFirstOrDefault("tid", params);
			final String version = getFirstOrDefault("ver", params);
			final String cid = StringUtils.remove(UUID.randomUUID().toString().toLowerCase(),'-');
			String targetDomain = null;
			if(null == targetUrl){
				targetUrl = request.getHeader(HttpHeaders.Names.REFERER);
			}
			
			if(null != targetUrl){
				try{
					String[] arr = StringUtils.splitByWholeSeparator(targetUrl, "://");
					if(null != arr && arr.length > 1) {
						targetDomain = arr[1];
					}
					
					arr = StringUtils.split(targetDomain, "/?#");
					if(null != arr && arr.length > 0) {
						targetDomain = arr[0];
					}
					
					logger.debug("process: found targetDomain: " + targetDomain);
					
					//
					//URI targetUri = new URI(targetUrl.replace(" ","%20").replace("^","%5E").replace("|","%7C"));
					//targetDomain = targetUri.getHost();
				} catch(Exception ex){
					logger.error(ex, "Failed to parse targetUrl: '%s'", targetUrl);
				}
			}
			
			logger.debug(targetUrl);
			
			IPackage propertiesPackage = null;
			if(null != externalPackageId){
				propertiesPackage = (noCache ? PackagesManager.get(externalPackageId) : PackagesManager.getFromCache(externalPackageId));
			}
			
			if(null != auid){
				IAd ad = (noCache ? AdsManager.get(auid) : AdsManager.getFromCache(auid));
				
				// insert Request
				if(null != ad){
					insertRequest(clientIp, auid, browserType, browserVersion,
							flashVersion, language, operationSystem, targetUrl,
							timeZone, clientUid, skipRollHeight, skipRollWidth,
							countrySymbol, city, postalCode, cid, targetDomain);
				}
				
				// build VAST XML/mrade and return
				if(null != ad){
					
					try {
						StringWriter sw;
						Serializer serializer;
						switch (outputType) {
						case Mraid:
							String callback = getFirstOrDefault("callback", params);
							
							JSONObject jo = ad.getMraid(cid, propertiesPackage, null);
							result = jo.toString();
							if(null != callback){
								result = StringUtils.join(callback, "(", result, ")");
							}
							
							response.addHeader(CONTENT_TYPE, "application/json; charset=UTF-8");
							break;
						case VpaidHtml5:
							sw = new StringWriter();
							serializer = new Persister(new AnnotationStrategy(), new Format("<?xml version=\"1.0\" encoding= \"UTF-8\" ?>"));
							serializer.write(ad.getVpaid(cid, propertiesPackage, version), sw);
							response.addHeader(CONTENT_TYPE, "text/xml; charset=utf-8");
							result = sw.toString();
							
							break;
						case VpaidFlash:
							sw = new StringWriter();
							serializer = new Persister(new AnnotationStrategy(), new Format("<?xml version=\"1.0\" encoding= \"UTF-8\" ?>"));
							serializer.write(ad.getVpaidFlash(cid, propertiesPackage, generateVpaidFlashParams(auid, queryStringDecoder, "0000-0000"), version), sw);
							response.addHeader(CONTENT_TYPE, "text/xml; charset=utf-8");
							result = sw.toString();
							
							break;
						case Vast:
						default:
							sw = new StringWriter();
							serializer = new Persister(new Format("<?xml version=\"1.0\" encoding= \"UTF-8\" ?>"));
							serializer.write(ad.getVast(cid, propertiesPackage, version), sw);
							response.addHeader(CONTENT_TYPE, "text/xml; charset=utf-8");
							result = sw.toString();
							
							break;
						}
						
					} catch (Exception e) {
						logger.error(e, "process: unexpected error occured");
					}
				} else {
					response.setResponseStatus(HttpResponseStatus.NOT_FOUND);
				}
			}
		}
		return result;
	}

	private void insertRequest(final String clientIp, final String auid,
			final String browserType, final String browserVersion,
			final String flashVersion, final String language,
			final String operationSystem, final String targetUrl,
			final String timeZone, final String clientUid,
			final String skipRollHeight, final String skipRollWidth,
			final String countrySymbol, final String city,
			final String postalCode, final String cid, final String targetDomain) {
		RequestsManager.insertRequest(new IRequestArgs() {
			
			@Override
			public String getClientIp() {
				return clientIp;
			}
			
			@Override
			public String getCid() {
				return cid;
			}
			
			@Override
			public String getAuid() {
				return auid;
			}

			@Override
			public String getBrowserType() {
				return browserType;
			}

			@Override
			public String getBrowserVersion() {
				return browserVersion;
			}

			@Override
			public String getFlashVersion() {
				return flashVersion;
			}

			@Override
			public String getLanguage() {
				return language;
			}

			@Override
			public String getOperationSystem() {
				return operationSystem;
			}

			@Override
			public String getTargetUrl() {
				return targetUrl;
			}

			@Override
			public String getTimeZone() {
				return timeZone;
			}

			@Override
			public String getClientUid() {
				return clientUid;
			}

			@Override
			public String getSkipRollHeight() {
				return skipRollHeight;
			}

			@Override
			public String getSkipRollWidth() {
				return skipRollWidth;
			}

			@Override
			public String getCountrySymbol() {
				return countrySymbol;
			}

			@Override
			public String getPostalCode() {
				return postalCode;
			}

			@Override
			public String getCity() {
				return city;
			}

			@Override
			public String getTargetDomain() {
				return targetDomain;
			}
		});
	}
	
	private String generateVpaidFlashParams(String auid,
			ExtendedQueryStringDecoder queryStringDecoder, String adPid) throws JSONException {
		
		JSONObject jo = new JSONObject();
		jo.put("tag", getTagUrl(auid, OutputType.Vast));
		jo.put("skin", getFirstOrDefault("skin", queryStringDecoder.parameters()));
		String pid = getFirstOrDefault("pid", queryStringDecoder.parameters());
		jo.put("pid", (null == pid ? adPid : pid));
		return jo.toString();
	}
	
	private String getTagUrl(String auid, OutputType type) {
		return String.format(TAG_URL_FORMAT, ApplicationConfiguration.getBaseUrl(), auid, type.toString());
	}
}
