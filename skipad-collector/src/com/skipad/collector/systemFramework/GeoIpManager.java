package com.skipad.collector.systemFramework;

import java.io.IOException;

import javax.xml.crypto.dsig.spec.C14NMethodParameterSpec;

import com.maxmind.geoip.Country;
import com.maxmind.geoip.Location;
import com.maxmind.geoip.LookupService;
import com.inqwise.infrastructure.systemFramework.ApplicationLog;
import com.inqwise.infrastructure.systemFramework.BaseApplicationConfiguration;
import com.inqwise.infrastructure.systemFramework.BaseApplicationConfiguration.GeoIp;

public class GeoIpManager {
	
	public static final String UNDEFINED_COUNTY_CODE = "--";
	static final ApplicationLog logger = ApplicationLog.getLogger(GeoIpManager.class);
	private static GeoIpManager instance = null;
	private boolean done = false;
	LookupService cl;
	
	public static GeoIpManager getInstance() throws IOException {
		if(instance == null) {
			instance = new GeoIpManager();
		} else if(instance.done){
        	try {
				instance.finalize();
			} catch (Throwable t) {
				logger.error(t, "getInstance() : finilize failed.");
			}
        	instance = new GeoIpManager();
		}
		return instance;
	}
	
	private GeoIpManager() throws IOException{
		 cl = new LookupService(BaseApplicationConfiguration.GeoIp.getGeoIpPath(),
				LookupService.GEOIP_MEMORY_CACHE );
	}
	
	protected void finalize() throws Throwable
	{
		finish();
		super.finalize();
	}
	
	public void finish(){
		if(!done){
			done = true;
			cl.close();
		}
	}
	
	public String getCountryName(String ipAddress){
		return cl.getCountry(ipAddress).getName();
	}

	public String getCountryCode(String ipAddress) {
		Country country = cl.getCountry(ipAddress);
		
		if(country.getCode().equalsIgnoreCase("--")){
			return null;
		}
		
		return country.getCode();
	}
	
	public String getCity(String ipAddress){
		return cl.getLocation(ipAddress).city;
	}
	
	public String getPostalCode(String ipAddress){
		return cl.getLocation(ipAddress).postalCode;
	}
	
	public Location getLocation(String ipAddress){
		Location location = cl.getLocation(ipAddress);
		
		return location;
	}
}
