package com.skipad.collector.vastElements;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map.Entry;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.ElementListUnion;
import org.simpleframework.xml.Path;
import org.simpleframework.xml.Root;
import org.simpleframework.xml.convert.Convert;
import org.simpleframework.xml.core.Commit;
import org.simpleframework.xml.core.Complete;
import org.simpleframework.xml.core.Persist;
import org.simpleframework.xml.core.Resolve;
import org.simpleframework.xml.core.Validate;

import com.google.common.annotations.Beta;
import com.skipad.collector.common.EventType;
import com.skipad.collector.common.ResourceType;
import com.skipad.collector.vastElements.converters.AdParametersGroupElementVpaidConverter;

@Root
public class CreativeElement {
	
	@Attribute(name = "sequence")
	private final static int sequence = 1;
	
	@Attribute(name = "AdID")
	private String adId;
	
	public CreativeElement setAdId(String adId){
		this.adId = adId;
		return this;
	}
	
	@Path("Linear")
	@Element(name="Duration", required=false)
	private String duration;
	
	
	//private HashMap<EventType, TrackingEventElement> trackingEventsSet = new HashMap<>();
	
	@Path("Linear")
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
	
	@Path("Linear")
	@Element(name="AdParameters")
	@Convert(AdParametersGroupElementVpaidConverter.class)
	private AdParametersGroupElement adParameters;
	
	@Path("Linear")
	@ElementListUnion(value={
			@ElementList(name="VideoClicks", entry="ClickThrough", type=ClickElement.class),
			@ElementList(entry="ClickTracking", type=ClickTrackingEventElement.class)
	})
	private ArrayList<Object> clicks = new ArrayList<>();
	
	@Path("Linear")
	@ElementList(name="MediaFiles", entry="MediaFile", required=false)
	private ArrayList<MediaFileV2Element> files = new ArrayList<MediaFileV2Element>();
	
	
	public CreativeElement addTrackingEvent(EventType eventType, String url){
		
		TrackingEventElement trackingEvent = new TrackingEventElement().setEventType(eventType).setUrl(url);
		trackingEventsList.add(trackingEvent);
		return this;
	}
	
	public CreativeElement addClickEvent(ResourceType resourceType, String url, String eventUrl){
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
	
	public CreativeElement addMediaFile(MediaFileV2Element file){
		files.add(file);
		return this;
	}
	
	public CreativeElement addDuration(String duration){
		this.duration = duration;
		return this;
	}
	
	public CreativeElement addParameter(IAdParameter parameter){
		if(null == adParameters) adParameters = new AdParametersGroupElement("AdParameters", new ArrayList<IAdParameter>()); 
		adParameters.addParameter(parameter);
		
		return this;
	}
	
	public CreativeElement setRawParameters(String text){
		if(null == adParameters) {
			adParameters = new AdParametersGroupElement(text);
		} else {
			adParameters.setText(text);
		}
		
		return this;
	}
}
