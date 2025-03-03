package com.skipad.collector.vastElements;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name="VAST")
public class VastV2Element extends VastElement {

	public VastV2Element(String auid) {
		super(auid);
	}

	@Attribute(name="version")
	private String version = "2.0";
	
	@Element(name="Ad")
	private AdElement adElement;
	
	public VastElement setInLine(InLineElement inLine){
		adElement = new AdElement(inLine);
		return this;
	}
}
