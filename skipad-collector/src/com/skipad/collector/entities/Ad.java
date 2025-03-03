package com.skipad.collector.entities;

import java.beans.Introspector;
import java.io.File;
import java.io.StringWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.simpleframework.xml.core.Persister;
import org.simpleframework.xml.stream.Format;

import com.inqwise.infrastructure.systemFramework.BaseApplicationConfiguration;
import com.inqwise.infrastructure.systemFramework.ResultSetHelper;
import com.skipad.collector.common.EventType;
import com.skipad.collector.common.IAd;
import com.skipad.collector.common.IPackage;
import com.skipad.collector.common.IProperty;
import com.skipad.collector.common.IResource;
import com.skipad.collector.common.IResourceFile;
import com.skipad.collector.common.ResourceFilePathType;
import com.skipad.collector.common.ResourceType;
import com.skipad.collector.common.SkipType;
import com.skipad.collector.common.TargetEvent;
import com.skipad.collector.systemFramework.ApplicationConfiguration;
import com.skipad.collector.vastElements.AdParameterElement;
import com.skipad.collector.vastElements.CreativeElement;
import com.skipad.collector.vastElements.InLineElement;
import com.skipad.collector.vastElements.InLineV1Element;
import com.skipad.collector.vastElements.MediaFileV1Element;
import com.skipad.collector.vastElements.MediaFileV2Element;
import com.skipad.collector.vastElements.VastElement;
import com.skipad.collector.vastElements.VastV1Element;
import com.skipad.collector.vastElements.VastV2Element;
import com.skipad.collector.vastElements.VideoV1Element;

public class Ad implements IAd {

	private static final String EVENT_URL_FORMAT = "%s?cid=%s&adid=%s&source=%s&ev=%s";
	private long id;
	private String name;
	private String auid;
	private IResource video;
	private IResource image;
	private List<IResource> resources = new ArrayList<>();
	private List<IProperty> properties = new ArrayList<>();
	private Integer packageId;
	private String surveyUrl;
	private String externalTagUrl;
	private List<TargetEvent> targetEvents = new ArrayList<>();
	private SkipType skipType;
	
	public Ad(ResultSet reader) throws SQLException {
		setId(reader.getLong(ColumnNames.AdId));
		setName(reader.getString(ColumnNames.AdName));
		setAuid(reader.getString(ColumnNames.Auid));
		setPackageId(ResultSetHelper.optInt(reader, ColumnNames.PackageId));
		setSurveyUrl(ResultSetHelper.optString(reader, ColumnNames.SurveyUrl));
		setExternalTagUrl(ResultSetHelper.optString(reader, ColumnNames.ExternalTagUrl));
		setSkipType(SkipType.fromInt(ResultSetHelper.optInt(reader, ColumnNames.SkipTypeId)));
	}
	
