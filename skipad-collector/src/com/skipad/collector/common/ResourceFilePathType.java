package com.skipad.collector.common;

public enum ResourceFilePathType {
	Undefined(0),
    Relative(1),
	Absolute(2);

	private int value;
	
	ResourceFilePathType(int typeId){
		value = typeId;
	}
	
	public static ResourceFilePathType fromInt(Integer typeId){
		for (ResourceFilePathType type : ResourceFilePathType.values()) {
			if(type.value == typeId){
				return type;
			}
		}

		return ResourceFilePathType.Undefined; 
	}
}
