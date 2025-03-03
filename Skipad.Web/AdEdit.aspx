<%@ Page Title="AdEdit" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="AdEdit.aspx.cs" Inherits="AdEdit" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
	<link rel="stylesheet" type="text/css" href="css/datatable/datatable.css" />
	<link rel="stylesheet" type="text/css" href="Styles/colorbox/colorbox.css" />
	<script type="text/javascript" src="Scripts/jquery.colorbox-min.js"></script>
	<script type="text/javascript" src="scripts/validator/validator-1.2.8.js"></script>
	<script type="text/javascript" src="scripts/datatable/datatable.js"></script>
</asp:Content>

<asp:Content ID="TitleContent" runat="server" ContentPlaceHolderID="TitleHolder">
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    	<tr>
    		<td valign="top">
    			<div class="breadcrumbs"><a href="campaigns.aspx" title="Campaigns">Campaigns</a>&nbsp;&rsaquo;&nbsp;<a href="#" title="Campaign" id="campaign_name"></a>&nbsp;&rsaquo;&nbsp;</div>
    			<h1><span style="color: #666666">Ad:</span> <span id="ad_name"></span></h1>
    		</td>
    		<td valign="top"></td>
    	</tr>
    </table>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    
<div class="content-middle-tabs-section">
	<div class="content-middle-tabs">
		<ul class="content-middle-tabs-container">
			<li><a href="adedit.aspx?ad_id=<%=AdId%>" title="Edit" class="selected"><span>Edit</span></a></li>
			<li><a href="ad.aspx?ad_id=<%=AdId%>" title="Details"><span>Details</span></a></li>
	    	<li><a href="adstatistics.aspx?ad_id=<%=AdId%>" title="Referrals"><span>Referrals</span></a></li>
	    </ul>
    </div>
