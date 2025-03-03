package com.skipad.collector.vastElements;

import java.beans.Introspector;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.ElementArray;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.Root;
import org.simpleframework.xml.Text;
import org.simpleframework.xml.core.Persist;

import com.skipad.collector.common.EventType;

@Root(strict=true)
public class TrackingEventElement {
	
	@Attribute(name="event")
	private String eventTypeName; // = Introspector.decapitalize(EventType.Complete.toString());
	private EventType eventType;
	
	public TrackingEventElement setEventType(EventType eventType) {
		this.eventType = eventType;
		this.eventTypeName = Introspector.decapitalize(eventType.toString());
		return this;
	}

	//public TrackingEventElement setUrl(String url) {
		//this.url = url;
	//	return this;
	//}

	@Text(data=true)
	private String url; // = "http://";
	//private String[] urlArr;
	
	//@ElementList(entry="URL", inline=true, data=true)
	//private ArrayList<String> urlList = new ArrayList<>();

	public EventType getEventType() {
		return eventType;
	}

	//public void addUrl(String url) {
		//urlList.add(url);
	//}
	
	public TrackingEventElement setUrl(String url) {
		this.url = url;
		return this;
	}
	
	//@Persist
	//private void prepare(){
	//	url = StringUtils.join(urlList, "\n<BR />");
		//urlArr = urlList.toArray(new String[urlList.size()]);
	//}
}
