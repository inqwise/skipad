package com.skipad.collector.vastElements;

import java.util.ArrayList;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.ElementListUnion;
import org.simpleframework.xml.convert.Convert;
import org.simpleframework.xml.core.Complete;

import com.skipad.collector.common.EventType;
import com.skipad.collector.common.ResourceType;
import com.skipad.collector.vastElements.converters.AdParametersGroupElementVpaidV1Converter;

public class VideoV1Element {
	
	@Element(name = "AdID")
	private String adId;
	
	public VideoV1Element setAdId(String adId){
		this.adId = adId;
		return this;
	}
	
	@Element(name="Duration", required=false)
	private String duration;
	
	@ElementList(name="TrackingEvents", entry="Tracking")
	private ArrayList<TrackingEventElement> trackingEventsList = new ArrayList<TrackingEventElement>();
	
	//@Persist
	//public void prepare(){
	//	trackingEventsList = new ArrayList<TrackingEventElement>();
	//	for (TrackingEventElement trackingEvent : trackingEventsSet.values()) {
	//		trackingEventsList.add(trackingEvent);
	//	}
	//}
	
	@Complete
	public void release() {
		trackingEventsList = null;
	}
	
	@Element(name="AdParameters")
	@Convert(AdParametersGroupElementVpaidV1Converter.class)
	private AdParametersGroupElement adParameters;
	
	@ElementListUnion(value={
			@ElementList(name="VideoClicks", entry="ClickThrough", type=ClickElement.class),
			@ElementList(entry="ClickTracking", type=ClickTrackingEventElement.class)
	})
	private ArrayList<Object> clicks = new ArrayList<>();
	
	@ElementList(name="MediaFiles", entry="MediaFile", required=false)
	private ArrayList<MediaFileV1Element> files = new ArrayList<MediaFileV1Element>();
	
	
	public VideoV1Element addTrackingEvent(EventType eventType, String url){
		
		TrackingEventElement trackingEvent = new TrackingEventElement().setEventType(eventType).setUrl(url);
		trackingEventsList.add(trackingEvent);
		return this;
	}
	
	public VideoV1Element addClickEvent(ResourceType resourceType, String url, String eventUrl){
		clicks.add(new ClickElement().setResource(resourceType).setUrl(url));
		switch (resourceType) {
		case Image:
			clicks.add(new ClickTrackingEventElement().setResourceType(resourceType).setUrl(eventUrl));
			break;
		case Video:
			clicks.add(new ClickTrackingEventElement().setResourceType(resourceType).setUrl(eventUrl));
			break;
		default:
			throw new Error("addClickEvent: Unimplemented resourceType: " + resourceType);
		}
		return this;
	}
	
	public VideoV1Element addMediaFile(MediaFileV1Element file){
		files.add(file);
		return this;
	}
	
	public VideoV1Element addDuration(String duration){
		this.duration = duration;
		return this;
	}
	
	public VideoV1Element addParameter(IAdParameter parameter){
		if(null == adParameters) adParameters = new AdParametersGroupElement("AdParameters", new ArrayList<IAdParameter>()); 
		adParameters.addParameter(parameter);
		
		return this;
	}
	
	public VideoV1Element setRawParameters(String text){
		if(null == adParameters) {
			adParameters = new AdParametersGroupElement(text);
		} else {
			adParameters.setText(text);
		}
		
		return this;
	}
}
