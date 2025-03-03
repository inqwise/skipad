<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="NewAd.aspx.cs" Inherits="NewAd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
	<link rel="stylesheet" type="text/css" href="Styles/colorbox/colorbox.css" />
	<script type="text/javascript" src="scripts/jquery.colorbox-min.js"></script>
	
	<script type="text/javascript" src="scripts/validator/validator-1.2.8.js"></script>
	<script type="text/javascript" src="scripts/buttons/buttons.js"></script>
		
	<style type="text/css">
	.params .param-value {
    	float: left;
    	max-width: 100%;
    	min-height: 22px;
	}
	</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TitleHolder" Runat="Server">
<div style="height: 66px;">
	<div id="breadcrumbs_no_campaign" style="display: none;">
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
	    	<tr>
	    		<td valign="top">
	    			<div class="breadcrumbs"><a href="ads.aspx" title="Ads">Ads</a>&nbsp;&rsaquo;&nbsp;</div>
	    			<h1>Create New Ad</h1>
	    		</td>
	    		<td valign="top">
	    			
	    		</td>
	    	</tr>
	    </table>
	</div>
	<div id="breadcrumbs_has_campaign" style="display: none;">
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
	    	<tr>
	    		<td valign="top">
	    			<div class="breadcrumbs"><a href="campaigns.aspx" title="Campaigns">Campaigns</a>&nbsp;&rsaquo;&nbsp;<a href="#" title="Campaign" id="campaign_name">Campaign</a>&nbsp;&rsaquo;&nbsp;</div>
	    			<h1>New Ad</h1>
	    		</td>
	    		<td valign="top">
	    			
	    		</td>
	    	</tr>
	    </table>
	</div>
</div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="SloganHolder" Runat="Server">
</asp:Content>


<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" Runat="Server">

