package com.skipad.collector.vastElements;


public abstract class VastElement {
	
	private String auid;
	
	public VastElement(String auid) {
		this.auid = auid;
	}
	
	public String getAuid() {
		return auid;
	}
}
