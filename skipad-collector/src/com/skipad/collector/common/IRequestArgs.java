package com.skipad.collector.common;


public interface IRequestArgs {

	String getCid();
	String getAuid();
	String getClientIp();
	String getBrowserType();
	String getBrowserVersion();
	String getFlashVersion();
	String getLanguage();
	String getOperationSystem();
	String getTargetUrl();
	String getTimeZone();
	String getClientUid();
	String getSkipRollHeight();
	String getSkipRollWidth();
	String getCountrySymbol();
	String getPostalCode();
	String getCity();
	String getTargetDomain();
}