<div>

	<div class="params" id="params_campaign" style="display: none;">
		<div class="param-name"><span>* Campaign:</span></div>
		<div class="param-value">
			<div>
				<select id="select_campaign" name="campaign"></select>
			</div>
			<div><label id="status_campaign"></label></div>
		</div>
	</div>
	<div class="params">
		<div class="param-name"><span>* Ad Name:</span></div>
		<div class="param-value">
			<div><input type="text" style="width: 225px;" autocomplete="off" maxlength="254" name="ad_name" id="text_ad_name" /></div>
			<div><label id="status_ad_name"></label></div>
		</div>
	</div>
	
	<div>
		<div class="params" style="overflow: hidden;">
			<div class="param-name">* Ad type:</div>
			<div class="param-value">
				<select id="ad_type" autocomplete="off">
					<option value="1">Linear - I have the video Asset direct URL</option>
					<option value="2">Wrapper - I would like to use an External VAST tag</option>
				</select>
			</div>
		</div>
		
        <div class="params" style="overflow: hidden;">
			<div class="param-name">* Skip type:</div>
			<div class="param-value">
				<select id="skip_type" autocomplete="off">
					<option value="0">Slide</option>
					<option value="1">Push</option>
				</select>
			</div>
		</div>

		<div class="form_linear">
			<div class="params" style="overflow: hidden;">
				<div class="param-name"><span>* Video:</span></div>
				<div class="param-value">
					<div style="color: #666; padding-bottom: 10px;">For <b>Full</b> Flash &amp; HTML5 support it's recommended to upload <b>*.mp4</b>, <b>*.webm</b> &amp; <b>*.ogv</b> Video file format </div>
				<!--
				<div style="clear: both;">
					Select a video for your ad<br/>
					We offers different formats for video advertisement.<br/>
					You can choose to run on all of them or select your preferences individually.
				</div>
				<div style="padding-top: 10px;" class="ui-form">
					<div><label><span><input type="radio" name="video_format" value="0" checked="checked" autocomplete="off" /></span>Automatic</label></div>
					<div><label><span><input type="radio" name="video_format" value="1" autocomplete="off" /></span>Let me choose...</label></div>
				</div>
				-->
					<a id="anchor_ad_video"></a>
					<div id="list_video_inline_upload"></div>
					<div id="button_video_add_container" style="display: none;">
						<a class="button-add-option" title="Add additional video size or type" id="button_video_add">+ Add additional video size or type</a>
					</div>
					<div>
						<label id="error_ad_video" name="error_ad_video" class="status" style="display: none;"></label>
					</div>
					<div>
						<label id="status_ad_video" name="status_ad_video" class="status" style="display: none;">This field is required.</label>
					</div>
				</div>
			</div>
			<div class="params" style="overflow: hidden;">
				<div class="param-name">&nbsp;</div>
				<div class="param-value">
					<div style="padding-bottom: 6px;"><span>* Video Click URL:</span></div>
					<div>
						<div class="param-value"><input type="text" placeholder="Enter a URL" id="text_video_click_url" name="video_click_url" autocomplete="off" /></div>
						<div class="param-value" style="margin-left: 6px; line-height: 20px;">
							<a id="link_check_video_click_url" target="_blank" class="ui-link-disabled" title="Check URL">Check URL</a>
						</div>
					</div>
					<div style="clear: both;"><label id="status_video_click_url"></label></div>
				</div>
			</div>
			<div style="height: 24px; overflow: hidden;">&nbsp;</div>
		</div>
		
		<div class="form_wrapper" style="display: none">
			<div class="params" style="height: 70px;">
				<div class="param-name">* VAST Wrapper URL:</div>
				<div class="param-value">
					<div><textarea id="text_vast_wrapper_url" name="vast_wrapper_url" placeholder="Enter VAST URL" autocomplete="off" style="width: 314px; height: 64px;"></textarea></div>
					<div><label id="status_vast_wrapper_url"></label></div>
				</div>
			</div>
		</div>
		
	</div>
	
	<div>
		<div class="params" style="overflow: hidden;">
			<div class="param-name"><span>* Image:</span></div>
			<div class="param-value">
				<a id="anchor_ad_image"></a>
				<div id="list_image_inline_upload"></div>
				<div id="button_image_add_container" style="display: none;">
					<a class="button-add-option" title="Add additional image size" id="button_image_add">+ Add additional image size</a>
				</div>
				<div>
					<label id="error_ad_image" name="error_ad_image" class="status" style="display: none;"></label>
				</div>
				<div>
					<label id="status_ad_image" name="status_ad_image" class="status" style="display: none;">This field is required.</label>
				</div>
			</div>
		</div>
		<div class="params" style="overflow: hidden;">
			<div class="param-name">&nbsp;</div>
			<div class="param-value">
				<div style="padding-bottom: 6px;"><span>* Image Click URL:</span></div>
				<div>
					<div class="param-value"><input type="text" placeholder="Enter a URL" id="text_image_click_url" name="image_click_url" autocomplete="off" /></div>
					<div class="param-value" style="margin-left: 6px; line-height: 20px;">
						<a id="link_check_image_click_url" target="_blank" class="ui-link-disabled" title="Check URL">Check URL</a>
					</div>
				</div>
				<div style="clear: both;"><label id="status_image_click_url"></label></div>
				<div style="height: 24px; overflow: hidden;">&nbsp;</div>
			</div>
		</div>
	</div>
	
	
	<!-- form_linear -->
	<div>
		<div class="params">
			<div class="param-name"><span>Fitted image sound bite: (optional)</span></div>
			<div class="param-value">
				<div style="color: #666; padding-bottom: 10px;">The sound bite will be played when user Fit the image correctly
 .mp3 file / up to 5 Sec/ up to 1MB</div>
				<div id="list_audio_inline_upload">...</div>
				<div>
					<label id="error_ad_audio" name="error_ad_audio" class="status" style="display: none;"></label>
				</div>
			</div>
		</div>
	</div>
	
	<div>
		<div class="params">
			<div class="param-name">Survey URL: (optional)</div>
			<div class="param-value">
				<input type="text" id="text_survey_url" />
			</div>
		</div>
	</div>
	
    

	<div style="height: 24px; overflow: hidden; clear: both;"></div>
	<div class="params">
		<div class="param-name"></div>
		<div class="param-value">
			<a class="button-green" title="Save Ad" id="button_save"><span>Save Ad</span></a>
		</div>
		<div class="param-value" style="margin-left: 6px; line-height: 20px;">
			<a href="#" title="Cancel" id="button_cancel">Cancel</a>
		</div>
	</div>

</div>



<script type="text/javascript">
var getCampaign = function(params) {

	var obj = {
		getCampaign : {
			accountId: params.accountId,
			campaignId : params.campaignId
		}
	};
	
	$.ajax({
	    url: "handlers/campaigns.ashx",
	    data: { 
	    	rq : JSON.stringify(obj),
	    	timestamp : $.getTimestamp()
	    },
	    dataType: "json",
	    success: function (data, status) {
	    
	    	if(data != undefined) {
	        	
	        	if(data.error != undefined) {
					
					/*
	        		errorHandler({
						error : data.error	
					});
	        		*/
	        		
	        		if(params.error != undefined 
							&& typeof params.error == 'function') {
						params.error(data);
					}
				} else {
					if(params.success != undefined 
							&& typeof params.success == 'function') {
						params.success(data);
					}
				}
	    	} else {
	    		if(params.error != undefined 
						&& typeof params.error == 'function') {
					params.error();
				}
	    	}
	    	
	    },
	    error: function (XHR, textStatus, errorThrow) {
	        // error
	    }
	});
};

