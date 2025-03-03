package com.skipad.collector.common;

import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import com.skipad.collector.vastElements.VastElement;

public interface IAd {
	long getId();
    String getName();
    String getAuid();
    IResource getVideo();
    IResource getImage();
    List<IResource> getResources();
    VastElement getVast(String cid, IPackage propertiesPackage, String version);
    public Integer getPackageId();
    
    public static class ColumnNames
    {
        public static final String ModifyDate = "ModifyDate";
        public static final String AdId = "Ads_Id";
        public static final String AdName = "AdName";
        public static final String Auid = "Auid";
        public static final String CampaignId = "CampaignId";
        public static final String CampaignName = "CampaignName";
        public static final String Description = "AdDesc";
		public static final String PackageId = "AccountProperitesPackageId";
		public static final String SurveyUrl = "SurveyURL";
		public static final String ExternalTagUrl = "ExternalTagURL";
		public static final String SkipTypeId = "SkipTypeId";
    }

	JSONObject getMraid(String cid, IPackage propertiesPackage, String source) throws JSONException;
	VastElement getVpaid(String cid, IPackage propertiesPackage, String version) throws JSONException;
	VastElement getVpaidFlash(String cid, IPackage propertiesPackage, String rawParams, String version);
}
