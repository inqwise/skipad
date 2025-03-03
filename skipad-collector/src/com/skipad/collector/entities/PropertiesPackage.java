package com.skipad.collector.entities;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.skipad.collector.common.IPackage;
import com.skipad.collector.common.IProperty;


public class PropertiesPackage implements IPackage {

	private String name;
	private String externalId;
	private int id;
	
	private List<IProperty> properties = new ArrayList<>();
	
	public PropertiesPackage(ResultSet reader) throws SQLException {
		name = reader.getString("PackageName");
	}

	public void addProperty(IProperty property) {
		properties.add(property);
	}

	@Override
	public List<IProperty> getProperties() {
		return properties;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getExternalId() {
		return externalId;
	}

	public void setExternalId(String externalId) {
		this.externalId = externalId;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
}
