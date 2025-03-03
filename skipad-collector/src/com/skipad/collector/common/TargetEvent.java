package com.skipad.collector.common;

public class TargetEvent {
	private EventType eventType;
	private String url;
	
	public TargetEvent(EventType eventType, String url) {
		super();
		this.eventType = eventType;
		this.url = url;
	}

	public EventType getEventType() {
		return eventType;
	}

	public String getUrl() {
		return url;
	}
}
