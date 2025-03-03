<%@ Page Title="Campaign" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="CampaignAds.aspx.cs" Inherits="CampaignAds" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

	<link rel="stylesheet" type="text/css" href="css/datatable/datatable.css" />
	<link rel="stylesheet" type="text/css" href="Styles/colorbox/colorbox.css" />

	<script type="text/javascript" src="scripts/datatable/datatable.js"></script>
	<script type="text/javascript" src="scripts/validator/validator-1.2.8.js"></script>
	<script type="text/javascript" src="Scripts/jquery.colorbox-min.js"></script>

</asp:Content>

<asp:Content ID="TitleContent" runat="server" ContentPlaceHolderID="TitleHolder">
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    	<tr>
    		<td valign="top">
    			<div class="breadcrumbs"><a href="campaigns.aspx" title="Campaigns">Campaigns</a>&nbsp;&rsaquo;&nbsp;</div>
    			<h1><span style="color: #666666">Campaign:</span> <span id="campaign_name">Campaign</span></h1>
    		</td>
    		<td valign="top">
    		
    			<div style="float: right; position: relative;" id="daterange">
    			</div>
    			
    		</td>
    	</tr>
    </table>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    
    <div class="content-middle-tabs-section">
		<div class="content-middle-tabs">
	    	<ul class="content-middle-tabs-container">
	    		<li><a href="campaign.aspx?campaign_id=<%=CampaignId%>" title="Statistics"><span>Statistics</span></a></li>
	    		<li><a href="campaignads.aspx?campaign_id=<%=CampaignId%>" title="Ads" class="selected"><span>Ads</span></a></li>
	    	</ul>
    	</div>
    </div>
    <div style="clear: both; padding-top: 24px;">
    
    	<div id="table_ads"></div>
		
    </div>
    
    