var getCampaigns = function(params) {
	
	var obj = {
		getCampaigns : {
			accountId : params.accountId,
			top : params.top,
			fromDate : params.fromDate,
			toDate : params.toDate
		}
	};

	$.ajax({
        url: "handlers/campaigns.ashx",
        data: { 
        	rq : JSON.stringify(obj),
        	timestamp : $.getTimestamp()
        },
        dataType: "json",
        success: function (data, status) {
        
        	if(data != undefined) {
	        	
	        	if(data.error != undefined) {
					
					/*
	        		errorHandler({
						error : data.error	
					});
	        		*/
	        		
	        		if(params.error != undefined 
							&& typeof params.error == 'function') {
						params.error(data);
					}
				} else {
					if(params.success != undefined 
							&& typeof params.success == 'function') {
						params.success(data);
					}
				}
        	} else {
        		if(params.error != undefined 
						&& typeof params.error == 'function') {
					params.error();
				}
        	}
        	
        },
        error: function (XHR, textStatus, errorThrow) {
            // error
        }
    });
};

var removeResourceFiles = function(params) {
	
	var obj = {
		removeResourceFiles : {
			accountId : params.accountId,
			list : params.list
		}
	};

	$.ajax({
        url: "handlers/resources.ashx",
        data: { 
        	rq : JSON.stringify(obj),
        	timestamp : $.getTimestamp()
        },
        dataType: "json",
        success: function (data, status) {
        
        	if(data != undefined) {
	        	if(data.error != undefined) {
					
					/*
	        		errorHandler({
						error : data.error	
					});
	        		*/
	        		
	        		if(params.error != undefined 
							&& typeof params.error == 'function') {
						params.error(data);
					}
				} else {
					if(params.success != undefined 
							&& typeof params.success == 'function') {
						params.success(data);
					}
				}
        	} else {
        		if(params.error != undefined 
						&& typeof params.error == 'function') {
					params.error();
				}
        	}
        	
        },
        error: function (XHR, textStatus, errorThrow) {
            // error
        }
    });
};

var createAd = function(params) {
	
	var obj = {
		createAd : {
			accountId: params.accountId,
			campaignId : params.campaignId,
			adName : params.adName,
			adTypeId : params.adTypeId,
			videoResourceId : params.videoResourceId,
			videoClickUrl : params.videoClickUrl,
			imageResourceId : params.imageResourceId,
			imageClickUrl : params.imageClickUrl,
			imageGenerate : params.imageGenerate,
			externalTagUrl : params.externalTagUrl,
			audioResourceId : params.audioResourceId,
			surveyUrl: params.surveyUrl,
			skipTypeId : params.skipTypeId
		}
	};

	$.ajax({
        url: "handlers/ads.ashx",
        data: { 
        	rq : JSON.stringify(obj),
        	timestamp : $.getTimestamp()
        },
        dataType: "json",
        success: function (data, status) {
        
        	if(data != undefined) {
	        	
	        	if(data.error != undefined) {
					
					/*
	        		errorHandler({
						error : data.error	
					});
	        		*/
	        		
	        		if(params.error != undefined 
							&& typeof params.error == 'function') {
						params.error(data);
					}
				} else {
					if(params.success != undefined 
							&& typeof params.success == 'function') {
						params.success(data);
					}
				}
        	} else {
        		if(params.error != undefined 
						&& typeof params.error == 'function') {
					params.error();
				}
        	}
        	
        },
        error: function (XHR, textStatus, errorThrow) {
            // error
        }
    });
};


var campaignId = $.getUrlParam("campaign_id");


function getVideosCount() {
	var count = 0;
	for(var item in videoResources) {
		count += 1;
	}
	return count;
}

function getImagesCount() {
	var count = 0;
	for(var item in imageResources) {
		count += 1;
	}
	return count;
}

function isQuantityMatch() {
	var isMatch = false;
	
	var videoLength = 0;
	var imageLength = 0;
	
	for(var item in videoResources) {
		videoLength += 1;
	}
	for(var item in imageResources) {
		imageLength += 1;
	}
	
	if(videoLength != 0 
		&& imageLength != 0) {
		isMatch = (videoLength == imageLength ? true : false);
	}
	
	return isMatch;
}

var sizes = {};
	
