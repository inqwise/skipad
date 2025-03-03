package com.skipad.collector.common;

public enum EventType {
	Undefined(0),
	Start(1),
	FirstQuartile(2),
	Midpoint(3),
	ThirdQuartile(4),
	Complete(5),
	Mute(6),
	Pause(7),
	SliderStart(8),
	SliderComplete(9),
	SliderMissed(10),
	SkipButton(11),
	VideoClick(13),
	ImageClick(14),
	SkipSlider(15),
	ImageComplete(16),
	SliderClick(17),
	Hover(18),
	HoverSlider(19),
	SlideBorder(20),
	SkipForced(21),
	Share(22),
	Replay(23),
	CustomComplete(24),
	Rate(30) /*EventsTypeIds [30 - 39] reserved by Rate*/;
	
	/* 
	EventTypeIds [90 - 99] reserved for errors
	GeneralError(90)
	ImageLoadError(91)
	VideoLoadError(92) 
	*/
	private int value;
	
	EventType(int eventTypeId){
		value = eventTypeId;
	}
	
	public static EventType fromInt(Integer eventTypeId){
		for (EventType eventType : EventType.values()) {
			if(eventType.value == eventTypeId){
				return eventType;
			}
		}

		return EventType.Undefined; 
	}
	
	public int getValue(){
		return value;
	}
}
