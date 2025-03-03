<%@ Page Title="Ad" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Ad.aspx.cs" Inherits="Ad" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
	<link rel="stylesheet" type="text/css" href="Styles/colorbox/colorbox.css" />
	<script type="text/javascript" src="Scripts/jquery.colorbox-min.js"></script>
	<script type="text/javascript" src="scripts/validator/validator-1.2.8.js"></script>	
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
			<li><a href="adedit.aspx?ad_id=<%=AdId%>" title="Edit"><span>Edit</span></a></li>
			<li><a href="ad.aspx?ad_id=<%=AdId%>" title="Details" class="selected"><span>Details</span></a></li>
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
			<div class="param-name"><span>Ad Type:</span></div>
			<div class="param-value">
				<b id="label_ad_type"></b>
			</div>
		</div>
        <div class="params">
			<div class="param-name"><span>Skip Type:</span></div>
			<div class="param-value">
				<b id="label_skip_type"></b>
			</div>
		</div>
		<div class="params">
			<div class="param-name"><span>Ad Name:</span></div>
			<div class="param-value">
				<b id="label_ad_name"></b>
			</div>
		</div>
		
		<div class="params">
			<div class="param-name"><span>AUID:</span></div>
			<div class="param-value">
				<b id="label_auid"></b>
			</div>
		</div>
		
		<div class="params">
			<div class="param-name"><span>Modify Date:</span></div>
			<div class="param-value">
				<b id="label_modify_date"></b>
			</div>
		</div>
		
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td valign="top">
					<div class="params" style="min-height: 180px; overflow: hidden;">
						<div class="param-name"><span>Skip-Ad:<br/>(Play to Preview your Skip-Ad):</span></div>
						<div class="param-value" style="max-width: 100%">
							<div style="color: #333; font-weight: bold; padding-bottom: 5px;">VAST</div>
							<div id="thumb_image_container" style="position: relative">
								<div id="thumb_image"></div>
								<div id="thumb_image_preview"></div>
								<div id="thumb_image_play"></div>
							</div>
						</div>
					</div>
					<div class="params">
						<div class="param-name"></div>
						<div class="param-value" style="width: 320px;max-width: 100%">
							<div style="text-align: right;">
								<a id="link_share" title="Send link to preview Skip Ad">Send link to preview Skip Ad</a>
							</div>
						</div>
					</div>
					
					<div class="params">
						<div class="param-name"></div>
						<div class="param-value">
							<b>Select your relevant TAG</b>
						</div>
					</div>
					
					<div class="params" style="height: 90px; display: none" id="container_flash_vpaid_tag_url">
						<div class="param-name"><span></span></div>
						<div class="param-value">
							<div style="clear: both; padding-bottom: 6px;padding-top: 12px;"><b>FLASH VPAID Tag:</b></div>
							<textarea class="code-snippet" id="input_flash_vpaid_tag_url" readonly="readonly" autocomplete="off" style="width: 314px; height: 64px;"></textarea>
						</div>
					</div>
					<div class="params" style="height: 90px; display: none" id="container_html5_vpaid_tag_url">
						<div class="param-name"><span></span></div>
						<div class="param-value">
							<div style="clear: both; padding-bottom: 6px; padding-top: 12px;"><b>HTML5 VPAID Tag:</b></div>
							<textarea class="code-snippet" id="input_vpaid_tag_url" readonly="readonly" autocomplete="off" style="width: 314px; height: 64px;"></textarea>
						</div>
					</div>
					
					<div class="params" style="height: 90px; display: none" id="container_flash_vpaid_1_tag_url">
						<div class="param-name"><span></span></div>
						<div class="param-value">
							<div style="clear: both; padding-bottom: 6px; padding-top: 12px;"><b>FLASH VPAID 1.0 Tag:</b></div>
							<textarea class="code-snippet" id="input_flash_vpaid_1_tag_url" readonly="readonly" autocomplete="off" style="width: 314px; height: 64px;"></textarea>
						</div>
					</div>
					
					<div class="params" style="height: 90px;">
						<div class="param-name"><span></span></div>
						<div class="param-value">
							<div style="clear: both; padding-bottom: 6px; padding-top: 12px"><b>VAST Tag Url:</b></div>
							<textarea class="code-snippet" id="input_tag_url" readonly="readonly" autocomplete="off" style="width: 314px; height: 64px; background-color: #f8f8f8"></textarea>
						</div>
					</div>
				
				</td>
				<td valign="top">
					<div style="margin-left: 10px; display: none" id="form_html5">
						<div style="color: #333; font-weight: bold; padding-bottom: 5px;">MRAID</div>
						<div class="params" style="min-height: 180px; overflow: hidden;">
							<div class="param-value" style="max-width: 100%">
								<div id="thumb_mraid_image_container" style="position: relative">
									<div id="thumb_mraid_image"></div>
									<div id="thumb_mraid_image_preview"></div>
									<div id="thumb_mraid_image_play"></div>
								</div>
							</div>
						</div>
						<div class="params">
							<div class="param-value" style="width: 320px;max-width: 100%">
								<div style="text-align: right;">
									<a id="link_mraid_share" title="Send link to preview Skip Ad">Send link to preview Skip Ad</a>
								</div>
							</div>
						</div>
						
						<div class="params">
							<div class="param-value">
								<b>&nbsp;</b>
							</div>
						</div>
						
						<div class="params" style="height: 90px;">
							<div class="param-value">
								<div style="clear: both; padding-bottom: 6px; padding-top: 12px;"><b>MRAID Tag:</b></div>
								<textarea class="code-snippet" id="input_mraid_tag_url" readonly="readonly" autocomplete="off" style="width: 314px; height: 64px;"></textarea>
							</div>
						</div>
						
					</div>
				</td>
			</tr>
		</table>
		
		
		
		<div style="height: 24px; overflow: hidden;"></div>
		<div class="params">
			<div class="param-name">&nbsp;</div>
			<div class="param-value">
				<a href="adedit.aspx?ad_id=<%=AdId%>" title="Edit" class="button-green"><span>Edit</span></a>
			</div>
			<div class="param-value" style="margin-left: 6px; line-height: 20px;">
				<a href="" title="Go to Campaign" id="link_back_to_campaign"><span>Go to Campaign</span></a>
			</div>
		</div>
		
		
		
	
    </div>
    
    
