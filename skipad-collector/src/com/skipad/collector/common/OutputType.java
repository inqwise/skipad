package com.skipad.collector.common;

import org.apache.commons.lang3.StringUtils;

public enum OutputType {
	Undefined(null),
    Vast("vast"),
	Mraid("mraid"),
	VpaidHtml5("vpaidhtml5"), 
	VpaidFlash("vpaidflash");

	private String value;
	
	OutputType(String outputTypeId){
		value = outputTypeId;
	}
	
	public static OutputType fromString(String outputTypeId){
		for (OutputType outputType : OutputType.values()) {
			if(null != outputType && StringUtils.equalsIgnoreCase(outputType.value, outputTypeId)){
				return outputType;
			}
		}

		return OutputType.Undefined; 
	}
	
	@Override
	public String toString() {
		return value;
	}
}
