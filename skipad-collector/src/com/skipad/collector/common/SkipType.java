package com.skipad.collector.common;

public enum SkipType {
	Slide(0),
	Push(1),
	PushTrueView(2);
	
	private int value;
	
	SkipType(int skipTypeId){
		value = skipTypeId;
	}
	
	public static SkipType fromInt(Integer skipTypeId){
		if(null != skipTypeId){
			for (SkipType skipType : SkipType.values()) {
				if(skipType.value == skipTypeId){
					return skipType;
				}
			}
		}
		return SkipType.Slide; 
	}
	
	public int getValue(){
		return value;
	}
}