<script type="text/javascript">

var getAccountDetails = function(params) {
	
	var obj = {
		get: {
			accountId : params.accountId
		}
	};

	$.ajax({
        url: "handlers/accounts.ashx",
        data: { 
        	rq : JSON.stringify(obj),
        	timestamp : $.getTimestamp()
        },
        dataType: "json",
        success: function (data, status) {
        
        	if(data != undefined) {
	        	if(data.error != undefined) {
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



var getAdDetails = function() {
	
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
			
			if(data.adTypeId == 1) {
				$("#form_html5").show();
			}
			
			$("#label_ad_name").text(data.adName);
			$("#label_campaign_name").text(data.campaignName);
			
			
			$("#link_back_to_campaign").attr({ "href" : "campaign.aspx?campaign_id=" + data.campaignId });
			
			// auid
			$("#label_auid").text(data.auid);
		    
			$("#label_skip_type").text((data.skipTypeId == 1 ? "Push" : "Slide"));
			
			
			
			
			
			// VAST
			loadImage(data.videoThumbUrl, "#thumb_image_preview", 80); // 180
			$("#thumb_image_play")
			.attr({ "href" : "<%=SkipRollPreviewUrl%>?srqatnocache=true&pid=" + account.externalId + "&tagurl=" + encodeURIComponent(data.tagUrl) + "&width=640&height=360", "title" : "<%=SkipRollPreviewUrl%>?srqatnocache=true&pid=" + account.externalId + "&tagurl=" + encodeURIComponent(data.tagUrl) })
			.click(function(event) {
				openResource($(this).attr("href"));
				event.preventDefault();
			});
			
			loadImage(data.imageUrl, "#thumb_image", 320);
			
			$("#thumb_image_preview").show();
			
			// share
			$("#link_share").attr({ "href" : "mailto: ?subject=" + data.adName + "&body=<%=SkipRollPreviewUrl%>" + encodeURIComponent("?srqatnocache=true&pid=" + account.externalId + "&tagurl=" + encodeURIComponent(data.tagUrl) + "&width=640&height=360") });
			
			// VAST TAG
			$('#input_tag_url')
			.val(data.tagUrl)
			.focus(function(){
			    $(this).select();
			})
			.mouseup(function(e){
			    e.preventDefault();
			});
			
			
			
			// =============================
			
			
			
			// MRAID
			loadImage(data.videoThumbUrl, "#thumb_mraid_image_preview", 80);
			$("#thumb_mraid_image_play")
			.attr({ "href" : "<%=SkipRollMraidPreviewUrl%>?tagurl=" + encodeURIComponent(data.mraidTagUrl) + "&demo=1", title : "<%=SkipRollMraidPreviewUrl%>?tagurl=" + encodeURIComponent(data.mraidTagUrl) + "&demo=1" })
			.click(function(event) {
				openResource($(this).attr("href"));
				event.preventDefault();
			});
			
			
			loadImage(data.imageUrl, "#thumb_mraid_image", 320);
			
			$("#thumb_mraid_image_preview").show();
			
			
			// share
			$("#link_mraid_share").attr({ "href" : "mailto: ?subject=" + data.adName + "&body=<%=SkipRollMraidPreviewUrl%>" + encodeURIComponent("?tagurl=" + encodeURIComponent(data.mraidTagUrl) + "&demo=1") });
			
			
			// MRAID TAG
			$('#input_mraid_tag_url')
			.val(data.mraidTagUrl)
			.focus(function(){
			    $(this).select();
			})
			.mouseup(function(e){
			    e.preventDefault();
			});
			
			
			
			
			// FLASH VPAID TAG
			if(data.vpaidFlashTagUrl != undefined) {
				
				$("#container_flash_vpaid_tag_url").show();
				
				$('#input_flash_vpaid_tag_url')
				.val(data.vpaidFlashTagUrl)
				.focus(function(){
				    $(this).select();
				})
				.mouseup(function(e){
				    e.preventDefault();
				});
				
			}
			
			// FLASH VPAID 1.0 TAG
			if(data.vpaidFlashV1TagUrl != undefined) {
				
				$("#container_flash_vpaid_1_tag_url").show();
				
				$('#input_flash_vpaid_1_tag_url')
				.val(data.vpaidFlashV1TagUrl)
				.focus(function(){
				    $(this).select();
				})
				.mouseup(function(e){
				    e.preventDefault();
				});
				
			}
			
			
			// HTML5 VPAID TAG
			if(data.vpaidHtml5TagUrl != undefined) {
				
				$("#container_html5_vpaid_tag_url").show();
			
				// HTML5 VPAID TAG
				$('#input_vpaid_tag_url')
				.val(data.vpaidHtml5TagUrl)
				.focus(function(){
				    $(this).select();
				})
				.mouseup(function(e){
				    e.preventDefault();
				});	
				
			}
			
			
			
			// modify date
			$("#label_modify_date").text(data.modifyDate);
			// $("#checkbox_change_auid").prop("checked", false);
			
			
		},
		error: function(error) {
			//
		}
	});
	
};

var account = {
	externalId : null
};

$(function () {
	
	getAccountDetails({
		accountId : $.cookie("aid"), // TODO: accountId
		success : function(_data) {
			
			account.externalId = _data.externalId;
			
			getAdDetails();
			
		},
		error: function(error) {
					
		}
	});
	
});

function openPreview(s) {
	$.colorbox({ iframe: true, href: "Preview/PreviewAd.aspx?auid=" + s, width: "770px", height: "500px", scrolling: false });
}

function openResource(s) {
	$.colorbox({ iframe: true, href: s, width: "682px", height: "430px", scrolling: false });
}
</script>



</asp:Content>
