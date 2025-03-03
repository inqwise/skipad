package com.skipad.collector.common;

public enum ResourceType {
	Undefined(0),
    Video(1),
	Image(2), Javascript(3), Flash(4),
	Audio(5);

	private int value;
	
	ResourceType(int resourceTypeId){
		value = resourceTypeId;
	}
	
	public static ResourceType fromInt(Integer resourceTyperId){
		for (ResourceType resourceType : ResourceType.values()) {
			if(resourceType.value == resourceTyperId){
				return resourceType;
			}
		}

		return ResourceType.Undefined; 
	}
}
