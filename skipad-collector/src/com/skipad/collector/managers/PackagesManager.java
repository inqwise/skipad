package com.skipad.collector.managers;

import java.sql.ResultSet;
import java.util.concurrent.TimeUnit;

import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.CacheLoader.InvalidCacheLoadException;
import com.google.common.cache.LoadingCache;
import com.inqwise.infrastructure.dao.DAOException;
import com.inqwise.infrastructure.dao.IResultSetCallback;
import com.inqwise.infrastructure.systemFramework.ApplicationLog;
import com.skipad.collector.common.EntityBox;
import com.skipad.collector.common.IPackage;
import com.skipad.collector.common.IProperty;
import com.skipad.collector.dao.AdsDataAccess;
import com.skipad.collector.dao.PackagesDataAccess;
import com.skipad.collector.entities.PropertiesPackage;
import com.skipad.collector.entities.Property;

public class PackagesManager {
static ApplicationLog logger = ApplicationLog.getLogger(AdsManager.class);
	
	private static LoadingCache<String, IPackage> packagesCache = CacheBuilder.newBuilder()
		    .maximumSize(10000)
		    .expireAfterWrite(5, TimeUnit.MINUTES)
		    .build(
		        new CacheLoader<String, IPackage>() {

					@Override
					public IPackage load(String key) throws Exception {
						return get(key);
					}
    });
	
	public static IPackage getFromCache(String id)
	{
		try {
			return packagesCache.get(id);
		} catch (InvalidCacheLoadException e) {
			logger.warn("getFromCache: package '%s' not found", id);
			return null;
		} catch (Exception e) {
			logger.error(e, "getFromCache: Unexpected error occurted. package '%s'", id);
			return null;
		}
	}
	
    public static IPackage get(String packageExternalId)
    {
        final EntityBox<PropertiesPackage> packageBox = new EntityBox<>();
		IResultSetCallback callback = new IResultSetCallback() {
			
			@Override
			public void call(ResultSet reader, int generationId) throws Exception {
				
				while(reader.next()){
					switch(generationId){
	
					case 1: // Package
						packageBox.setValue(new PropertiesPackage(reader));
						break;
					
					case 2: // Properties
						IProperty property = new Property(reader);
						packageBox.getValue().addProperty(property);
						break;
					default:
						throw new UnsupportedOperationException("get: Received unsupported generationId: " + generationId);
					}
				}
			}
		};
		
        try {
        	PackagesDataAccess.getReader(packageExternalId, callback);
		} catch (DAOException e) {
			throw new Error("get(pid): unexpected error occured", e);
		}
        
        return packageBox.getValue();
    }

	public static void clearCache() {
		packagesCache.invalidateAll();
	}

	public static void removeFromCache(String pid) {
		packagesCache.invalidate(pid);
	}
}
