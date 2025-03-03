package com.skipad.collector.vastElements;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.ElementListUnion;
import org.simpleframework.xml.Root;
import org.simpleframework.xml.transform.Transform;

@Root
public class AdParametersGroupElement implements IAdParameter {

	@Attribute(name="id")
	private String key;
	
	private String text;
	
	public void setText(String text){
		this.text = text;
	}
	
	public AdParametersGroupElement(@Attribute(name="id") String key, @ElementListUnion({
		@ElementList(entry="Parameter", type=AdParameterElement.class, inline=true, required=false),
		@ElementList(entry="ParametersGroup", type=AdParametersGroupElement.class, inline=true, required=false),
		//@ElementList(entry="Raw", type=AdParameterRawElement.class, inline=true),
   }) List<IAdParameter> list) {
		this.key = key;
		
		this.list = list;
	}
	
	public AdParametersGroupElement(String text){
		this.key = "AdParameters";
		this.text = text;
	}
	
	@ElementListUnion({
		@ElementList(entry="Parameter", type=AdParameterElement.class, inline=true, required=false),
		@ElementList(entry="ParametersGroup", type=AdParametersGroupElement.class, inline=true, required=false),
		//@ElementList(entry="Raw", type=AdParameterRawElement.class, inline=true),
	})
	private List<IAdParameter> list;
	
	private Hashtable<String, IAdParameter> set = new Hashtable<>();
	
	public List<IAdParameter> getList(){
		return list;
	}
	
	public void addParameter(IAdParameter value){
		if(null == value.getGroupKey() || key.equals(value.getGroupKey())){
			set.put(key, value);
			list.add(value);
		} else {
			IAdParameter param = set.get(value.getGroupKey());
			if(null == param){
				param = new AdParametersGroupElement(value.getGroupKey(), new ArrayList<IAdParameter>());
				set.put(value.getGroupKey(), param);
				list.add(param);
			}
			
			((AdParametersGroupElement)param).addParameter(value);
		}
	}

	@Override
	public String getKey() {
		return key;
	}

	@Override
	public String getGroupKey() {
		return null;
	}
	
	
	private static Transform<AdParametersGroupElement> transform = new Transform<AdParametersGroupElement>() {
		
		@Override
		public String write(AdParametersGroupElement p) throws Exception {
			return null;
		}
		
		@Override
		public AdParametersGroupElement read(String str) throws Exception {
			// TODO Auto-generated method stub
			return null;
		}
	};
	
	public static Transform<AdParametersGroupElement> getTransformInstance() {
		return transform;
	}

	
	@Override
	public Object getValue() {
		return set;
	}

	public String getText() {
		return text;
	}

	/*
	@Override
	public String getVastXml() {
		StringBuilder sb = new StringBuilder();
		sb.append(String.format("<%s>", getKey()));
		
		for (IAdParameter subp : set.values()) {
			sb.append(subp.getVastXml());
		}
		
		sb.append(String.format("</%s>", getKey()));
		return sb.toString();
	}
	*/
}
