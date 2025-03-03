package com.skipad.collector.vastElements;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Element;

public class AdV1Element {
	
	public AdV1Element(InLineV1Element inLine) {
		this.inLine = inLine;
	}

	@Attribute(name="id")
	private final static String id = "INQWISE_SKIPAD";
	
	@Element(name="InLine")
	private InLineV1Element inLine;
}
