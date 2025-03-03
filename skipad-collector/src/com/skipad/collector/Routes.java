package com.skipad.collector;

import org.jboss.netty.handler.codec.http.HttpMethod;
import org.restexpress.RestExpress;

import com.skipad.collector.controller.ClientAccessPolicyController;
import com.skipad.collector.controller.CrossDomainController;
import com.skipad.collector.controller.ErrorsController;
import com.skipad.collector.controller.EventsController;
import com.skipad.collector.controller.InvalidateController;
import com.skipad.collector.controller.TagsController;

public final class Routes {
	public static void define(RestExpress server){
		server.uri("/tag/{auid}/{otp}", TagsController.getInstance())
		.method(HttpMethod.GET)
		.noSerialization();
		
		// backward compatibility
		server.uri("/tag", TagsController.getInstance())
		.method(HttpMethod.GET)
		.noSerialization();
		
		server.uri("/event", EventsController.getInstance())
		.method(HttpMethod.GET)
		.noSerialization();
		
		server.uri("/crossdomain.xml", CrossDomainController.getInstance())
		.method(HttpMethod.GET)
		.noSerialization();
		
		server.uri("/clientaccesspolicy.xml", ClientAccessPolicyController.getInstance())
		.method(HttpMethod.GET)
		.noSerialization();
		
		server.uri("/Crossdomain.xml", CrossDomainController.getInstance())
		.method(HttpMethod.GET)
		.noSerialization();
		
		server.uri("/Clientaccesspolicy.xml", ClientAccessPolicyController.getInstance())
		.method(HttpMethod.GET)
		.noSerialization();
		
		server.uri("/error", ErrorsController.getInstance())
		.method(HttpMethod.GET)
		.noSerialization();
		
		server.uri("/invalidate", InvalidateController.getInstance())
		.method(HttpMethod.GET)
		.noSerialization();
		/*
		_handlers.put("/event", new EventsHandler());
		_handlers.put("/crossdomain.xml", new CrossDomainHandler());
		_handlers.put("/error", new ErrorsHandler());
		_handlers.put("/invalidate", new InvalidateHandler());
		*/
		
		/*
		server.uri("/collector", CollectorController.getInstance())
		///collector?rq=
		.method(HttpMethod.GET, HttpMethod.POST)
		.noSerialization();
		
		server.uri("/counter", CounterController.getInstance())
		///collector?rq=
		.method(HttpMethod.GET)
		.noSerialization();

		server.uri("/site", FrontController.getInstance())
		///collector?rq=
		.method(HttpMethod.GET, HttpMethod.POST)
		.noSerialization();
		
		server.uri("/pay/{action}/{processorTypeId}", PayController.getInstance())
		.method(HttpMethod.GET)
		.noSerialization();
		*/
	}
}
