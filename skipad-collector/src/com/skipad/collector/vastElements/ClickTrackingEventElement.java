package com.skipad.collector.vastElements;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Root;
import org.simpleframework.xml.Text;

import com.skipad.collector.common.ResourceType;

@Root
public class ClickTrackingEventElement {
	@Attribute(name="id")
	private String resourceTypeText;
	
	@Text()
	private String url;
	
	public ClickTrackingEventElement setResourceType(ResourceType resourceType){
		this.resourceTypeText = resourceType.toString().toLowerCase();
		return this;
	}
	
	public ClickTrackingEventElement setUrl(String url) {
		this.url = url;
		return this;
	}
}
