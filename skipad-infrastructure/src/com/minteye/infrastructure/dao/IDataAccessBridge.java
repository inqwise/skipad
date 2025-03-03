package com.inqwise.infrastructure.dao;

public interface IDataAccessBridge extends IResultSetCallback {
	void fillParams(SqlParams params);
}
