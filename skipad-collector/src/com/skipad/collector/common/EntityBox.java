package com.skipad.collector.common;

public class EntityBox<T> {
	
	private T value;
	
	public EntityBox() {
	}

	public T getValue() {
		return value;
	}

	public void setValue(T value) {
		this.value = value;
	}
}