</div>

    <div style="clear: both; padding-top: 20px;">
    
		<div class="params">
			<div class="param-name"><span>Campaign Name:</span></div>
			<div class="param-value">
				<b id="label_campaign_name"></b>
			</div>
		</div>
		<div class="params">
			<div class="param-name"><span>Ad Id:</span></div>
			<div class="param-value">
				<b id="label_ad_id"></b>
			</div>
		</div>
		<div class="params">
			<div class="param-name"><span>* Ad Name:</span></div>
			<div class="param-value">
				<div><input type="text" style="width: 225px;" autocomplete="off" maxlength="254" name="ad_name" id="text_ad_name" /></div>
				<div><label id="status_ad_name"></label></div>
			</div>
		</div>
		<div class="params">
			<div class="param-name"><span>Ad Type:</span></div>
			<div class="param-value">
				<b id="label_ad_type"></b>
			</div>
		</div>
		<div class="params">
			<div class="param-name"><span>AUID:</span></div>
			<div class="param-value">
				<b id="label_auid"></b>
			</div>
		</div>
		
		
		<div class="params" style="height: 72px; display: none;">
			<div class="param-name"><span>VAST Tag Url:</span></div>
			<div class="param-value">
				<textarea class="code-snippet" id="input_tag_url" readonly="readonly" autocomplete="off" style="width: 314px; height: 64px;"></textarea>
			</div>
		</div>
		
		
		
		<div class="params" style="overflow: hidden; display: none;">
			<div class="param-name"><span>Image:</span></div>
			<div class="param-value">
				<div id="image"></div>
			</div>
		</div>
		<div class="params" style="height: 72px; display: none;">
			<div class="param-name"><span>Image Url:</span></div>
			<div class="param-value">
				<textarea class="code-snippet" id="input_image_url" readonly="readonly" autocomplete="off" style="width: 314px; height: 64px;"></textarea>
			</div>
		</div>
		<div class="params" style="display: none;">
			<div class="param-name"><span>Video:</span></div>
			<div class="param-value">
				<a href="" id="video"></a>
			</div>
		</div>
		<div class="params" style="height: 72px; display: none;">
			<div class="param-name"><span>Video Url:</span></div>
			<div class="param-value">
				<textarea class="code-snippet" id="input_video_url" readonly="readonly" autocomplete="off" style="width: 314px; height: 64px;"></textarea>
			</div>
		</div>
		<div class="params" style="display: none;">
			<div class="param-name"><span>Video Skip Ad:</span></div>
			<div class="param-value">
				<a href="" id="video_skip_ad"></a>
			</div>
		</div>
		
		
		
		
		<div class="params" style="min-height: 362px; overflow: hidden; display: none;">
			<div class="param-name"><span>Skip-Ad:<br/>(Play to Preview your Skip-Ad):</span></div>
			<div class="param-value" style="max-width: 100%">
				<div id="thumb_image_container" style="position: relative">
					<!-- <img src="http://skipr1.skipad.com/d391be5a-3ee1-433c-b2fa-ec25e4b9ae20/v_640x360x400.mp4_thumb.jpg" style="display: block;"> -->
					<div id="thumb_image"></div>
					<div id="thumb_image_preview"></div>
					<div id="thumb_image_play"></div>
				</div>
			</div>
			<div class="param-value">
				<div style="margin-left: 6px;">
					<a class="button-white" id="link_share" title="Share"><span><i class="icon-share">&nbsp;</i>Share</span></a>
				</div>
			</div>
		</div>
		
		
		<div class="params" style="height: 72px; display: none;">
			<div class="param-name"><span>Video Thumb Url:</span></div>
			<div class="param-value">
				<textarea class="code-snippet" id="input_video_thumb_url" readonly="readonly" autocomplete="off" style="width: 314px; height: 64px;"></textarea>
			</div>
		</div>
		
		
		<div class="form_linear">
			<div class="params" style="overflow: hidden;">
				<div class="param-name"><span>* Video:</span></div>
				<div class="param-value" style="max-width: 100%;">
					<div style="color: #666; padding-bottom: 10px;">For <b>Full</b> Flash &amp; HTML5 support it's recommended to upload <b>*.mp4</b>, <b>*.webm</b> &amp; <b>*.ogv</b> Video file format</div>
					<div id="list_video_inline_upload"></div>
					<div id="button_video_add_container">
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
		
		<div>
			<div class="params" style="overflow: hidden;">
				<div class="param-name"><span>* Image:</span></div>
				<div class="param-value" style="max-width: 100%;">
					<div id="list_image_inline_upload"></div>
					<div id="button_image_add_container">
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
		
		<!-- form_linear  -->
		<div class="form_audio">
			<div class="params" style="overflow: hidden;">
				<div class="param-name"><span>Fitted image sound byte: (optional)</span></div>
				<div class="param-value" style="max-width: 100%;">
				   	<div style="color: #666; padding-bottom: 10px;">The sound byte will be played when user Fit the image correctly
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
		
		<div>
			<div class="params" style="overflow: auto">
				<div class="param-name">Custom Events: (optional)</div>
				<div class="param-value">
					
					<div>
						<table class="ti">
							<thead>
								<th>Event Type</th>
								<th>Event URL</th>
								<th>Actions</th>
							</thead>
							<tbody id="table_body_custom_events"></tbody>
						</table>
					</div>
					
					<!--
					<div style="padding-top: 12px;">
						<a href="#" class="button-green" id="button_save_events" title="Save Events">Save Events</a>
					</div>
					-->

				</div>
			</div>
		</div>
		
		<div class="params" style="display: none;">
			<div class="param-name"><span>Modify Date:</span></div>
			<div class="param-value">
				<div><b id="label_modify_date"></b></div>
			</div>
		</div>
		<div class="params" style="display: none;">
			<div class="param-name"></div>
			<div class="param-value">
				<label><input type="checkbox" autocomplete="off" id="checkbox_change_auid" /> Change AUID</label>
			</div>
		</div>
		
		<div style="height: 24px; overflow: hidden;"></div>
		<div class="params">
			<div class="param-name">&nbsp;</div>
			<div class="param-value">
				<a href="javascript:;" title="Update" class="button-green" id="button_update"><span>Update</span></a>
			</div>
			<div class="param-value" style="margin-left: 6px; line-height: 20px;">
				<a href="ad.aspx?ad_id=<%=AdId%>" title="Cancel">Cancel</a>
			</div>
		</div>
		
		
		
	
    </div>
    
    
