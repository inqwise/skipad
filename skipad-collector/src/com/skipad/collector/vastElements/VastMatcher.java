package com.skipad.collector.vastElements;

import org.simpleframework.xml.transform.Matcher;
import org.simpleframework.xml.transform.Transform;

public class VastMatcher implements Matcher {

	@Override
	public Transform match(Class type) throws Exception {
		
		//if(type.equals(AdParameterElement.class)){
		//	return AdParameterElement.getTransformInstance();
		//}
		
		//if(type.equals(AdParametersGroupElement.class)){
		//	return AdParametersGroupElement.getTransformInstance();
		//}
		return null;
	}
}
