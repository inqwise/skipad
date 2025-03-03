package com.skipad.collector.vastElements;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Text;
import org.simpleframework.xml.Version;

public class AdSystemElement {
	
	@Attribute()
	private final static String version = "2.0";
	
	@Text()
	private final static String value = "inqwise";
	
}