<script type="text/javascript">
var servletUrl = "handlers/ads.ashx";

var getAd = function(params) {
	
	var obj = {
		getAd : {
			accountId : params.accountId,
			adId : params.adId
		}
	};

	$.ajax({
        url: servletUrl,
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

var updateAd = function(params) {
	
	var obj = {
		updateAd : {
			accountId : params.accountId,
			adId : params.adId,
			adName : params.adName,
			adTypeId : params.adTypeId,
			changeAuid : params.changeAuid,
			videoClickUrl : params.videoClickUrl,
			imageClickUrl : params.imageClickUrl,
			externalTagUrl : params.externalTagUrl,
			surveyUrl : params.surveyUrl,
			customEvents : params.customEvents
		}
	};

	$.ajax({
        url: servletUrl,
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

var loadImage = function(imageUrl, el, width, height) {
	$(el)
		.empty();
	
	var img = new Image();
	
	if(width != undefined) {
		img.width = width;
	}

	// wrap our new image in jQuery, then:
	$(img).load(function () {
      // set the image hidden by default    
      $(this).hide();
    
    	
      	$(el)
        	.append(this);
    	
    	
      	// fade our image in to create a nice effect
      	$(this).fadeIn();

    })
    .error(function () {
    	// error
    })
    .attr("src", imageUrl);
};

var customEventTypes = [
	{ eventTypeId : 1, name : "impression" },
	{ eventTypeId : 2, name : "first quartile" },
	{ eventTypeId : 3, name : "mid point" },
	{ eventTypeId : 4, name : "third quartile" },
	{ eventTypeId : 5, name : "complete" }
];

function getEventNameByEventTypeId(eventTypeId) {
	var eventName = "";
	for(var i = 0; i < customEventTypes.length; i++) {
		if(customEventTypes[i].eventTypeId == eventTypeId) {
			eventName = customEventTypes[i].name;
			break;
		}
	}
	return eventName;
};

var customEvents = [];


$(function () {
	
	getAd({
		accountId : $.cookie("aid"),
		adId : <%=AdId%>,
		success : function(data) {
		
			$("#ad_name").text(data.adName);
			
			$("#campaign_name")
				.text(data.campaignName)
				.attr({ "href" : "campaign.aspx?campaign_id=" + data.campaignId, "title" : data.campaignName });
				
			// form
			$("#label_ad_id").text(data.adId);
			$("#label_ad_type").text((data.adTypeId == 1 ? "Linear" : "Wrapper"));
			$("#text_ad_name").val(data.adName);
			$("#label_campaign_name").text(data.campaignName);
			
			$("#label_auid").text(data.auid);
			$("#text_survey_url").val(data.surveyUrl);
			
			
			
			
			
			// https://ad.doubleclick.net/clk;281731592;108320422;v;pc=[TPAS_ID] 
			customEvents = data.customEvents != undefined ? data.customEvents : [];
			
			
			function addEvent(data, beforeLast) {
				
				// edit
				var editRow = $("<tr class=\"cEDO\">" +
					"<td><select class=\"select-event-types\"></select></td>" +
					"<td><input type=\"text\" class=\"text-event-value\" /></td>" +
					"<td><a href=\"#\" class=\"button-delete-event\" title=\"Delete\">Delete</a></td>" +
				"</tr>");
				
				if(beforeLast != undefined && beforeLast == true) {
					$("#table_body_custom_events tr:last").before(editRow);
				} else {
					editRow.appendTo("#table_body_custom_events");
				}
				
				
				var editRowEventTypes = editRow.find(".select-event-types");
				var _editRowEventTypes = editRowEventTypes[0].options;
				for(var z = 0; z < customEventTypes.length; z++) {
					var l = new Option(customEventTypes[z].name, customEventTypes[z].eventTypeId);
					try {
						_editRowEventTypes.add(l);
					} catch (ex) {
						_editRowEventTypes.add(l, null);
					}
				}
				
				// set values
				editRow.find(".select-event-types option[value=" + data.eventTypeId + "]").attr("selected", "selected");
				editRow.find(".text-event-value").val(data.url);
				
				// actions
				editRow.find(".button-delete-event").click(function(event) {
					event.preventDefault();
					
					// remove
					$(this).closest("tr").remove();
					
				});
				
			};
			
			
			
			// events	
			for(var i = 0; i < customEvents.length; i++) {
				addEvent(customEvents[i]);
			}
			
				
			// new
			var newRow = $("<tr style=\"background: #eee\">" +
				"<td><select class=\"select-event-types\"></select></td>" +
				"<td><input type=\"text\" class=\"text-event-value\" placeholder=\"Enter Event URL\" /></td>" +
				"<td><a href=\"#\" class=\"button-add-event\" title=\"Add\">Add</a></td>" +
			"</tr>").appendTo("#table_body_custom_events");
				
			var newRowEventTypes = newRow.find(".select-event-types");
			var _newRowEventTypes = newRowEventTypes[0].options;
			for(var z = 0; z < customEventTypes.length; z++) {
				var l = new Option(customEventTypes[z].name, customEventTypes[z].eventTypeId);
				try {
					_newRowEventTypes.add(l);
				} catch (ex) {
					_newRowEventTypes.add(l, null);
				}
			}
				
			newRow.find(".button-add-event").click(function(event) {
				
				event.preventDefault();
				
				addEvent({
					eventTypeId : $(this).closest("tr").find(".select-event-types").val(),
					url : $(this).closest("tr").find(".text-event-value").val()
				}, true);
				
				//console.log($(this).closest("tr").find(".select-event-types").val());
				$(this).closest("tr").find(".text-event-value").val("");
				
				
			});
			
			
			
			/*
			// save events
			$("#button_save_events").click(function(event) {
				event.preventDefault();
				
				$("#table_body_custom_events tr.cEDO").each(function(i, el) {
					
					console.log($(el).find(".select-event-types").val());
					console.log($(el).find(".text-event-value").val());
					
				});
				
			});
			*/
			
			/*
			var validator3 = new validator({
				elements : [
					{
						element : $('#text_custom_event_value'),
						status : $('#status_custom_event_value'),
						rules : [
							{ method : 'required', message : 'This field is required.' }
						]
					}
				],
				accept : function () {
					
					console.log("OK ->>");
					
					$("#form_custom_event").hide();
					$('#text_custom_event_value').val("").removeClass("predefined");
					
					
					//$('#text_custom_event_value').val("").removeClass("predefined");
					
				}
			});
			*/
			
					
			
			
			
			
			/*
			$('#input_tag_url')
			.val(data.tagUrl)
			.focus(function(){
			    $(this).select();
			})
			.mouseup(function(e){
			    e.preventDefault();
			});
			
			
			
			
			loadImage(data.imageUrl, "#image");
		    
			
			
			$('#input_image_url')
			.val(data.imageUrl)
			.focus(function(){
			    $(this).select();
			})
			.mouseup(function(e){
			    e.preventDefault();
			});
			*/
			
			
			// check adTypeId
			if(data.adTypeId == 1) {
				// linear
				$(".form_linear").show();
				$(".form_wrapper").hide();
				
				
				// videos
				$("#list_video_inline_upload").empty();
				if(data.resources[1].files.length != 0) {
					for(var x = 0; x < data.resources[1].files.length; x++) {
				
						if(x == 0) {
							videoResourceId = data.resources[1].resourceId;
							//thumbnailResourceId = data.resources[0].resourceId;
						}
				
						var uid = $.getTimestamp();
						$("<div id=\"video_upload_" + uid + "\">" +
							"<iframe src=\"inline_upload.html?resource_type_id=1&resource_id=" + getVideoResourceId() + "&thumbnail_resource_id=" + getThumbnailResourceId() + "&mode_id=2&name=" + data.resources[1].files[x].name + "&thumbnail_url=" + data.resources[1].files[x].thumbnailUrl + "&width=" + data.resources[1].files[x].width + "&height=" + data.resources[1].files[x].height + "&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
						"</div>").appendTo("#list_video_inline_upload");
					
						videoResources[uid] = data.resources[1].files[x];
					
					}
				} else {
					
					
					//console.log("VIDEO -> RSID" + data.resources[1].resourceId);
				
					videoResourceId = data.resources[1].resourceId;
				
					var uid = $.getTimestamp();
					$("<div id=\"video_upload_" + uid + "\">" +
						"<iframe src=\"inline_upload.html?resource_type_id=1&resource_id=" + getVideoResourceId() + "&thumbnail_resource_id=" + getThumbnailResourceId() + "&mode_id=1&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
					"</div>").appendTo("#list_video_inline_upload");
				
					$("#button_video_add_container").hide();
				
				}
			
				$("#button_video_add").click(function(e) {
					var uid = $.getTimestamp();
					$("<div id=\"video_upload_" + uid + "\">" +
						"<iframe src=\"inline_upload.html?resource_type_id=1&resource_id=" + getVideoResourceId() + "&thumbnail_resource_id=" + getThumbnailResourceId() + "&mode_id=1&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
					"</div>").appendTo("#list_video_inline_upload");
				
					$("#button_video_add_container").hide();
				
					e.preventDefault();
				});
			
				// video click url
				$("#text_video_click_url")
					.val(data.resources[1].clickUrl)
					.trigger("keyup");
				
				
			} else {
				
				// wrapper
				$(".form_linear").hide();
				$(".form_wrapper").show();
				
				// set external wrapper url
				if(data.externalTagUrl != undefined) {
					$("#text_vast_wrapper_url").val(data.externalTagUrl);
				}
				
			}
			
			/*
			$("#video")
				.text(data.videoUrl)
				.attr({ "href" : data.videoUrl, "title" : data.videoUrl })
				.click(function(event) {
				
					openResource($(this).attr("href"));
					
					event.preventDefault();	
					
				});
				
			// skip ad preview
			$("#video_skip_ad")
				.text("<%=SkipRollPreviewUrl%>?tagurl=" + encodeURIComponent(data.tagUrl))
				.attr({ "href" : "<%=SkipRollPreviewUrl%>?tagurl=" + encodeURIComponent(data.tagUrl) + "&width=640&height=360", "title" : "<%=SkipRollPreviewUrl%>?tagurl=" + encodeURIComponent(data.tagUrl) })
				.click(function(event) {
				
					openResource($(this).attr("href"));
					
					event.preventDefault();	
					
				});
			
			$('#input_video_url')
			.val(data.videoUrl)
			.focus(function(){
			    $(this).select();
			})
			.mouseup(function(e){
			    e.preventDefault();
			});
			
			loadImage(data.videoThumbUrl, "#thumb_image_preview", 160);
			
			$("#thumb_image_play")
			.attr({ "href" : "<%=SkipRollPreviewUrl%>?tagurl=" + encodeURIComponent(data.tagUrl) + "&width=640&height=360", "title" : "<%=SkipRollPreviewUrl%>?tagurl=" + encodeURIComponent(data.tagUrl) })
			.click(function(event) {
				openResource($(this).attr("href"));
				event.preventDefault();
			});
			
			
			loadImage(data.imageUrl, "#thumb_image", 640);
			
			
			// share
			$("#link_share").attr({ "href" : "mailto: ?subject=" + data.adName + "&body=<%=SkipRollPreviewUrl%>?tagurl=" + encodeURIComponent(data.tagUrl) + "&width=640&height=360" });
			
			
				
			$("#thumb_image_preview").show();
			
			
			
			
			
			$('#input_video_thumb_url')
			.val(data.videoThumbUrl)
			.focus(function(){
			    $(this).select();
			})
			.mouseup(function(e){
			    e.preventDefault();
			});
			*/
			
			
			
			

			
			
			
			
			// images
			$("#list_image_inline_upload").empty();
			if(data.resources[2].files.length != 0) {
				for(var y = 0; y < data.resources[2].files.length; y++) {
				
					if(y == 0) {
						imageResourceId = data.resources[2].resourceId;
					}
				
					var uid = $.getTimestamp();
					$("<div id=\"image_upload_" + uid + "\">" +
						"<iframe src=\"inline_upload.html?resource_type_id=2&resource_id=" + getImageResourceId() + "&mode_id=2&name=" + data.resources[2].files[y].name + "&url=" + data.resources[2].files[y].url + "&width=" + data.resources[2].files[y].width + "&height=" + data.resources[2].files[y].height + "&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
					"</div>").appendTo("#list_image_inline_upload");
					
					imageResources[uid] = data.resources[2].files[y];
					
				}
			} else {
			
				imageResourceId = data.resources[2].resourceId;
				
				var uid = $.getTimestamp();
				$("<div id=\"image_upload_" + uid + "\">" +
					"<iframe src=\"inline_upload.html?resource_type_id=2&resource_id=" + getImageResourceId() + "&mode_id=1&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
				"</div>").appendTo("#list_image_inline_upload");
				
				$("#button_image_add_container").hide();
				
			}
			
			$("#button_image_add").click(function(e) {
				var uid = $.getTimestamp();
				$("<div id=\"image_upload_" + uid + "\">" +
					"<iframe src=\"inline_upload.html?resource_type_id=2&resource_id=" + getImageResourceId() + "&mode_id=1&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
				"</div>").appendTo("#list_image_inline_upload");
				
				$("#button_image_add_container").hide();
				
				e.preventDefault();
			});
			
			// image click url
			$("#text_image_click_url")
				.val(data.resources[2].clickUrl)
				.trigger("keyup");
			
			
			
			
			
			// audio
			$("#list_audio_inline_upload").empty();
			if(data.resources[5] != undefined) {
				if(data.resources[5].files.length != 0) {
					for(var y = 0; y < data.resources[5].files.length; y++) {
			
						if(y == 0) {
							audioResourceId = data.resources[5].resourceId;
						}
			
						var uid = $.getTimestamp();
						$("<div id=\"audio_upload_" + uid + "\">" +
							"<iframe src=\"inline_upload.html?resource_type_id=5&resource_id=" + getAudioResourceId() + "&mode_id=2&name=" + data.resources[5].files[y].name + "&url=" + data.resources[5].files[y].url + "&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
						"</div>").appendTo("#list_audio_inline_upload");
				
						audioResources[uid] = data.resources[5].files[y];
				
					}
				} else {
					// hide audio
					$('.form_audio').hide();
				}
				/*
				 else {
			
					audioResourceId = data.resources[5].resourceId;
			
					var uid = $.getTimestamp();
					$("<div id=\"audio_upload_" + uid + "\">" +
						"<iframe src=\"inline_upload.html?resource_type_id=5&resource_id=" + getAudioResourceId() + "&mode_id=1&index=" + uid + "\" style=\"border: none; width:600px; height:50px;\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
					"</div>").appendTo("#list_audio_inline_upload");
			
				}
				*/
			} else {
				// hide audio
				$('.form_audio').hide();
			}
			
			
			// survey url
			if(data.surveyUrl != undefined) {
				$("text_survey_url").val(data.surveyUrl);
			}
			
			$("#label_modify_date").text(data.modifyDate);
			$("#checkbox_change_auid").prop("checked", false);
			
			
			
			
			
			var v = new validator({
				elements : [
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
							return data.adTypeId == 1 ? true : false
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
							return data.adTypeId == 1 ? false : true
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
				submitElement : $('#button_update'),
				messages : null,
				accept : function () {
		
					$("#error_ad_video").hide();
					$("#error_ad_image").hide();
					
					
					
					var customEvents = [];
					$("#table_body_custom_events tr.cEDO").each(function(i, el) {
					
						customEvents.push({
							eventTypeId : $(el).find(".select-event-types").val(),
							url : $(el).find(".text-event-value").val()
						});
					
					});
					
			
					if(data.adTypeId == 1) {
						
						if(videoResourceId != null 
						&& imageResourceId != null) {
				
							updateAd({
								accountId : $.cookie("aid"),
								adId : <%=AdId%>,
								adName : $('#text_ad_name').val(),
								adTypeId : 1,
								changeAuid : $("#checkbox_change_auid").prop("checked"),
								videoClickUrl: $('#text_video_click_url').val(),
								imageClickUrl: $('#text_image_click_url').val(),
								surveyUrl : $('#text_survey_url').val(),
								customEvents : customEvents,
								success : function() {
					
									location.href = "/ad.aspx?ad_id=<%=AdId%>"; 
						
								},
								error: function() {
									alert("ERR");
								}
							});
			
						}
						
					} else {
						
						if(imageResourceId != null) {
							
							updateAd({
								accountId : $.cookie("aid"),
								adId : <%=AdId%>,
								adName : $('#text_ad_name').val(),
								adTypeId : 2,
								changeAuid : $("#checkbox_change_auid").prop("checked"),
								imageClickUrl: $('#text_image_click_url').val(),
								externalTagUrl : $("#text_vast_wrapper_url").val(),
								surveyUrl : $('#text_survey_url').val(),
								customEvents : customEvents,
								success : function() {
					
									location.href = "/ad.aspx?ad_id=<%=AdId%>"; 
						
								},
								error: function() {
									alert("ERR");
								}
							});
							
						}
						
					}
			
				},
				error: function() {
					$("#error_ad_video").hide();
					$("#error_ad_image").hide();
				}
			});
	
	
			$("#button_update")
			.on("click", function() {
		
				if(data.adTypeId == 1) {
					
					if(videoResourceId == null) {
						$("#status_ad_video").show();
					} else {
						$("#status_ad_video").hide();
					}
					
				}
		
				if(imageResourceId == null) {
					$("#status_ad_image").show();
				} else {
					$("#status_ad_image").hide();
				}
		
			});
	
			// default button
			$(document).bind('keydown', function(e) {
				var code;
		        if (!e) var e = window.event;
		        if (e.keyCode) code = e.keyCode;
		        else if (e.which) code = e.which;

		     	// enter
		        if(code == 13) {
		        	if(!$('#button_update').is(':focus')) {
						v.validate();
					}
		        }
			});
			
			
			
			
		},
		error: function(error) {
			//
		}
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
	
	
	
});

function openPreview(s) {
	$.colorbox({ iframe: true, href: "Preview/PreviewAd.aspx?auid=" + s, width: "770px", height: "500px", scrolling: false });
}

function openResource(s) {
	$.colorbox({ iframe: true, href: s, width: "682px", height: "430px", scrolling: false });
}
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
		if(checkSize(data)) {
			isMatch = true;
		}
	}

	return isMatch;
}

function setVideo(data, index) {
	
	//console.log("SET VIDEO -> " + JSON.stringify(data[0]));
	
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
				
				//videoResourceId = null;
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
		if(checkSize(data)) {
			isMatch = true;
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
				
				//imageResourceId = null;
				
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
