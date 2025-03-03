package com.skipad.collector.vastElements;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name="VideoAdServingTemplate")
public class VastV1Element extends VastElement {
	
	public VastV1Element(String auid) {
		super(auid);
	}
	
	@Element(name="Ad")
	private AdV1Element adElement;
	
	public VastV1Element setInLine(InLineV1Element inLine){
		adElement = new AdV1Element(inLine);
		return this;
	}
}
