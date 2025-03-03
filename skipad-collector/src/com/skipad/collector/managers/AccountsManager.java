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
import com.skipad.collector.common.IAccount;
import com.skipad.collector.common.IProperty;
import com.skipad.collector.dao.AccountsDataAccess;
import com.skipad.collector.entities.Account;
import com.skipad.collector.entities.Property;

public class AccountsManager {
static ApplicationLog logger = ApplicationLog.getLogger(AdsManager.class);
	
	private static LoadingCache<String, IAccount> accountsCache = CacheBuilder.newBuilder()
		    .maximumSize(10000)
		    .expireAfterWrite(10, TimeUnit.MINUTES)
		    .build(
		        new CacheLoader<String, IAccount>() {

					@Override
					public IAccount load(String key) throws Exception {
						return get(key);
					}
    });
	
	public static IAccount getFromCache(String externalId)
	{
		try {
			return accountsCache.get(externalId);
		} catch (InvalidCacheLoadException e) {
			logger.warn("getFromCache: account '%s' not found", externalId);
			return null;
		} catch (Exception e) {
			logger.error(e, "getFromCache: Unexpected error occurted. account '%s'", externalId);
			return null;
		}
	}
	
	public static IAccount get(String externalId)
    {
        final EntityBox<Account> accountBox = new EntityBox<>();
        IResultSetCallback callback = new IResultSetCallback() {
			
			@Override
			public void call(ResultSet reader, int generationId) throws Exception {
				
				while(reader.next()){
					switch(generationId){
	
					case 1: // Account
						accountBox.setValue(new Account(reader));
						break;
					
					case 2: // Properties
						IProperty property = new Property(reader);
						accountBox.getValue().addProperty(property);
					default:
						break;
					}
				}
			}
		};
		
        try {
        	AccountsDataAccess.getReader(externalId, callback);
		} catch (DAOException e) {
			throw new Error("get(externalId): unexpected error occured", e);
		}
        
        return accountBox.getValue();
    }

	public static void clearCache() {
		accountsCache.invalidateAll();
	}

	public static void removeFromCache(String id) {
		accountsCache.invalidate(id);
	}
}
