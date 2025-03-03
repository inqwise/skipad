package com.skipad.collector.vastElements;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Path;

public class InLineV1Element {
	
	@Element(name = "AdSystem")
	private AdSystemElement adSystem = new AdSystemElement();
	
	@Element(name = "AdTitle")
	private final static String adTitle = "inqwise";
	
	@Element(name = "VASTAdTagURI", required=false)
	private String externalTagUrl;
	
	@Element(name="Survey", required=false)
	private String surveyUrl;
	
	@Element(name = "Video")
	private VideoV1Element video;
	
	@Element(name = "Error", required=false)
	private String errorUrl;
	
	public InLineV1Element setErrorUrl(String errorUrl){
		this.errorUrl = errorUrl;
		return this;
	}
	
	public InLineV1Element setVideo(VideoV1Element video){
		this.video = video;
		return this;
	}
	
	public InLineV1Element setExternalTagUrl(String externalTagUrl){
		this.externalTagUrl = externalTagUrl;
		return this;
	}
	
	public InLineV1Element setSurveyUrl(String surveyUrl){
		this.surveyUrl = surveyUrl;
		return this;
	}
}
