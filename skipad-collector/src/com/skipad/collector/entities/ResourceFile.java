package com.skipad.collector.entities;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.commons.lang3.StringUtils;

import com.skipad.collector.common.IResourceFile;
import com.skipad.collector.common.ResourceFilePathType;

public class ResourceFile implements IResourceFile {

	private long id;
	private String path;
	private ResourceFilePathType pathType;
	private String contentType;
	private Integer width;
	private Integer height;
	private Integer bitrate;
	private String extension;
	private long resourceId;
	private boolean thumbnail;
	
	public ResourceFile(ResultSet reader) throws SQLException {
		setId(reader.getLong(ColumnNames.ResourceFileId));
		setPath(reader.getString(ColumnNames.Path));
		setContentType(reader.getString(ColumnNames.ContentType));
		
		if(null != reader.getObject(ColumnNames.Width)){
			setWidth(reader.getInt(ColumnNames.Width));
		}
		
		if(null != reader.getObject(ColumnNames.Height)){
			setHeight(reader.getInt(ColumnNames.Height));
		}
		
		if(null != reader.getObject(ColumnNames.Bitrate)){
			setBitrate(reader.getInt(ColumnNames.Bitrate));
		}
		
		setExtension(reader.getString(ColumnNames.Extension));
		setResourceId(reader.getLong(ColumnNames.ResourceId));
		setPathType(ResourceFilePathType.fromInt(reader.getInt(ColumnNames.PathTypeId)));
		
		setThumbnail(reader.getBoolean(ColumnNames.IsThumbnail));
	}
	
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public Integer getWidth() {
		return width;
	}

	public void setWidth(Integer width) {
		this.width = width;
	}

	public Integer getHeight() {
		return height;
	}

	public void setHeight(Integer height) {
		this.height = height;
	}

	public Integer getBitrate() {
		return bitrate;
	}

	public void setBitrate(Integer bitrate) {
		this.bitrate = bitrate;
	}

	
	public String getExtension() {
		return extension;
	}

	public void setExtension(String extension) {
		this.extension = extension;
	}

	public long getResourceId() {
		return resourceId;
	}

	public void setResourceId(long resourceId) {
		this.resourceId = resourceId;
	}

	public ResourceFilePathType getPathType() {
		return pathType;
	}

	public void setPathType(ResourceFilePathType pathType) {
		this.pathType = pathType;
	}

	public boolean isThumbnail() {
		return thumbnail;
	}

	public void setThumbnail(boolean thumbnail) {
		this.thumbnail = thumbnail;
	}

}
