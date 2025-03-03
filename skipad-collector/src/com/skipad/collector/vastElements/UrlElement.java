package com.skipad.collector.vastElements;

import org.simpleframework.xml.Text;

public class UrlElement {
	
	@Text()
	private String url; 
	public UrlElement(String url) {
		this.url = url;
	}
}
