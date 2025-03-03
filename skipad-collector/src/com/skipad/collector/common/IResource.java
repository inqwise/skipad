package com.skipad.collector.common;

import java.util.List;

public interface IResource {
	long getId();
    String getName();
    ResourceType getResourceType();
    String getClickUrl();
    List<IResourceFile> getResourceFiles();
    long getAdId();
    EventType getClickEventType();
    String getDuration();
    
    public static class ColumnNames
    {
        public static final String AdId = "Ads_Id";
        public static final String ResourceId = "ResourceId";
        public static final String ResourceTypeId = "ResourceTypeId";
        public static final String InsertDate = "InsertDate";
        public static final String ClickUrl = "ClickUrl";
        public static final String Name = "ResourceName";
        public static final String Description = "ResourceDesc";
        public static final String Duration = "Duration";
		public static final String ResourceRoleId = "ResourceRoleId";
    }

	boolean isClickable();
}
