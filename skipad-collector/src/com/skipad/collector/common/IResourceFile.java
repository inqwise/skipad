package com.skipad.collector.common;

public interface IResourceFile {
	
	long getId();
    String getPath();
    String getContentType();
    Integer getWidth();
    Integer getHeight();
    Integer getBitrate();
    String getExtension();
    long getResourceId();
    ResourceFilePathType getPathType();
    boolean isThumbnail();
    
    public static class ColumnNames
    {
        public static final String ResourceFileId = "ResourceFileId";
        public static final String Path = "Path";
        public static final String ContentType = "ContentType";
        public static final String Width = "Width";
        public static final String Height = "Height";
        public static final String Bitrate = "Bitrate";
        public static final String Extension = "Extension";
        public static final String InsertDate = "InsertDate";
        public static final String ResourceId = "ResourceId";
		public static final String PathTypeId = "PathTypeId";
		public static final String IsThumbnail = "IsThumbnail";
    }
    
}
