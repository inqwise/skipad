package com.skipad.collector.vastElements;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Text;

public class AdParameterElement<T> implements IAdParameter {

	@Attribute(name = "id")
	private String key;

	public T getValue() {
		return value;
	}

	public void setValue(T value) {
		this.value = value;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	@Text(required = false, data=true)
	private T value;
	private String groupKey;
	
	public AdParameterElement(String key, T value, String groupKey) {
		this.setKey(key);
		this.setValue(value);
		this.setGroupKey(groupKey);
	}

	public String getGroupKey() {
		return groupKey;
	}

	public void setGroupKey(String groupKey) {
		this.groupKey = groupKey;
	}
}