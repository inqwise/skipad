<%@ Page Title="NewCampaign" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="NewCampaign.aspx.cs" Inherits="NewCampaign" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">


	<script type="text/javascript" src="scripts/validator/validator-1.2.8.js"></script>
	
</asp:Content>

<asp:Content ID="TitleContent" runat="server" ContentPlaceHolderID="TitleHolder">
    <div class="breadcrumbs"><a href="campaigns.aspx" title="Campaigns">Campaigns</a>&nbsp;&rsaquo;&nbsp;</div>
    <h1>Create New Campaign</h1>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    
    <div style="clear: both;">
    
		<div class="params">
			<div class="param-name"><span>* Campaign Name:</span></div>
			<div class="param-value">
				<div><input type="text" style="width: 225px;" autocomplete="off" maxlength="254" name="campaign_name" id="text_campaign_name" class="mask" title="Campaign #1" mask="Campaign #1"></div>
				<div><label id="status_campaign_name"></label></div>
			</div>
		</div>
		<div class="params">
			<div class="param-name"><span>Theme:</span></div>
			<div class="param-value">
				<select id="select_theme" autocomplete="off"></select>
			</div>
		</div>
		
		
		<div style="height: 24px; overflow: hidden;"></div>
		<div class="params">
			<div class="param-name">&nbsp;</div>
			<div class="param-value">
				<a href="javascript:;" title="Create" class="button-green" id="button_create"><span>Create</span></a>
			</div>
			<div class="param-value" style="margin-left: 6px; line-height: 20px;">
				<a href="campaigns.aspx" title="Cancel">Cancel</a>
			</div>
		</div>
	
    </div>
    
    
<script type="text/javascript">
var servletUrl = "handlers/campaigns.ashx";
var createCampaign = function(params) {
	
	var obj = {
		createCampaign : {
			accountId : params.accountId,
			campaignName : params.campaignName,
			themeId : params.themeId
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


$(function () {
	
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
		submitElement : $('#button_create'),
		messages : null,
		accept : function () {
			
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
			
		},
		error: function() {
		
		}
	});
	
	var defaultFocus = function() {
		$('#text_campaign_name').focus();
	};

	defaultFocus(); // set default focus
	
	
	// default button
	$(document).bind('keydown', function(e) {
		var code;
        if (!e) var e = window.event;
        if (e.keyCode) code = e.keyCode;
        else if (e.which) code = e.which;

     	// enter
        if(code == 13) {
        	if(!$('#button_create').is(':focus')) {
				v.validate();
			}
        }
	});
	
	
	
	
	$("#Form1").on("submit", function() { return false; });
	
	
});
</script>

</asp:Content>
