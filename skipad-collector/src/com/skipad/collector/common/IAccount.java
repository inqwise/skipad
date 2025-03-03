package com.skipad.collector.common;

import java.util.Date;
import java.util.List;

public interface IAccount {
	long getId();
	String getName();
	String getExternalId();
	int getOwnerId();
	Date getCreateDate();
	List<IProperty> getProperties();
	
	public static class ColumnNames{
		public static final String AccountId = "AccountId";
		public static final String AccountName = "AccountName";
		public static final String AccountExternalId = "AccountExternalId";
		public static final String AccountOwnerId = "AccountOwnerId";
		public static final String AccountCreateDate = "CreateDate";
	}
}
