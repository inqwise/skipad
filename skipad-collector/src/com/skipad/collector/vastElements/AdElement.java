package com.skipad.collector.vastElements;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Element;

public class AdElement {
	
	public AdElement(InLineElement inLine) {
		this.inLine = inLine;
	}

	@Attribute(name="id")
	private final static String id = "INQWISE_SKIPAD";
	
	@Element(name="InLine")
	private InLineElement inLine;
}
