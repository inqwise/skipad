package com.skipad.collector.managers;

import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.CacheLoader.InvalidCacheLoadException;
import com.google.common.cache.LoadingCache;
import com.inqwise.infrastructure.dao.DAOException;
import com.inqwise.infrastructure.dao.IResultSetCallback;
import com.inqwise.infrastructure.systemFramework.ApplicationLog;
import com.skipad.collector.common.EntityBox;
import com.skipad.collector.common.IAd;
import com.skipad.collector.common.IProperty;
import com.skipad.collector.dao.AdsDataAccess;
import com.skipad.collector.entities.Ad;
import com.skipad.collector.entities.Property;
import com.skipad.collector.entities.Resource;
import com.skipad.collector.entities.ResourceFile;

public class AdsManager {
	
	static ApplicationLog logger = ApplicationLog.getLogger(AdsManager.class);
	
	private static LoadingCache<String, IAd> adsCache = CacheBuilder.newBuilder()
		    .maximumSize(10000)
		    .expireAfterWrite(10, TimeUnit.MINUTES)
		    .build(
		        new CacheLoader<String, IAd>() {

					@Override
					public IAd load(String key) throws Exception {
						return get(key);
					}
    });
	
	public static IAd getFromCache(String id)
	{
		try {
			return adsCache.get(id);
		} catch (InvalidCacheLoadException e) {
			logger.warn("getFromCache: ad '%s' not found", id);
			return null;
		} catch (Exception e) {
			logger.error(e, "getFromCache: Unexpected error occurted. ad '%s'", id);
			return null;
		}
	}
	
	public static IAd get(long id)
    {
		final EntityBox<Ad> adBox = new EntityBox<>();
        final Map<Long, Resource> resourcesSet = new HashMap<>();
		IResultSetCallback callback = new IResultSetCallback() {
			
			@Override
			public void call(ResultSet reader, int generationId) throws Exception {
				
				while(reader.next()){
					switch(generationId){
	
					case 1: // Ad
						adBox.setValue(new Ad(reader));
						break;
					
					case 2: // Resources
						Resource resource = new Resource(reader);
						resourcesSet.put(resource.getId(), resource);
						adBox.getValue().addResource(resource);
						break;
						
					case 3: // ResourceFiles
						ResourceFile resourceFile = new ResourceFile(reader);
						if(!resourceFile.isThumbnail()){
							Resource actualResource = resourcesSet.get(resourceFile.getResourceId());
							actualResource.addResourceFile(resourceFile);
						}
						break;
						
					default:
						throw new UnsupportedOperationException("get: Received unsupported generationId: " + generationId);
					}
				}
			}
		};
		
        try {
			AdsDataAccess.getReader(id, null, callback);
		} catch (DAOException e) {
			throw new Error("get(id): unexpected error occured", e);
		}
        
        return adBox.getValue();
    }

    public static IAd get(String auid)
    {
        final EntityBox<Ad> adBox = new EntityBox<>();
        final Map<Long, Resource> resourcesSet = new HashMap<>();
		IResultSetCallback callback = new IResultSetCallback() {
			
			@Override
			public void call(ResultSet reader, int generationId) throws Exception {
				
				while(reader.next()){
					switch(generationId){
	
					case 1: // Ad
						adBox.setValue(new Ad(reader));
						break;
					
					case 2: // Resources
						Resource resource = new Resource(reader);
						resourcesSet.put(resource.getId(), resource);
						adBox.getValue().addResource(resource);
						break;
						
					case 3: // ResourceFiles
						ResourceFile resourceFile = new ResourceFile(reader);
						if(!resourceFile.isThumbnail()){
							Resource actualResource = resourcesSet.get(resourceFile.getResourceId());
							actualResource.addResourceFile(resourceFile);
						}
						break;
					case 4: // Properties
						IProperty property = new Property(reader);
						adBox.getValue().addProperty(property);
						break;
					case 5: // TargetEvents
						adBox.getValue().addTargetEvent(reader);;
					default:
						break;
					}
				}
			}
		};
		
        try {
        	AdsDataAccess.getReader(null, auid, callback);
		} catch (DAOException e) {
			throw new Error("get(auid): unexpected error occured", e);
		}
        
        return adBox.getValue();
    }

	public static void clearCache() {
		adsCache.invalidateAll();
	}

	public static void removeFromCache(String auid) {
		adsCache.invalidate(auid);
	}
}
