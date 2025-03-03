package com.inqwise.infrastructure.dao.customizers;
import java.sql.Connection;

import com.mchange.v2.c3p0.AbstractConnectionCustomizer;

public class NoTransactionConnectionCustomizer extends AbstractConnectionCustomizer {
	@Override
	public void onAcquire(Connection c, String parentDataSourceIdentityToken) throws Exception {
		super.onAcquire(c, parentDataSourceIdentityToken);
		c.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
	}
}
