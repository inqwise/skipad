package com.skipad.collector.entities;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.commons.lang3.StringUtils;

import com.skipad.collector.common.IProperty;
import com.skipad.collector.common.PropertyValueType;

public class Property implements IProperty {

	private String propertyKey;
	private String groupKey;
	private String value;
	private PropertyValueType valueType;
	
	public Property(ResultSet reader) throws SQLException, UnsupportedEncodingException {
		setPropertyKey(reader.getString("PropertyKeyName"));
		setGroupKey(reader.getString("GroupKeyName"));
		setValueType(PropertyValueType.fromInt(reader.getInt("PropertyValueTypeId")));
		setValue(reader.getString("PropertyValue"));
		
		if(getValueType() == PropertyValueType.Html && null != getValue() && StringUtils.isNotEmpty(getValue())){
			setValue(URLDecoder.decode(getValue(), "UTF-8"));
		} 
	}

	@Override
	public String getPropertyKey() {
		return propertyKey;
	}

	public void setPropertyKey(String propertyKey) {
		this.propertyKey = propertyKey;
	}

	@Override
	public String getGroupKey() {
		return groupKey;
	}

	public void setGroupKey(String groupKey) {
		this.groupKey = groupKey;
	}

	@Override
	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	@Override
	public PropertyValueType getValueType() {
		return valueType;
	}

	public void setValueType(PropertyValueType valueType) {
		this.valueType = valueType;
	}
}
