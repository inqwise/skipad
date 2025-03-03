package com.skipad.collector.common;

public enum PropertyValueType {
	Color(1),
	Text(2),
	Number(3),
	Boolean(4),
	Html(5);

	private int value;
	
	PropertyValueType(int value){
		this.value = value;
	}
	
	public static PropertyValueType fromInt(int value){
		for (PropertyValueType p : PropertyValueType.values()) {
			if(p.value == value){
				return p;
			}
		}

		return Text; 
	}
}