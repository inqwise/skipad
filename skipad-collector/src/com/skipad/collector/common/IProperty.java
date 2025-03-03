package com.skipad.collector.common;

public interface IProperty {

	public abstract PropertyValueType getValueType();

	public abstract String getValue();

	public abstract String getGroupKey();

	public abstract String getPropertyKey();

}
