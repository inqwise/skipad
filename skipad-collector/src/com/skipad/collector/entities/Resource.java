package com.skipad.collector.entities;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.skipad.collector.common.EventType;
import com.skipad.collector.common.IResource;
import com.skipad.collector.common.IResourceFile;
import com.skipad.collector.common.ResourceType;

public class Resource implements IResource {

	public Resource(ResultSet reader) throws SQLException {
		setId(reader.getLong(ColumnNames.ResourceId));
		setName(reader.getString(ColumnNames.Name));
		setResourceType(ResourceType.fromInt(reader.getInt(ColumnNames.ResourceTypeId)));
		if(null != reader.getObject(ColumnNames.ClickUrl)){
			setClickUrl(reader.getString(ColumnNames.ClickUrl));
		}
		setAdId(reader.getLong(ColumnNames.AdId));
		setDuration(reader.getString(ColumnNames.Duration));
	}
	
	private long id;
	private String name;
	private ResourceType resourceType;
	private String clickUrl;
	private List<IResourceFile> resourceFiles = new ArrayList<>();
	private long adId;
	private String duration;
	
	public void addResourceFile(ResourceFile resourceFile) {
		resourceFiles.add(resourceFile);
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public ResourceType getResourceType() {
		return resourceType;
	}

	public void setResourceType(ResourceType resourceType) {
		this.resourceType = resourceType;
	}

	public String getClickUrl() {
		return clickUrl;
	}

	public void setClickUrl(String clickUrl) {
		this.clickUrl = clickUrl;
	}

	public List<IResourceFile> getResourceFiles() {
		return resourceFiles;
	}

	public long getAdId() {
		return adId;
	}

	public void setAdId(long adId) {
		this.adId = adId;
	}

	public String getDuration() {
		return duration;
	}

	public void setDuration(String duration) {
		if(null != duration){
			this.duration = StringUtils.split(duration, '.')[0];
		}
	}
	
	@Override
	public EventType getClickEventType() {
		switch (getResourceType()) {
		case Image:
			return EventType.ImageClick;
		case Video:
			return EventType.VideoClick;
		default:
			throw new Error("Unimplemented resourceType: " + getResourceType());
		}
	}

	@Override
	public boolean isClickable() {
		return null != clickUrl;
	}
}