<script type="text/javascript">
var servletUrl = "handlers/ads.ashx";
var getAds = function(params) {
	
	var obj = {
		getAds : {
			campaignId : params.campaignId,
			top : 5000,
			from : undefined,
			to : undefined
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

var copyAd = function(params) {
	
	var obj = {
		copyAd : {
			adId : params.adId,
			adName : params.adName
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
			adId : params.adId,
			adName : params.adName
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

var deleteAds = function(params) {
	
	var obj = {
		deleteAds : {
			list : params.list
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

var getCampaign = function(params) {
	
	var obj = {
		getCampaign : {
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




var ads = [];
var tableAds = null;
var renderTableAds = function() {
	
	$('#table_ads').empty();
	tableAds = $('#table_ads').dataTable({
		tableColumns : [
			{ key : 'adId', label : '#', sortable: true, width: 46, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } },
			{ key : 'adName', label : 'Ad', sortable : true, formatter : function(cell, value, record, source) {
				return $("<a href=\"ad.aspx?ad_id=" + record.adId + "\" title=\"" + record.adName + "\">" + record.adName + "</a>");
			}},
			{ key : 'served', label : '% Served', sortable : true, width: 80, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } },
			{ key : 'clicks', label : 'Clicks', sortable : true, width: 80, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } },
			{ key : 'ctr', label : 'CTR', sortable : true, width : 80, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } },
			{ key: 'modifyDate', label: 'Modify Date', sortable: true, sortBy : { dataType: "date" }, width: 126, formatter: function(cell, value, record, source) {
				if(record.modifyDate) {
					var left = record.modifyDate.substring(record.modifyDate.lastIndexOf(" "), " ");
					var right = record.modifyDate.replace(left, "");
					return left + "<b class=\"hours\">" + right + "</b>";
				} 
            }}
		],
		dataSource : ads, 
		pagingStart : 10,
		show : [5, 10, 25, 50, 100],
		selectable : true,
		actions : [
			{
				label : "New ad",
				color: "green",
				icon : "add-white",
				fire : function() {
					location.href = "newad.aspx?campaign_id=<%=CampaignId%>";
				}
			},
			{ 
				label : "Delete",
				disabled : true,
				fire : function(records, source) {

					if(records.length > 0) {
	
						var list = [];
						$(records).each(function(index) {
							list.push(records[index].adId);
						});
						
						var modal = new lightFace({
							title : "Deleting ads",
							message : "Are you sure you want to delete selected ads?",
							actions : [
								{ 
									label : "Delete", 
									fire : function() {
										
										
										deleteAds({
											list : list,
											success : function() {
												
												getAds({
													campaignId : <%=CampaignId%>,
													success : function(data) {
														ads = data.list;
														renderTableAds();
													},
													error : function() {
														ads = [];
														renderTableAds();
													}
												});
												
												
												modal.close();
												
											},
											error : function() {
												//
											}
										});
										
										
									},
									color: "green"
								}, 
								{
									label : "Cancel",
									fire: function() {
										modal.close();
									},
									color: "white"
								}
							],
							overlayAll : true
						});
						
						
					}
					
				}
			},
			{
				label : "More actions",
				disabled : true,
				condition : 1,
				actions : [
					{ 
						label : "Rename", 
						fire : function(records, source) {
							
							
							var v = null;
							var M = $("<div>" +
								"<div style=\"padding: 0 0 12px 0\">Enter a new ad name.</div>" +
								"<div class=\"row\">" +
									"<div class=\"cell\">" +
										"<div><input type=\"text\" id=\"text_rename_ad_name\" name=\"rename_ad_name\" maxlength=\"100\" autocomplete=\"off\" style=\"width: 323px;\" /></div>" +
										"<div><label id=\"status_rename_ad_name\"></label></div>" +
									"</div>" +
								"</div>" +
							"</div>");
							var I = M.find('#text_rename_ad_name');
							var B = M.find('#status_rename_ad_name');
							
							var modal = new lightFace({
								title : "Rename ad",
								message : M,
								actions : [
								   { 
									   label : "Save", 
									   fire : function() {
									   		// check validation
											v.validate();
								   		}, 
								   		color: "green" 
								   },
								   { 
								   		label : "Cancel", 
								   		fire : function() { 
								   			modal.close(); 
								   		}, 
								   		color: "white" 
								   }
								],
								overlayAll : true,
								complete : function() {
									
									// set default values
									I.val(records[0].adName).select();
									
									// initialize validator on input
									v = new validator({
										elements : [
											{
												element : I,
												status : B,
												rules : [
													{ method : 'required', message : 'This field is required.' },
													{ method : 'rangelength', pattern : [3,100] }
												]
											}
										],
										submitElement : null,
										messages : null,
										accept : function () {
											
											
											updateAd({
												adName : $.removeHTMLTags(I.val()).replace(/\r/g, ""),
												adId : records[0].adId,
												success : function(data) {
													
													getAds({
														campaignId : <%=CampaignId%>,
														success : function(data) {
															ads = data.list;
															renderTableAds();
														},
														error : function() {
															ads = [];
															renderTableAds();
														}
													});
													
													modal.close();  
													
													
												},
												error: function() {
													//
												}
											});
											
											
										},
										error: function() {
											// error
										}
									});
								}
							});
							
						}
					},
					{ 
						label : "Copy", 
						fire : function(records, source) {
							
							
							var v = null;
							var M = $("<div>" +
								"<div style=\"padding: 0 0 12px 0\">Enter a name you'll use to reference this ad.</div>" +
								"<div class=\"row\">" +
									"<div class=\"cell\">" +
										"<div><input type=\"text\" id=\"input_copy_ad_name\" name=\"input_copy_ad_name\" maxlength=\"100\" autocomplete=\"off\" style=\"width: 323px;\" /></div>" +
										"<div><label id=\"status_input_copy_ad_name\"></label></div>" +
									"</div>" +
								"</div>" +
							"</div>");
							var I = M.find('#input_copy_ad_name');
							var B = M.find('#status_input_copy_ad_name');
							
							var modal = new lightFace({
								title : "Copying ad",
								message : M,
								actions : [
								   { 
									   label : "Copy", 
									   fire : function() {
									   		// check validation
											v.validate();
								   		}, 
								   		color: "green" 
								   },
								   { 
								   		label : "Cancel", 
								   		fire : function() { 
								   			modal.close(); 
								   		}, 
								   		color: "white" 
								   }
								],
								overlayAll : true,
								complete : function() {
									
									// set default values
									I.val("Copy of " + records[0].adName);
									
									// initialize validator on input
									v = new validator({
										elements : [
											{
												element : I,
												status : B,
												rules : [
													{ method : 'required', message : 'This field is required.' },
													{ method : 'rangelength', pattern : [3,100] }
												]
											}
										],
										submitElement : null,
										messages : null,
										accept : function () {
											
											copyAd({
												adName : $.removeHTMLTags(I.val()).replace(/\r/g, ""),
												adId : records[0].adId,
												success : function(data) {
													
													
													getAds({
														campaignId : <%=CampaignId%>,
														success : function(data) {
															ads = data.list;
															renderTableAds();
														},
														error : function() {
															ads = [];
															renderTableAds();
														}
													});
													
													modal.close(); 
													
													
												},
												error: function() {
													//
												}
											});
											
										},
										error: function() {
											// error
										}
									});
								}
							});
							
							
						}
					}
				]
			}
		]
	});
	
};


$(function () {

	$("#daterange").dateRange({
		maxFromDate : null,
		change : function(data) {
			// alert("RANGE -> ")
		}
	});

	getCampaign({
		campaignId : <%=CampaignId%>,
		success : function(data) {
			
			$("#campaign_name").text(data.campaignName);
		
			getAds({
				campaignId : <%=CampaignId%>,
				success : function(data) {
					ads = data.list;
					renderTableAds();
				},
				error : function() {
					ads = [];
					renderTableAds();
				}
			});
			
		},
		error: function(error) {
			alert(JSON.stringify(error));
		}
	});
       
});

function OpenUrl(s) {
	$.colorbox({ html: "<h3>" + s + "</h3>" });
}

function OpenPreview(s) {
	$.colorbox({ iframe: true, href: "Preview/PreviewAd.aspx?auid=" + s, width: "770px", height: "500px", scrolling: false });
}

function OpenResource(s) {
	$.colorbox({ iframe: true, href: s, width: "900px", height: "550px", scrolling: false });
}
</script>

</asp:Content>
