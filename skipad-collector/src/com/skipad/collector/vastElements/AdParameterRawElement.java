package com.skipad.collector.vastElements;

import org.simpleframework.xml.transform.Transform;

public class AdParameterRawElement implements IAdParameter {

	private String value;
	public AdParameterRawElement() {
	}
	
	public AdParameterRawElement(String value) {
		this.value = value;
	}
	
	@Override
	public String getKey() {
		return null;
	}

	@Override
	public String getGroupKey() {
		return null;
	}

	@Override
	public Object getValue() {
		return value;
	}

	private static Transform<AdParameterRawElement> transformInstance;
	public static synchronized Transform<AdParameterRawElement> getTransformInstance(){
		if(null == transformInstance){
			transformInstance = new Transform<AdParameterRawElement>() {
				
				@Override
				public String write(AdParameterRawElement arg0) throws Exception {
					if(null == arg0.getValue()) return null;
					return arg0.getValue().toString();
				}
				
				@Override
				public AdParameterRawElement read(String arg0) throws Exception {
					return new AdParameterRawElement();
				}
			};
		}
		return transformInstance;
	}
}
