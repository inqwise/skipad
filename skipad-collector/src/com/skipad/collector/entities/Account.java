package com.skipad.collector.entities;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.skipad.collector.common.IAccount;
import com.skipad.collector.common.IProperty;

public class Account implements IAccount {
	
	private long id;
	private String name;
	private String externalId;
	private int ownerId;
	private Date createDate;
	
	private List<IProperty> properties = new ArrayList<>();
	
	public Account(ResultSet reader) throws SQLException {
		id = reader.getLong(ColumnNames.AccountId);
		name = reader.getString(ColumnNames.AccountName);
		externalId = reader.getString(ColumnNames.AccountExternalId);
		ownerId = reader.getInt(ColumnNames.AccountOwnerId);
		createDate = reader.getDate(ColumnNames.AccountCreateDate);
	}

	public void addProperty(IProperty property) {
		properties.add(property);
	}

	@Override
	public long getId() {
		return id;
	}

	@Override
	public String getName() {
		return name;
	}

	@Override
	public String getExternalId() {
		return externalId;
	}

	@Override
	public int getOwnerId() {
		return ownerId;
	}

	@Override
	public Date getCreateDate() {
		return createDate;
	}

	@Override
	public List<IProperty> getProperties() {
		return properties;
	}

}
