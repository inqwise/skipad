package com.skipad.collector.vastElements;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Root;
import org.simpleframework.xml.Text;

import com.skipad.collector.common.ResourceType;

@Root
public class ClickElement {
	
	@Attribute(name="id")
	private String resourceTypeText; // = "video";
	
	public ClickElement setResource(ResourceType resourceType) {
		this.resourceTypeText = resourceType.toString().toLowerCase();
		return this;
	}

	public ClickElement setUrl(String url) {
		this.url = url;
		return this;
	}

	@Text()
	private String url; // = "http://";
}