	public void addResource(Resource resource) {
		resources.add(resource);
		switch (resource.getResourceType()) {
		case Image:
			setImage(resource);
			break;
		case Video:
			setVideo(resource);
			break;
		default:
			break;
		}
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAuid() {
		return auid;
	}

	public void setAuid(String auid) {
		this.auid = auid;
	}

	public IResource getVideo() {
		return video;
	}

	public void setVideo(IResource video) {
		this.video = video;
	}

	public IResource getImage() {
		return image;
	}

	public void setImage(IResource image) {
		this.image = image;
	}

	@Override
	public List<IResource> getResources() {
		return resources;
	}
	
	private static boolean isVersion1(String version){
		return (null != version && (version.startsWith("1.") || version.equals("1") || version.startsWith("1_")));
	}
	
	@Override
	public VastElement getVast(String cid, IPackage propertiesPackage, String version) {
		VastElement vast = null;
		if(isVersion1(version)){
			VideoV1Element videoElement = new VideoV1Element();
			if(null != video) {
				if(video.getResourceFiles().isEmpty()){
					videoElement.addDuration("00:00:00");
				} else {
					videoElement.addDuration(video.getDuration());
				}
			}
			videoElement.setAdId(getAuid());
			
			// Click Events
			for (IResource resource : resources) {
				if(resource.getResourceType() == ResourceType.Image
				|| resource.getResourceType() == ResourceType.Video
				|| resource.getResourceType() == ResourceType.Audio){
					if(resource.isClickable()){
						String eventUrl = getEventUrl(cid, resource, "f");
						videoElement.addClickEvent(resource.getResourceType(), resource.getClickUrl(), eventUrl);
					}
					
					// Media Files
					for (IResourceFile file : resource.getResourceFiles()) {
						MediaFileV1Element mediaFile = new MediaFileV1Element().setDelivery("progressive").setBitrate(file.getBitrate()).setContentType(file.getContentType());
								mediaFile.setHeight(file.getHeight()).setResourceType(resource.getResourceType());
								mediaFile.setUrl(getResourceFilePath(file));
								mediaFile.setWidth(file.getWidth());
						videoElement.addMediaFile(mediaFile);
					}
				}
			}
			
			for(EventType eventType : EventType.values()){
				if(EventType.Undefined != eventType){
					String url = getTrackingEventUrl(cid, eventType, "f");
					videoElement.addTrackingEvent(eventType, url);
				}
			}
			
			videoElement.addParameter(new AdParameterElement<String>("skipType", getSkipTypeText(), null));
			
			List<IProperty> actualProperties = (null == propertiesPackage ? properties : propertiesPackage.getProperties());
			for (IProperty property : actualProperties) {
				if(null != property.getValue()){
					videoElement.addParameter(new AdParameterElement<String>(property.getPropertyKey(), property.getValue(), property.getGroupKey()));
				}
			}
			
			for (TargetEvent targetEvent : targetEvents) {
				switch (targetEvent.getEventType()) {
				case ImageClick:
					//creative.addClickEvent(ResourceType.Image, targetEvent.getUrl(), ) 
					break;
				case VideoClick:
					//creative.addClickEvent(ResourceType.Image)
					break;
				case Undefined:
					break;
				default:
					videoElement.addTrackingEvent(targetEvent.getEventType(), targetEvent.getUrl());
					break;
				}
			}
			
			StringBuilder errorUrl = getErrorUrl(cid);
			vast = new VastV1Element(getAuid()).setInLine(new InLineV1Element().setVideo(videoElement).setErrorUrl(errorUrl.toString()).setExternalTagUrl(getExternalTagUrl()).setSurveyUrl(getSurveyUrl()));
		} else {
			CreativeElement creative = new CreativeElement();
			if(null != video) {
				if(video.getResourceFiles().isEmpty()){
					creative.addDuration("00:00:00");
				} else {
					creative.addDuration(video.getDuration());
				}
			}
			creative.setAdId(getAuid());
			
			// Click Events
			for (IResource resource : resources) {
				if(resource.getResourceType() == ResourceType.Image
				|| resource.getResourceType() == ResourceType.Video
				|| resource.getResourceType() == ResourceType.Audio){
					if(resource.isClickable()){
						String eventUrl = getEventUrl(cid, resource, "f");
						creative.addClickEvent(resource.getResourceType(), resource.getClickUrl(), eventUrl);
					}
					
					// Media Files
					for (IResourceFile file : resource.getResourceFiles()) {
						MediaFileV2Element mediaFile = new MediaFileV2Element().setDelivery("progressive").setBitrate(file.getBitrate()).setContentType(file.getContentType());
								mediaFile.setHeight(file.getHeight()).setResourceType(resource.getResourceType());
								mediaFile.setUrl(getResourceFilePath(file));
								mediaFile.setWidth(file.getWidth());
						creative.addMediaFile(mediaFile);
					}
				}
			}
			
			for(EventType eventType : EventType.values()){
				if(EventType.Undefined != eventType){
					String url = getTrackingEventUrl(cid, eventType, "f");
					creative.addTrackingEvent(eventType, url);
				}
			}
			
			creative.addParameter(new AdParameterElement<String>("skipType", getSkipTypeText(), null));
			
			List<IProperty> actualProperties = (null == propertiesPackage ? properties : propertiesPackage.getProperties());
			for (IProperty property : actualProperties) {
				if(null != property.getValue()){
					creative.addParameter(new AdParameterElement<String>(property.getPropertyKey(), property.getValue(), property.getGroupKey()));
				}
			}
			
			for (TargetEvent targetEvent : targetEvents) {
				switch (targetEvent.getEventType()) {
				case ImageClick:
					//creative.addClickEvent(ResourceType.Image, targetEvent.getUrl(), ) 
					break;
				case VideoClick:
					//creative.addClickEvent(ResourceType.Image)
					break;
				case Undefined:
					break;
				default:
					creative.addTrackingEvent(targetEvent.getEventType(), targetEvent.getUrl());
					break;
				}
			}
			
			StringBuilder errorUrl = getErrorUrl(cid);
			vast = new VastV2Element(getAuid()).setInLine(new InLineElement().setCreative(creative).setErrorUrl(errorUrl.toString()).setExternalTagUrl(getExternalTagUrl()).setSurveyUrl(getSurveyUrl()));
			
		}
		return vast;
	}

	private StringBuilder getErrorUrl(String cid) {
		return new StringBuilder(BaseApplicationConfiguration.Urls.getErrorUrl()).append("?cid=").append(cid).append("&adid=").append(auid).append("&error=");
	}

	private static String getOfficeTemplateFile(String fileName){
		File file1 = new File(BaseApplicationConfiguration.getTemplatesFolder());
		File file2 = new File(file1, fileName);
		return file2.getPath();
	}

	@Override
	public JSONObject getMraid(String cid, IPackage propertiesPackage, String source) throws JSONException {
		JSONObject ad = new JSONObject();
		JSONObject trackingEvents = new JSONObject();
		JSONArray mediaFiles = new JSONArray();
		
		ad.put("adid", getAuid());
		
		//fill Tracking Events
		for(EventType eventType : EventType.values()){
			if(EventType.Undefined != eventType){
				String url = getTrackingEventUrl(cid, eventType, StringUtils.join(source, "m"));
				JSONArray urls = new JSONArray();
				urls.put(url);
				trackingEvents.put(Introspector.decapitalize(eventType.toString()), urls);
			}
		}
		ad.put("trackingEvents", trackingEvents);
		
		//fill clicks
		for (IResource resource : resources) {
			if(resource.getResourceType() == ResourceType.Image
			|| resource.getResourceType() == ResourceType.Video
			|| resource.getResourceType() == ResourceType.Audio){
				
				// fill Media Files
				for (IResourceFile file : resource.getResourceFiles()) {
					JSONObject mediaFile = new JSONObject();
					mediaFile.put("id", Introspector.decapitalize(resource.getResourceType().toString()));
					mediaFile.put("type", file.getContentType());
					mediaFile.put("bitrate", file.getBitrate());
					if(null != file.getWidth()){
						mediaFile.put("width", file.getWidth());
					}
					
					if(null != file.getHeight()){
						mediaFile.put("height", file.getHeight());
					}
					
					mediaFile.put("url", getResourceFilePath(file));
					
					if(null != resource.getClickUrl()){
						mediaFile.put("clickUrl", resource.getClickUrl());
					}
					
					mediaFiles.put(mediaFile);
				}
			}
		}
		
		ad.put("mediaFiles", mediaFiles);
		ad.put("duration", (getVideo().getResourceFiles().size() == 0 ? "00:00:00" : getVideo().getDuration()));
		ad.put("error", getErrorUrl(cid));
		return ad;
	}

	private String getResourceFilePath(IResourceFile file) {
		String mediaFilePath;
		if(file.getPathType() == ResourceFilePathType.Relative){
			mediaFilePath = BaseApplicationConfiguration.Urls.getResourcesUrl() + "/" + file.getPath();
		} else {
			mediaFilePath = file.getPath();
		}
		return mediaFilePath;
	}

	private String getEventUrl(String cid, IResource resource, String source) {
		return String.format(EVENT_URL_FORMAT, BaseApplicationConfiguration.Urls.getEventUrl(), cid, getAuid(), source, resource.getClickEventType().getValue());
	}

	private String getTrackingEventUrl(String cid, EventType eventType, String source) {
		return String.format(EVENT_URL_FORMAT, BaseApplicationConfiguration.Urls.getEventUrl(), cid, getAuid(), source, eventType.getValue());
	}

	public void addProperty(IProperty property) {
		properties.add(property);
	}

	
	
	@Override
	public VastElement getVpaid(String cid, IPackage propertiesPackage, String version) throws JSONException {
		
		VastElement vast = null;
		
		CreativeElement creative = new CreativeElement();
		if(video.getResourceFiles().isEmpty()){
			creative.addDuration("00:00:00");
		} else {
			creative.addDuration(video.getDuration());
		}
		
		creative.setAdId(getAuid());
		
		// Media Files
		MediaFileV2Element mediaFile = new MediaFileV2Element().setDelivery("progressive").setContentType("application/javascript");
				mediaFile.setHeight(0).setResourceType(ResourceType.Javascript);
				mediaFile.setUrl(ApplicationConfiguration.Vpaid.getJsLinearRendererUrl());
				mediaFile.setWidth(0).setApiFramework("VPAID");
				
		creative.addMediaFile(mediaFile);
		
		creative.setRawParameters(getMraid(cid, propertiesPackage, "vp-").toString());
		
		vast = new VastV2Element(getAuid()).setInLine(new InLineElement().setCreative(creative));
		
		return vast;
	}
	
	@Override
	public VastElement getVpaidFlash(String cid, IPackage propertiesPackage, String rawParams, String version) {
		VastElement vast = null;
		if(isVersion1(version)){
			VideoV1Element videoElement = new VideoV1Element();
			if(video.getResourceFiles().isEmpty()){
				videoElement.addDuration("00:00:00");
			} else {
				videoElement.addDuration(video.getDuration());
			}
			
			videoElement.setAdId(getAuid());
			
			// Media Files
			MediaFileV1Element mediaFile = new MediaFileV1Element().setContentType("application/x-shockwave-flash");
					mediaFile.setHeight(0).setResourceType(ResourceType.Flash);
					mediaFile.setUrl(ApplicationConfiguration.Vpaid.getFlashLinearRendererUrl());
					mediaFile.setWidth(0).setDelivery("progressive");
					
			videoElement.addMediaFile(mediaFile);
			
			if(null == rawParams){
				StringWriter sw = new StringWriter();
				Persister serializer = new Persister(new Format("<?xml version=\"1.0\" encoding= \"UTF-8\" ?>"));
				try {
					serializer.write(getVast(cid, propertiesPackage, version), sw);
				} catch (Exception e) {
					e.printStackTrace();
				}
				rawParams = sw.toString().replaceAll("]]>", "]]]]><![CDATA[>");
			}
			videoElement.setRawParameters(rawParams);
			
			vast = new VastV1Element(getAuid()).setInLine(new InLineV1Element().setVideo(videoElement));
		
		} else {
			CreativeElement creative = new CreativeElement();
			if(video.getResourceFiles().isEmpty()){
				creative.addDuration("00:00:00");
			} else {
				creative.addDuration(video.getDuration());
			}
			
			creative.setAdId(getAuid());
			
			// Media Files
			MediaFileV2Element mediaFile = new MediaFileV2Element().setDelivery("progressive").setContentType("application/x-shockwave-flash");
					mediaFile.setHeight(0).setResourceType(ResourceType.Flash);
					mediaFile.setUrl(ApplicationConfiguration.Vpaid.getFlashLinearRendererUrl());
					mediaFile.setWidth(0).setApiFramework("VPAID");
					
			creative.addMediaFile(mediaFile);
			
			if(null == rawParams){
				StringWriter sw = new StringWriter();
				Persister serializer = new Persister(new Format("<?xml version=\"1.0\" encoding= \"UTF-8\" ?>"));
				try {
					serializer.write(getVast(cid, propertiesPackage, version), sw);
				} catch (Exception e) {
					e.printStackTrace();
				}
				rawParams = sw.toString().replaceAll("]]>", "]]]]><![CDATA[>");
			}
			creative.setRawParameters(rawParams);
			
			vast = new VastV2Element(getAuid()).setInLine(new InLineElement().setCreative(creative));
		}
		return vast;
	}

	public Integer getPackageId() {
		return packageId;
	}

	public void setPackageId(Integer packageId) {
		this.packageId = packageId;
	}

	public String getSurveyUrl() {
		return surveyUrl;
	}

	public void setSurveyUrl(String surveyUrl) {
		this.surveyUrl = surveyUrl;
	}

	public String getExternalTagUrl() {
		return externalTagUrl;
	}

	public void setExternalTagUrl(String externalTagUrl) {
		this.externalTagUrl = externalTagUrl;
	}
	
	public void addTargetEvent(ResultSet reader) throws SQLException {
		EventType eventType = EventType.fromInt(reader.getInt("EventTypeId"));
		String url = reader.getString("URL");
		this.targetEvents.add(new TargetEvent(eventType, url));
	}

	public SkipType getSkipType() {
		return skipType;
	}

	public void setSkipType(SkipType skipType) {
		this.skipType = skipType;
	}
	
	public String getSkipTypeText() {
		switch (getSkipType()) {
		case Push:
		case PushTrueView:
			return "push";

		default:
			return "slider";
		}
	}
}
