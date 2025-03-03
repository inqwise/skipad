<%@ Page Title="Ad" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Resources.aspx.cs" Inherits="Resources" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

	
	<link rel="stylesheet" type="text/css" href="Styles/colorbox/colorbox.css" />
	
	<script type="text/javascript" src="Scripts/jquery.colorbox-min.js"></script>
	
	<script type="text/javascript" src="scripts/validator/validator-1.2.8.js"></script>
	
</asp:Content>

<asp:Content ID="TitleContent" runat="server" ContentPlaceHolderID="TitleHolder">
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    	<tr>
    		<td valign="top">
    			<h1>Resources</h1>
    		</td>
    		<td valign="top"></td>
    	</tr>
    </table>
    
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    
    
    <div class="content-middle-tabs-section">
		<div class="content-middle-tabs">
	    	<ul class="content-middle-tabs-container">
	    		<li><a href="/" title="Dashboard"><span>Dashboard</span></a></li>
	    		<li><a href="campaigns.aspx" title="Campaigns"><span>Campaigns</span></a></li>
	    		<li><a href="ads.aspx" title="Ads"><span>Ads</span></a></li>
	    		<!-- <li><a href="reports.aspx" title="Reports"><span>Reports</span></a></li> -->
	    		<li><a href="resources.aspx" class="selected"><span>Resources</span></a></li>
	    	</ul>
    	</div>
    </div>
    <div style="clear: both; padding-top: 20px;">
    	
    	<div style="height: 28px;">
    		<div style="float: left;">
    			<a class="button-green" title="New resource" href="#"><span><i class="icon-add-white">&nbsp;</i>New resource</span></a>
    		</div>
    		<div style="float: right;">
	    		<label>Filter:</label>
	    		<select>
	    			<option>All resources</option>
	    			<option>Images</option>
	    			<option>Videos</option>
	    		</select>
    		</div>
    	</div>
    	<div style="clear: both; overflow: hidden;">
    		<ul id="list_resources" class="resources"></ul>
		</div>
		
    </div>
    
<script type="text/javascript">

var getResources = function(params) {
	
	var obj = {
		getResources : {
			top : 5000,
			from : undefined,
			to : undefined
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

var getResourceType = function(resType) {
	switch(resType) {
		case 1: {
			return "Image";
		}
		case 2: {
			return "Video";
		}
	}
};

var resources = [];
var listResources = null;
var renderListResources = function() {

	$('#list_resources').empty();
	
	
	for(var i = 0; i < resources.length; i++) {
		var l = $("<li class=\"resource-item " + (i == 0 ? "first-item" : "") + " " + (resources[i].resType == 2 ? "resource-video" : "") + "\">" +
			"<div class=\"resource-action\"><input type=\"checkbox\" /></div>" +
			"<div class=\"resource-thumb\"></div>" +
			"<div class=\"resource-details\">" +
				"<div>" + resources[i].resId + "</div>" +
				"<div>" + getResourceType(resources[i].resType) + "</div>" + 
			"</div>" +
		"</li>").appendTo($('#list_resources'));
		
		
	}
	
	
};


$(function () {

	
	resources = [
		{ resId : 1, resName: "Angry Birds", resThumbUrl : "", resType: 1 },
		{ resId : 2, resName: "Madonna", resThumbUrl : "", resType: 1 },
		{ resId : 3, resName: "Madonna", resThumbUrl : "", resType: 1 },
		{ resId : 4, resName: "Madonna", resThumbUrl : "", resType: 2 },
		{ resId : 5, resName: "Madonna", resThumbUrl : "", resType: 1 },
		{ resId : 6, resName: "Madonna", resThumbUrl : "", resType: 1 },
		{ resId : 7, resName: "Madonna", resThumbUrl : "", resType: 1 },
		{ resId : 8, resName: "Madonna", resThumbUrl : "", resType: 1 },
		{ resId : 9, resName: "Madonna", resThumbUrl : "", resType: 1 },
		{ resId : 10, resName: "Madonna", resThumbUrl : "", resType: 1 },
		{ resId : 11, resName: "Madonna", resThumbUrl : "", resType: 1 },
		{ resId : 12, resName: "Angry Birds", resThumbUrl : "", resType: 1 },
		{ resId : 13, resName: "Madonna", resThumbUrl : "", resType: 2 },
		{ resId : 14, resName: "Madonna", resThumbUrl : "", resType: 1 },
		{ resId : 15, resName: "Madonna", resThumbUrl : "", resType: 1 },
		{ resId : 16, resName: "Madonna", resThumbUrl : "", resType: 2 },
		{ resId : 17, resName: "Madonna", resThumbUrl : "", resType: 2 },
		{ resId : 18, resName: "Madonna", resThumbUrl : "", resType: 2 },
		{ resId : 19, resName: "Madonna", resThumbUrl : "", resType: 1 },
		{ resId : 20, resName: "Madonna", resThumbUrl : "", resType: 1 },
		{ resId : 21, resName: "Madonna", resThumbUrl : "", resType: 1 }
	];
	
	renderListResources();

	/*
	getResources({
		success : function(data) {
			resources = data.list;
			renderListResources();
		},
		error : function(error) {
			resources = [];
			renderListResources();
		}
	});
	*/
       
});
</script>


</asp:Content>
