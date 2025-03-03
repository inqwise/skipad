package com.skipad.collector.vastElements;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Path;
import org.simpleframework.xml.Root;
import org.simpleframework.xml.Text;

import com.skipad.collector.common.ResourceType;

@Root
public class MediaFileV1Element {
	
	@Attribute(name="id")
	private String resourceTypeText; // = "video";
	
	public MediaFileV1Element setResourceType(ResourceType resourceType) {
		this.resourceTypeText = resourceType.toString().toLowerCase();
		return this;
	}

	public MediaFileV1Element setDelivery(String delivery) {
		this.delivery = delivery;
		return this;
	}

	public MediaFileV1Element setContentType(String contentType) {
		this.contentType = contentType;
		return this;
	}

	public MediaFileV1Element setBitrate(Integer bitrate) {
		if(null == bitrate){
			this.bitrate = null;
		} else {
			this.bitrate = bitrate.toString();
		}
		return this;
	}

	public MediaFileV1Element setWidth(Integer width) {
		if(null != width){
			this.width = Integer.toString(width);
		}
		return this;
	}

	public MediaFileV1Element setHeight(Integer height) {
		if(null != height){
			this.height = Integer.toString(height);
		}
		return this;
	}

	public MediaFileV1Element setUrl(String url) {
		this.url = url;
		return this;
	}

	public MediaFileV1Element setApiFramework(String value){
		this.apiFramework = value;
		
		return this;
	}
	
	@Attribute(name="delivery", required=false)
	private String delivery; //= "progressive" - only video
	
	@Attribute(name="type")
	private String contentType; // = "video/mp4";
	
	@Attribute(name="bitrate", required=false)
	private String bitrate; // = "499";
	
	@Attribute(name="width", required=false)
	private String width; // = "0.1";
	
	@Attribute(name="height", required=false)
	private String height; // = "0.1";
	
	@Path("URL")
	@Text(data=true)
	private String url; // = "http://";
	
	@Attribute(name="apiFramework", required=false)
	private String apiFramework;
	
}
