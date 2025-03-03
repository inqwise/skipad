package com.skipad.collector.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.restexpress.Request;
import org.restexpress.Response;

import com.inqwise.infrastructure.systemFramework.ApplicationLog;
import com.skipad.collector.common.ExtendedQueryStringDecoder;
import com.skipad.collector.managers.AccountsManager;
import com.skipad.collector.managers.AdsManager;
import com.skipad.collector.managers.PackagesManager;

public class InvalidateController extends Controller<String> {

static ApplicationLog logger = ApplicationLog.getLogger(InvalidateController.class);
	
	private static Controller<?> instance;
	public static Controller<?> getInstance() {
		if(null == instance){
			synchronized (InvalidateController.class) {
				if(null == instance){
					instance = new InvalidateController();
				}
			}
		}
		return instance;
	}
	
	enum CollectionName { ALL, TAGS, ACCOUNTS, PACKAGES }
	
	
	@Override
	public String process(Request request, Response response,
			ExtendedQueryStringDecoder queryStringDecoder) throws IOException {
		
		Map<String, List<String>> params = queryStringDecoder.parameters();
		
		logger.warn("Invalidate executed");
		CollectionName cName = null;
		String id;
		
		if (!params.isEmpty()) {
			String collectionName = getFirstOrDefault("cn", params);
			if(null != collectionName){
				cName = CollectionName.valueOf(collectionName.toUpperCase());
			}
			id = getFirstOrDefault("id", params);
			
			switch (cName) {
			case ACCOUNTS:
				if(null == id){
					AccountsManager.clearCache();
				} else {
					AccountsManager.removeFromCache(id);
				}
				break;
			case PACKAGES:
				if(null == id){
					PackagesManager.clearCache();
				} else {
					PackagesManager.removeFromCache(id);
				}
				break;
			case TAGS:
				if(null == id){
					AdsManager.clearCache();
				} else {
					AdsManager.removeFromCache(id);
				}
				break;
			case ALL:
				AccountsManager.clearCache();
				AdsManager.clearCache();
				break;
			default:
				break;
			}
		}
		return null;
	}

}