function isSizesMatch() {
	var isMatch = false;
	
	sizes = {};
	
	// fill sizes from videos
	for(var item in videoResources) {
		sizes[videoResources[item].width] = {
			height : videoResources[item].height,
			contentType : videoResources[item].contentType
		}
	}
	
	// validate
	var checkSize = function(element) {			
		if(sizes[element.width] != undefined) {
			if(sizes[element.width].height == element.height) {
				return true;
			}
			return false;
		}
		return false;
	};
	
	var total = 0;
	var existCount = 0;
	for(var item in imageResources) {
		if(checkSize(imageResources[item])) {
			existCount += 1;
		}
		total += 1;
	}
	
	if(total == existCount) {
		isMatch = true;
	}

	return isMatch;
}

$(function() {
	
	$("#ad_type").change(function() {
		
		if($(this).val() == "1") {
			// linear
			$(".form_linear").show();
			$(".form_wrapper").hide();
			
		} else {
			// wrapper
			$(".form_linear").hide();
			$(".form_wrapper").show();
		}
		
	});
    
	if(campaignId != "") {
		
		// get campaign details
		getCampaign({
			accountId : $.cookie("aid"),
			campaignId : campaignId,
			success : function(data) {
				
				$("#breadcrumbs_has_campaign").show();
				$("#campaign_name")
				.attr("href", "campaign.aspx?campaign_id=" + campaignId)
				.text(data.campaignName);
				
				
				var defaultFocus = function() {
					$('#text_ad_name').focus();
				};
			
				defaultFocus(); // Set default focus
				
				
				
				
				// cancel
				$('#button_cancel')
				.attr("href", "campaign.aspx?campaign_id=" + campaignId);
				
				
			},
			error: function(error) {
				alert(JSON.stringify(error));
			}
		});
		
	} else {
		
		
		$("#breadcrumbs_no_campaign").show();
		
		
		// get campaigns to fill dropdown
		getCampaigns({
			accountId : $.cookie("aid"),
			success : function(data) {
				
				if(data.list.length != 0) {
				
					$("#select_campaign").empty();
					
			        var q = $("#select_campaign")[0].options;
			        
			        var k = new Option("Please select...", "");
	                try {
	                    q.add(k)
	                } catch (ex) {
	                    q.add(k, null)
	                }
			        
			        for(var i = 0; i < data.list.length; i++) {
			        	var k = new Option("#" + data.list[i].campaignId + " - " + data.list[i].campaignName, data.list[i].campaignId);
	                    try {
	                        q.add(k)
	                    } catch (ex) {
	                        q.add(k, null)
	                    }
			        }
			        
			        
			        
			        var defaultFocus = function() {
						$('#select_campaign').focus();
					};
				
					defaultFocus(); // Set default focus
					
					
		        
		        }
				
			},
			error: function(error) {
				//
			}
		});
		
		
		$("#params_campaign").show();
		
		
		// cancel
		$('#button_cancel')
		.attr("href", "ads.aspx");
		
	}
	
	
	
	
	// videos
	$("#list_video_inline_upload").empty();
	for(var x = 0; x < 1; x++) {
		var uid = $.getTimestamp();
		$("<div id=\"video_upload_" + uid + "\">" +
			"<iframe src=\"inline_upload.html?resource_type_id=1&resource_id=" + getVideoResourceId() + "&thumbnail_resource_id=" + getThumbnailResourceId() + "&mode_id=1&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
		"</div>").appendTo("#list_video_inline_upload");
	}
	
	$("#button_video_add").click(function(e) {
		var uid = $.getTimestamp();
		$("<div id=\"video_upload_" + uid + "\">" +
			"<iframe src=\"inline_upload.html?resource_type_id=1&resource_id=" + getVideoResourceId() + "&thumbnail_resource_id=" + getThumbnailResourceId() + "&mode_id=1&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
		"</div>").appendTo("#list_video_inline_upload");
		
		$("#button_video_add_container").hide();
		
		e.preventDefault();
	});
	
	// images
	$("#list_image_inline_upload").empty();
	for(var y = 0; y < 1; y++) {
		var uid = $.getTimestamp();
		$("<div id=\"image_upload_" + uid + "\">" +
			"<iframe src=\"inline_upload.html?resource_type_id=2&resource_id=" + getImageResourceId() + "&mode_id=1&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
		"</div>").appendTo("#list_image_inline_upload");
	}
	
	$("#button_image_add").click(function(e) {
		var uid = $.getTimestamp();
		$("<div id=\"image_upload_" + uid + "\">" +
			"<iframe src=\"inline_upload.html?resource_type_id=2&resource_id=" + getImageResourceId() + "&mode_id=1&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
		"</div>").appendTo("#list_image_inline_upload");
		
		$("#button_image_add_container").hide();
		
		e.preventDefault();
	});
	
	// video click url 
	
	function checkVideoLink(value) {
		if(/(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/.test(value)) {
	    	$('#link_check_video_click_url')
	    	.attr("href", value)
	    	.removeClass("ui-link-disabled");
	    } else {
	    	$('#link_check_video_click_url')
	    	.removeAttr("href")
	    	.addClass("ui-link-disabled");
	    }
	};
	
	$('#text_video_click_url')
	.on("keyup", function() {
		var value = $(this).val();
	    checkVideoLink(value);
	})
	.bind('paste', function () {
		setTimeout(function () {
			var value = $('#text_video_click_url').val();
			checkVideoLink(value);
		},100);
	})
	.urlInputBox();
	
	
	
	// image click url
	function checkImageLink(value) {
		if(/(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/.test(value)) {
	    	$('#link_check_image_click_url')
	    	.attr("href", value)
	    	.removeClass("ui-link-disabled");
	    } else {
	    	$('#link_check_image_click_url')
	    	.removeAttr("href")
	    	.addClass("ui-link-disabled");
	    }
	};
	
	$('#text_image_click_url')
	.on("keyup", function() {
		var value = $(this).val();
	    checkImageLink(value);
	})
	.bind('paste', function () {
		setTimeout(function () {
			var value = $('#text_image_click_url').val();
			checkImageLink(value);
		},100);
	})
	.urlInputBox();
	
	
	
	// audio
	$("#list_audio_inline_upload").empty();
	for(var y = 0; y < 1; y++) {
		var uid = $.getTimestamp();
		
		$("<div id=\"audio_upload_" + uid + "\">" +
			"<iframe src=\"inline_upload.html?resource_type_id=5&resource_id=" + getAudioResourceId() + "&mode_id=1&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
		"</div>").appendTo("#list_audio_inline_upload");
		
	}
	
	
	
	var v = null;
	v = new validator({
		elements : [
			{
				element : $('#select_campaign'),
				status : $('#status_campaign'),
				validate : function() { return campaignId == "" },
				rules : [
					{ method : 'required', message : 'This field is required.' }
				] 
			},
		    {
				element : $('#text_ad_name'),
				status : $('#status_ad_name'),
				rules : [
					{ method : 'required', message : 'This field is required.' }
				]
			},
			{
				element : $('#text_video_click_url'),
				status : $('#status_video_click_url'),
				rules : [
					{ method : 'required', message : 'This field is required.' },
					{ method : 'url', message : 'Please enter a valid URL.' }
				],
				validate : function() {
					return $("#ad_type").val() == "1" ? true : false
				}
			},
			{
				element : $("#text_vast_wrapper_url"),
				status : $("#status_vast_wrapper_url"),
				rules : [
					{ method : 'required', message : 'This field is required.' },
					{ method : 'url', message : 'Please enter a valid URL.' }
				],
				validate : function() {
					return $("#ad_type").val() == "1" ? false : true
				}
			},
			{
				element : $('#text_image_click_url'),
				status : $('#status_image_click_url'),
				rules : [
					{ method : 'required', message : 'This field is required.' },
					{ method : 'url', message : 'Please enter a valid URL.' }
				]
			}
		],
		submitElement : $('#button_save'),
		accept : function () {
		
			$("#error_ad_video").hide();
			$("#error_ad_image").hide();
			
			
			if($("#ad_type").val() == "1") {
			
				if(videoResourceId != null 
				&& imageResourceId != null) {
				
					/*
					if(isVideoSizesMatch()) {
					*/
						
						// check images after videos
						if(isImageSizesMatch()) {
						
							// OK -> create
							// validate for count match
							if(!isQuantityMatch()) {
						
								if(getVideosCount() < getImagesCount()) {
									
						    		 createAd({
										accountId : $.cookie("aid"),
										campaignId : (campaignId != "" ? campaignId : $('#select_campaign').val()),
										adName : $('#text_ad_name').val(),
										adTypeId : 1,
										videoResourceId : videoResourceId,
										videoClickUrl: $('#text_video_click_url').val(),
										imageResourceId : imageResourceId,
										imageClickUrl: $('#text_image_click_url').val(),
										imageGenerate: true,
										audioResourceId : audioResourceId,
										surveyUrl: $('#text_survey_url').val(),
										skipTypeId: $('#skip_type').val(),
										success: function(data) {
											location.href = "ad.aspx?ad_id=" + data.adId;
										},
										error: function(error) {
											alert("ERR -> " + error);
										}
									});
									
									/*
									var modal7 = new lightFace({
										title : "Error",
										message : "The count of Videos less than count of Images.<br/> Please add Videos or remove Images.",
										actions : [
											{ 
										    	label : "OK", 
										    	fire : function() { 
										    		 modal7.close(); 
										    	},
										    	color: "green" 
										    }
										],
										overlayAll : true
									});
									*/
								
								} else {
								
									var modal2 = new lightFace({
										title : "Quantity does not match",
										message : "Quantity of videos and images are not match.<br/> When OK is clicked the System will automatically Fit the image to the correct size.",
										actions : [
										    { 
										    	label : "OK", 
										    	fire : function() { 
										    		 modal2.close(); 
									    		 
										    		 // CREATE AD AND GENERATE
										    		 createAd({
														accountId : $.cookie("aid"),
														campaignId : (campaignId != "" ? campaignId : $('#select_campaign').val()),
														adName : $('#text_ad_name').val(),
														adTypeId : 1,
														videoResourceId : videoResourceId,
														videoClickUrl: $('#text_video_click_url').val(),
														imageResourceId : imageResourceId,
														imageClickUrl: $('#text_image_click_url').val(),
														imageGenerate: true,
														audioResourceId : audioResourceId,
														surveyUrl: $('#text_survey_url').val(),
														skipTypeId: $('#skip_type').val(),
														success: function(data) {
															location.href = "ad.aspx?ad_id=" + data.adId;
														},
														error: function(error) {
															alert("ERR -> " + error);
														}
													});
									    		 
										    	}, 
										    	color: "green" 
										    },
										    { 
										    	label : "Cancel",
										    	fire : function() { 
										    		 modal2.close(); 
										    	}, 
										    	color: "white" 
										    }
										],
										overlayAll : true
									});
								
								}
							
							} else {
						
								if(!isSizesMatch()) {
							
									var modal1 = new lightFace({
										title : "Sizes not match",
										message : "The size of the Video doesn't match the size of the Image.<br/>When OK is clicked the System will automatically Fit the image to the correct size.",
										actions : [
										    { 
										    	label : "OK", 
										    	fire : function() { 
										    		 modal1.close(); 
									    		 
										    		 // CREATE AD AND GENERATE
										    		 createAd({
														accountId : $.cookie("aid"),
														campaignId : (campaignId != "" ? campaignId : $('#select_campaign').val()),
														adName : $('#text_ad_name').val(),
														adTypeId : 1,
														videoResourceId : videoResourceId,
														videoClickUrl: $('#text_video_click_url').val(),
														imageResourceId : imageResourceId,
														imageClickUrl: $('#text_image_click_url').val(),
														imageGenerate: true,
														audioResourceId : audioResourceId,
														surveyUrl: $('#text_survey_url').val(),
														skipTypeId: $('#skip_type').val(),
														success: function(data) {
															location.href = "ad.aspx?ad_id=" + data.adId;
														},
														error: function(error) {
															alert("ERR -> " + error);
														}
													});
									    		  
										    	}, 
										    	color: "green" 
										    },
										    { 
										    	label : "Cancel", 
										    	fire : function() { 
										    		 modal1.close(); 
										    	}, 
										    	color: "white" 
										    }
										],
										overlayAll : true
									});
								
								
								} else {
							
									// SAVE -> ALL IS OK
									createAd({
										accountId : $.cookie("aid"),
										campaignId : (campaignId != "" ? campaignId : $('#select_campaign').val()),
										adName : $('#text_ad_name').val(),
										adTypeId : 1,
										videoResourceId : videoResourceId,
										videoClickUrl: $('#text_video_click_url').val(),
										imageResourceId : imageResourceId,
										imageClickUrl: $('#text_image_click_url').val(),
										imageGenerate : false,
										audioResourceId : audioResourceId,
										surveyUrl: $('#text_survey_url').val(),
										skipTypeId: $('#skip_type').val(),
										success: function(data) {
											location.href = "ad.aspx?ad_id=" + data.adId;
										},
										error: function(error) {
											alert("ERR -> " + error);
										}
									});
								
								}
							
							}
						
						} else {
						
							var modal11 = new lightFace({
								title : "Duplicate Image Size",
								message : "You have duplicate Image Size, please remove one of them.",
								actions: [
									{ 
								    	label : "OK", 
								    	fire : function() {
								    		 modal11.close();
								    	}, 
										color: "green"
								    }
								],
								overlayAll : true
							});
						
						}
				
					/*
					} else {
					
						var modal10 = new lightFace({
							title : "Duplicate Video Size",
							message : "You have duplicate Video Size, please remove one of them.",
							actions: [
								{ 
							    	label : "OK", 
							    	fire : function() {
							    		 modal10.close();
							    	}, 
									color: "green"
							    }
							],
							overlayAll : true
						});
					
					}
					*/
			
				}
			
			} else {
				
				// for VAST Wrapper URL
				if(imageResourceId != null) {
				
					if(isImageSizesMatch()) {
						
						// CREATE AD AND GENERATE
		    		 	createAd({
							accountId : $.cookie("aid"),
							campaignId : (campaignId != "" ? campaignId : $('#select_campaign').val()),
							adName : $('#text_ad_name').val(),
							adTypeId : 2,
							imageResourceId : imageResourceId,
							imageClickUrl: $('#text_image_click_url').val(),
							imageGenerate: true,
							externalTagUrl : $("#text_vast_wrapper_url").val(),
							audioResourceId : audioResourceId,
							surveyUrl : $('#text_survey_url').val(),
							success: function(data) {
								location.href = "ad.aspx?ad_id=" + data.adId;
							},
							error: function(error) {
								alert("ERR -> " + JSON.stringify(error));
							}
						});
						
					
					} else {
				
						var modal11 = new lightFace({
							title : "Duplicate Image Size",
							message : "You have duplicate Image Size, please remove one of them.",
							actions: [
								{ 
						    		label : "OK", 
						    		fire : function() {
						    			 modal11.close();
						    		}, 
									color: "green"
						    	}
							],
							overlayAll : true
						});
				
					}
				
				}
				
				
			}
			
		},
		error: function() {
			$("#error_ad_video").hide();
			$("#error_ad_image").hide();
		}
	});
	
	
	$("#button_save")
	.on("click", function() {
		
		if($("#ad_type").val() == "1") {
		
			if(videoResourceId == null) {
				//$(document).scrollTop( $("#anchor_ad_video").offset().top );
				$("#status_ad_video").show();
			} else {
				$("#status_ad_video").hide();
			}
		
		}
		
		if(imageResourceId == null) {
			//$(document).scrollTop( $("#anchor_ad_image").offset().top );
			$("#status_ad_image").show();
		} else {
			$("#status_ad_image").hide();
		}
		
	});
	
	
});

</script>

<script type="text/javascript">

var videoResourceId = null;
var thumbnailResourceId = null;
var videoResources = {};


var videoSizes = {};
function isVideoSizesMatch(data) {
	var isMatch = false;
	
	var videoCount = 0;
	videoSizes = {};
	
	// fill sizes from videos
	for(var item in videoResources) {
		videoSizes[videoResources[item].width] = {
			height : videoResources[item].height,
			contentType : videoResources[item].contentType
		}
		
		videoCount +=1;
	}
	
	// validate
	var checkSize = function(element) {			
		if(videoSizes[element.width] != undefined) {
			if(videoSizes[element.width].height == element.height
				&& videoSizes[element.width].contentType == element.contentType) {
				return true;
			}
			return false;
		}
		return false;
	};
	
	if(videoCount != 0) {
		if(data != undefined) {
			if(checkSize(data)) {
				isMatch = true;
			}
		} else {
			
			var sizeCount = 0;
			for(var size in videoSizes) {
				sizeCount += 1;
			}
			
			//console.log(videoCount + "________" + sizeCount);
			
			if(videoCount == sizeCount) {
				isMatch = true;
			}
			
		}
		
	}

	return isMatch;
}

function setVideo(data, index) {
	
	videoResourceId = data[0].resourceId;
	thumbnailResourceId = data[0].thumbnailResourceId;

	if(isVideoSizesMatch(data[0])) {
		
		var modal4 = new lightFace({
			title : "Video Size is already Exists.",
			message : "The Video Size <b>" + data[0].width + "x" + data[0].height + "</b> is already Exists.<br/> Please remove.",
			actions : [
			    { 
			    	label : "Remove", 
			    	fire : function() { 
			    		
			    		// remove last video
			    		removeVideo(index);
			    	
			    		modal4.close();
			    		 
			    	}, 
					color: "green"
			    },
			    { 
			    	label : "Cancel", 
			    	fire : function() { 
			    		 modal4.close();
			    	}, 
					color: "white"
			    }
			],
			overlayAll : true
		});
		
	}
		
	videoResources[index] = data[0];
	
	
	$("#status_ad_video").hide();
	// enable add video
	$("#button_video_add_container").show();
}

function removeVideo(index) {
	
	removeResourceFiles({
		accountId : $.cookie("aid"),
		list : [videoResources[index].resourceFileId, videoResources[index].thumbnailResourceFileId],
		success: function() {
			
			// remove resource by resourceId
			$("#video_upload_" + index).remove();
			
			if($("#list_video_inline_upload div").length == 0) {
				videoResourceId = null;
				thumbnailResourceId = null;
				
				var uid = $.getTimestamp();
				$("<div id=\"video_upload_" + uid + "\">" +
					"<iframe src=\"inline_upload.html?resource_type_id=1&resource_id=" + getVideoResourceId() + "&thumbnail_resource_id=" + getThumbnailResourceId() + "&mode_id=1&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
				"</div>").appendTo("#list_video_inline_upload");
				
				$("#button_video_add_container").hide();
				
			}
			
			
			delete videoResources[index];
			
		},
		error: function(error) {
			alert("ERR -> " + error);
		}
	});
	
}


var imageResourceId = null;
var imageResources = {};

var imageSizes = {};
function isImageSizesMatch(data) {
	var isMatch = false;
	
	var imageCount = 0;
	imageSizes = {};
	
	// fill sizes from images
	for(var item in imageResources) {
		imageSizes[imageResources[item].width] = {
			height : imageResources[item].height
		}
		imageCount +=1;
	}
	
	// validate
	var checkSize = function(element) {			
		if(imageSizes[element.width] != undefined) {
			if(imageSizes[element.width].height == element.height) {
				return true;
			}
			return false;
		}
		return false;
	};
	
	if(imageCount != 0) {
		if(data != undefined) {
			if(checkSize(data)) {
				isMatch = true;
			}
		} else {
		
			var sizeCount = 0;
			for(var size in imageSizes) {
				sizeCount += 1;
			}
			
			if(imageCount == sizeCount) {
				isMatch = true;
			}
			
		}
		
	}

	return isMatch;
}

function setImage(data, index) {
	
	imageResourceId = data[0].resourceId;
	
	// check for size already exists
	if(isImageSizesMatch(data[0])) {
		
		var modal5 = new lightFace({
			title : "Image Size is already Exists.",
			message : "The Image Size <b>" + data[0].width + "x" + data[0].height + "</b> is already Exists.<br/> Please remove.",
			actions : [
			    { 
			    	label : "Remove", 
			    	fire : function() { 
			    	
			    		 // remove last image
			    		 removeImage(index);
			    	
			    		 modal5.close();
			    	}, 
					color: "green"
			    },
			    { 
			    	label : "Cancel", 
			    	fire : function() { 
			    		 modal5.close();
			    	}, 
					color: "white"
			    }
			],
			overlayAll : true
		});
		
	}
	
	imageResources[index] = data[0];
	
	
	
	$("#status_ad_image").hide();
	// enable add image
	$("#button_image_add_container").show();
	
}

function removeImage(index) {

	removeResourceFiles({
		accountId : $.cookie("aid"),
		list : [imageResources[index].resourceFileId],
		success: function() {
			
			// remove resource by resourceId
			$("#image_upload_" + index).remove();
			
			if($("#list_image_inline_upload div").length == 0) {
				imageResourceId = null;
				
				
				var uid = $.getTimestamp();
				$("<div id=\"image_upload_" + uid + "\">" +
					"<iframe src=\"inline_upload.html?resource_type_id=2&resource_id=" + getImageResourceId() + "&mode_id=1&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
				"</div>").appendTo("#list_image_inline_upload");
				
				$("#button_image_add_container").hide();
				
				
			}
			
			delete imageResources[index];
			
		},
		error: function(error) {
			alert("ERR -> " + error);
		}
	});
	
}


// Audio
var audioResourceId = null;
var audioResources = {};
function setAudio(data, index) {	
	audioResourceId = data[0].resourceId;
	audioResources[index] = data[0];
}
function removeAudio(index) {
	removeResourceFiles({
		accountId : $.cookie("aid"),
		list : [audioResources[index].resourceFileId],
		success: function() {
			
			// remove resource by resourceId
			$("#audio_upload_" + index).remove();
			
			if($("#list_audio_inline_upload div").length == 0) {
				
				var uid = $.getTimestamp();
				$("<div id=\"audio_upload_" + uid + "\">" +
					"<iframe src=\"inline_upload.html?resource_type_id=5&resource_id=" + getAudioResourceId() + "&mode_id=1&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
				"</div>").appendTo("#list_audio_inline_upload");
				
			}
			
			delete audioResources[index];
			
		},
		error: function(error) {
			alert("ERR -> " + error);
		}
	});
}




function showVideoError(error) {
	$("#error_ad_video").text(error).show();
}
function hideVideoError() {
	$("#error_ad_video").hide();
}
function showImageError(error) {
	$("#error_ad_image").text(error).show();
}
function hideImageError() {
	$("#error_ad_image").hide();
}
function showAudioError(error) {
	$("#error_ad_audio").text(error).show();
}
function hideAudioError() {
	$("#error_ad_audio").hide();
}




function getVideoResourceId() {
	return videoResourceId;
}
function getThumbnailResourceId() {
	return thumbnailResourceId;
}
function getImageResourceId() {
	return imageResourceId;
}
function getAudioResourceId() {
	return audioResourceId;
}
</script>

    
    
</asp:Content>



