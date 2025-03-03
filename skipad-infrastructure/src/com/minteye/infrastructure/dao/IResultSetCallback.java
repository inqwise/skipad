package com.inqwise.infrastructure.dao;

import java.sql.ResultSet;

public interface IResultSetCallback {
	void call(ResultSet reader, int generationId) throws Exception;
}
