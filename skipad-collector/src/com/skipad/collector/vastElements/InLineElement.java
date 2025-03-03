package com.skipad.collector.vastElements;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Path;

public class InLineElement {
	
	@Element(name = "AdSystem")
	private AdSystemElement adSystem = new AdSystemElement();
	
	@Element(name = "AdTitle")
	private final static String adTitle = "inqwise";
	
	@Element(name = "VASTAdTagURI", required=false)
	private String externalTagUrl;
	
	@Element(name="Survey", required=false)
	private String surveyUrl;
	
	@Path("Creatives")
	@Element(name = "Creative")
	private CreativeElement creative;
	
	@Element(name = "Error", required=false)
	private String errorUrl;
	
	public InLineElement setErrorUrl(String errorUrl){
		this.errorUrl = errorUrl;
		return this;
	}
	
	public InLineElement setCreative(CreativeElement creative){
		this.creative = creative;
		return this;
	}
	
	public InLineElement setExternalTagUrl(String externalTagUrl){
		this.externalTagUrl = externalTagUrl;
		return this;
	}
	
	public InLineElement setSurveyUrl(String surveyUrl){
		this.surveyUrl = surveyUrl;
		return this;
	}
}
