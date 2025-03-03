<%@ Page Title="Campaign Settings" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="CampaignSettings.aspx.cs" Inherits="CampaignSettings" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

	<link rel="stylesheet" type="text/css" href="css/datatable/datatable.css" />
	<link rel="stylesheet" type="text/css" href="css/datepicker/datepicker.css" />
	<link rel="stylesheet" type="text/css" href="css/tipsy/tipsy.css" />
	
	<link rel="stylesheet" type="text/css" href="Styles/colorbox/colorbox.css" />

	<script type="text/javascript" src="Scripts/jquery.colorbox-min.js"></script>
	
	<script type="text/javascript" src="scripts/datatable/datatable.js"></script>
	<script type="text/javascript" src="scripts/tipsy/tipsy.min.js" charset="utf-8"></script>
	<script type="text/javascript" src="scripts/validator/validator-1.2.8.js"></script>
	<script type="text/javascript" src="scripts/utils/date.min.js" charset="utf-8"></script>
	<script type="text/javascript" src="scripts/datepicker/datepicker.js" charset="utf-8"></script>
	<script type="text/javascript" src="scripts/datepicker/datepicker.daterange.js" charset="utf-8"></script>

</asp:Content>

<asp:Content ID="TitleContent" runat="server" ContentPlaceHolderID="TitleHolder">
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    	<tr>
    		<td valign="top">
    			<div class="breadcrumbs"><a href="campaigns.aspx" title="Campaigns">Campaigns</a>&nbsp;&rsaquo;&nbsp;</div>
    			<h1><span style="color: #666666">Campaign:</span> <span id="campaign_name"></span></h1>
    		</td>
    		<td valign="top">
    			
    		</td>
    	</tr>
    </table>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    
    <div class="content-middle-tabs-section">
		<div class="content-middle-tabs">
	    	<ul class="content-middle-tabs-container">
				<li><a href="campaignsettings.aspx?campaign_id=<%=CampaignId%>" title="Edit" class="selected"><span>Edit</span></a></li>
	    		<li><a href="campaign.aspx?campaign_id=<%=CampaignId%>" title="Ads"><span>Ads</span></a></li>
				<li><a href="campaignstatistics.aspx?campaign_id=<%=CampaignId%>" title="Referrals"><span>Referrals</span></a></li>
	    	</ul>
    	</div>
    </div>
    <div style="clear: both; padding-top: 20px;">
    
	
		<div class="params">
			<div class="param-name"><span>* Campaign Name:</span></div>
			<div class="param-value">
				<div><input type="text" style="width: 225px;" autocomplete="off" maxlength="254" name="campaign_name" id="text_campaign_name" class="mask" title="Campaign #1" mask="Campaign #1"></div>
				<div><label id="status_campaign_name"></label></div>
			</div>
		</div>
		<div>
			<div class="params">
				<div class="param-name">Theme:</div>
				<div class="param-value">
					<select id="select_theme"></select>
				</div>
			</div>
		</div>
		
		<div style="height: 24px; overflow: hidden;"></div>
		<div class="params">
			<div class="param-name">&nbsp;</div>
			<div class="param-value">
				<a href="javascript:;" title="Update" class="button-green" id="button_update"><span>Update</span></a>
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

var getCampaign = function(params) {
	
	var obj = {
		getCampaign : {
			accountId : params.accountId,
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

var updateCampaign = function(params) {
	
	var obj = {
		updateCampaign : {
			accountId : params.accountId,
			campaignId : params.campaignId,
			campaignName : params.campaignName,
			themeId : params.themeId
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

var	themes = {
	getList : function(params) {
	
		var obj = {
			getList : {
				accountId : params.accountId
			}
		};

		$.ajax({
	        url: "handlers/themes.ashx",
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
	}
};

var account = {
	externalId : null
};

$(function () {
	
	getAccountDetails({
		accountId : $.cookie("aid"), // TODO: accountId
		success : function(_data) {
			
			account.externalId = _data.externalId;
	
			getCampaign({
				accountId : $.cookie("aid"),
				campaignId : <%=CampaignId%>,
				success : function(data) {
			
					$("#campaign_name").text(data.campaignName);
					$('#text_campaign_name').val(data.campaignName);
					
					var currentThemeId = data.themeId;
					
					themes.getList({
						accountId : $.cookie("aid"),
						success : function(data) {
			
				 		   	var e = $('#select_theme')[0].options;
			
							// default
				   		   	var k = new Option("Default", "");
				   		   	try {
				   			   e.add(k);
				   		   	} catch (ex) {
				   			   e.add(k, null)
				   		   	}
			
							for(var i = 0; i < data.list.length; i++) {
				      		   var k = new Option(data.list[i].themeName, data.list[i].themeId);
				      		   try {
				      			   e.add(k);
				      		   } catch (ex) {
				      			   e.add(k, null)
				      		   }
							}
							
							if(currentThemeId != null) {
								$("#select_theme option[value=" + currentThemeId + "]").attr("selected", "selected");
							}
			
						},
						error: function(error) {
							console.log(error);
						}
					});
					
					
					
					var v = new validator({
						elements : [
							{
								element : $('#text_campaign_name'),
								status : $('#status_campaign_name'),
								rules : [
									{ method : 'required', message : 'This field is required.' }
								]
							}
						],
						submitElement : $('#button_update'),
						messages : null,
						accept : function () {
			
			
							/*
							createCampaign({
								accountId : $.cookie("aid"),
								campaignName : $('#text_campaign_name').val(),
								themeId : ($('#select_theme').val() != "" ? $('#select_theme').val() : undefined),
								success : function(data) {
					
									if(data.campaignId != undefined) {
										location.href = "newad.aspx?campaign_id=" + data.campaignId;
									}
								},
								error: function(error) {
									alert("ERR --> ")
								}
							});
							*/
							
							updateCampaign({
								accountId : $.cookie("aid"),
								campaignId : <%=CampaignId%>,
								campaignName : $('#text_campaign_name').val(),
								themeId : ($('#select_theme').val() != "" ? $('#select_theme').val() : null),
								success : function(data) {
									
									
									$("#campaign_name").text($('#text_campaign_name').val());
								
									var modal = new lightFace({
										title : "Changes saved.",
										message : "Your changes were successfully saved.",
										actions : [
										    { 
										    	label : "OK", 
										    	fire : function() { 
										    		 modal.close(); 
										    	}, 
										    	color: "green" 
										    }
										],
										overlayAll : true
									});
								
								},
								error: function(error) {
								
									console.log(error);
								
								}
							});
							
							
						},
						error: function() {
		
						}
					});
	
	
					/*
					var defaultFocus = function() {
						$('#text_campaign_name').focus();
					};

					defaultFocus(); // set default focus
					*/
					
					
					
			
				},
				error: function(error) {
					alert(JSON.stringify(error));
				}
			});
			
			
			
		},
		error: function(error) {
			
		}
	});
	
       
});
</script>

</asp:Content>
