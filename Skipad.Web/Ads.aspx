<%@ Page Title="Ads" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Ads.aspx.cs" Inherits="Ads" %>

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
    			<h1>Ads</h1>
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
	    		<li><a href="/" title="Dashboard"><span>Dashboard</span></a></li>
	    		<li><a href="campaigns.aspx" title="Campaigns"><span>Campaigns</span></a></li>
	    		<li><a href="ads.aspx" class="selected" title="Ads"><span>Ads</span></a></li>
	    		<!-- <li><a href="reports.aspx" title="Reports"><span>Reports</span></a></li> -->
	    		<!-- <li><a href="resources.aspx"><span>Resources</span></a></li> -->
				<li><a href="themes.aspx" title="Themes"><span>Themes</span></a></li>
				<li><a href="account.aspx" title="Account"><span>Account</span></a></li>
	    	</ul>
    	</div>
    </div>
    <div style="clear: both; padding-top: 20px;">
    	<div>
			<ul id="list_actions" style="display: inline-block;">
				<li><a id="button_customize_columns" title="Columns" class="button-white"><span>Columns</span></a></li>
			</ul>
    	</div>
		<div>
			<div>
				<div id="placeholder_customize_columns" style="display: none; background: none repeat scroll 0 0 #FFF9D7;border: 1px solid #E2C822;padding: 10px; ">
    				<h3>Customize columns</h3>
    				<table cellpadding="0" callspacing="0" border="0">
    					<tr>
    						<td valign="top">
			    				<div>
			    					<div>Select metrics</div>
			    					<div style="background: none repeat scroll 0 0 #FFFFFF;border-color: #666666 #CCCCCC #CCCCCC;border-style: solid;border-width: 1px;height: 168px;overflow-x: hidden;overflow-y: auto;width: 166px;">
			    						<ul class="list-static">
			    							
			    							<li class="added">Served<span>Added</span><a>Add</a></li>
			    							<li class="added">Slide started<span>Added</span><a>Add</a></li>
			    							<li class="added">Skip Ad fitted<span>Added</span><a>Add</a></li>
			    							<li class="added">Skip Ad Clicks<span>Added</span><a>Add</a></li>
			    							<li class="added">Skip Ad CTR<span>Added</span><a>Add</a></li>
			    							<li class="added">Total Engagement Time<span>Added</span><a>Add</a></li>
			    							<li class="added">Avg. Engagement Time<span>Added</span><a>Add</a></li>
			    							<li class="added">Time saved<span>Added</span><a>Add</a></li>
			    							
			    						</ul>
			    					</div>
			    				</div>
    						</td>
    						<td valign="top">
			    				<div style="padding-left: 10px;">
			    					<div>Drag and drop to reorder</div>
			    					<div>
			    						<ul>
			    							<li class="fixed-column">Ad id</li>
			    							<li class="fixed-column">Ad</li>
			    							<li class="fixed-column">Campaign</li>
			    						</ul>
			    					</div>
			    					<div style="width: 166px;">
			    						<ul>
			    						
			    							<li class="dragged-column">Served<a>Remove</a></li>
			    							<li class="dragged-column">Slide started<a>Remove</a></li>
			    							<li class="dragged-column">Skip Ad fitted<a>Remove</a></li>
			    							<li class="dragged-column">Skip Ad Clicks<a>Remove</a></li>
			    							<li class="dragged-column">Skip Ad CTR<a>Remove</a></li>
			    							<li class="dragged-column">Total Engagement Time<a>Remove</a></li>
			    							<li class="dragged-column">Avg. Engagement Time<a>Remove</a></li>
			    							
			    						</ul>
			    					</div>
			    				</div>
    						</td>
    					</tr>
    				</table>
    				<div>
    					<div class="params">
    						<div class="param-value">
    							<a title="Apply" class="button-green"><span>Apply</span></a>
    						</div>
    						<div class="param-value">
    							<a title="Cancel">Cancel</a>
    						</div>
    					</div>
    				</div>
    			</div>
			</div>
			<div style="padding-top: 10px;">
				<div id="table_ads"></div>
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

var getAds = function(params) {
	
	var obj = {
		getAds : {
			accountId : params.accountId,
			top : params.top,
			fromDate : params.fromDate,
			toDate : params.toDate
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
			accountId : params.accountId,
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
			accountId : params.accountId,
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
			accountId : params.accountId,
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

var exportTo = function(params) {
	
	var obj = {
		getAds : {
			accountId : params.accountId,
			adsList : params.adsList,
			top : params.top,
			fromDate : params.fromDate,
			toDate : params.toDate
		}
	};
	
	var name = encodeURIComponent("Ads " + (defaultState.fromDate).replace(":", "") + "-" + (defaultState.toDate).replace(":", ""));
	window.location = "handlers/ads.ashx?rq=" + JSON.stringify(obj) + "&otp=xls&name=" + name + "&timestamp=" + $.getTimestamp();
	
};

var ads = [];
var tableAds = null;
var renderTableAds = function() {

	$('#table_ads').empty();
	tableAds = $('#table_ads').dataTable({
		tableColumns : [
			{ key : 'adId', label : '#', sortable: true, width: 46, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } },
			{ key : 'adId', label : 'Preview', formatter : function(cell, value, record, source) {
				
				var set = $("<div>" +
					"<a class=\"link_vast_preview\" href=\"<%=SkipRollPreviewUrl%>?srqatnocache=true&pid=" + account.externalId + "&tagurl=" + encodeURIComponent(record.tagUrl) + "&width=640&height=360\" title=\"VAST\">VAST</a>" +
					(record.adTypeId == 1 ? "<br/><a class=\"link_mraid_preview\" href=\"<%=SkipRollMraidPreviewUrl%>?tagurl=" + encodeURIComponent(record.mraidTagUrl) + "&demo=1\" title=\"MRAID\">MRAID</a>" : "") +
				"</div>");
				
				set.find('.link_vast_preview').click(function(e) {
					openResource($(this).attr("href"));
					e.preventDefault();
				})
				.tipsy({
					gravity: 'sw', 
					title: function() { 
						return this.getAttribute('original-title'); 
					}
				});
				
				// only for linear
				if(record.adTypeId == 1) {
					set.find('.link_mraid_preview').click(function(e) {
						openResource($(this).attr("href"));
						e.preventDefault();
					})
					.tipsy({
						gravity: 'sw', 
						title: function() { 
							return this.getAttribute('original-title'); 
						}
					});
				}
				
				return set;
				
			}},
			{ key : 'imageUrl', label : '', sortable : false, width: 80, formatter : function(cell, value, record, source) {
				if(record.imageUrl != undefined) {
					return $("<div style=\"background: url(" + record.imageUrl + ") no-repeat scroll 0 0; background-size: 80px 45px\" class=\"cell-image\"></div>").hover(function() { 
						// out
						
					}, function() {
						// in
						 
					});
				}	
			}},
			{ key : 'adName', label : 'Ad', sortable : true, formatter : function(cell, value, record, source) {
				
				/*
				return $("<div><a href=\"ad.aspx?ad_id=" + record.adId + "\" title=\"" + record.adName + "\">" + record.adName + "</a><br/><a href=\"adedit.aspx?ad_id=" + record.adId + "\" title=\"Edit\">Edit</a><br/><a href=\"adstatistics.aspx?ad_id=" + record.adId + "\" title=\"Statistics\">Statistics</a></div>");
				*/
				return $("<a href=\"ad.aspx?ad_id=" + record.adId + "\" title=\"" + record.adName + "\">" + record.adName + "</a>");
				
			}},
			{ key : 'campaignName', label : 'Campaign', sortable : true, formatter : function(cell, value, record, source) {
				return $("<a href=\"campaign.aspx?campaign_id=" + record.campaignId + "\" title=\"" + record.campaignName + "\">" + record.campaignName + "</a>");
			}},
			{ key : 'adTypeId', label : 'Ad Type', sortable : true, formatter : function(cell, value, record, source) {
				return (record.adTypeId == 1 ? "Linear" : "Wrapper");
			}},
			{ key : 'served', label : 'Served', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help: "# of Served Videos" },
			{ key : 'slideStarted', label : 'Slide started', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "Slide Start" },
			{ key : 'percentSlideStartedFromServed', label : '% Slide started from served', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "% Slide started from Served Video", formatter : function(cell, value, record, source) {
				return record.percentSlideStartedFromServed + "%";
			}},
			{ key : 'imageFitted', label : 'Skip Ad fitted', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "# of Images correctly Fitted" },
			{ key : 'ctrFromFit', label : '% CTR from slide fit', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "The number of clicks on image divided by number of skip ad fitted.", formatter : function(cell, value, record, source) {
				return record.ctrFromFit + "%";
			}},
			{ key : 'imageClicks', label : 'Skip Ad Clicks', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "# of Clicks on Images" },
			/*{ key : 'imageCTR', label : 'Skip Ad CTR', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "CTR on Skip Ad Image" },*/
			{ key : 'totalEngagementTime', label : 'Total Engagement Time', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } },
			{ key : 'avgEngagementTime', label : 'Avg. Engagement Time<br/> (in secs)', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } },
			{ key : 'rateVoted', label : 'Voted', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } },
			{ key : 'avgRate', label : 'Avg. Rate', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, formatter : function(cell, value, record, source) {
				return (record.avgRate).toFixed(1);
			} },
			{ key : 'share', label : 'Shared', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } },
			{ key : 'reply', label : 'Replay', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } }
		],
		dataSource : ads, 
		pagingStart : 25,
		show : [5, 10, 25, 50, 100],
		selectable : true,
		actions : [
			{
				label : "New ad",
				color: "green",
				icon : "add-white",
				fire : function() {
					location.href = "newad.aspx";
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
											accountId : $.cookie("aid"),
											list : list,
											success : function() {
												
												getAds({
													accountId : $.cookie("aid"),
													fromDate : defaultState.fromDate,
													toDate : defaultState.toDate,
													success : function(data) {
														ads = data.list;
														renderTableAds();
													},
													error : function(error) {
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
						label : "Edit",
						fire : function(records, source) {
							location.href = "adedit.aspx?ad_id=" + records[0].adId;
						}
					},
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
												accountId : $.cookie("aid"),
												adName : $.removeHTMLTags(I.val()).replace(/\r/g, ""),
												adId : records[0].adId,
												success : function(data) {
													
													getAds({
														accountId : $.cookie("aid"),
														fromDate : defaultState.fromDate,
														toDate : defaultState.toDate,
														success : function(data) {
															ads = data.list;
															renderTableAds();
														},
														error : function(error) {
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
												accountId : $.cookie("aid"),
												adName : $.removeHTMLTags(I.val()).replace(/\r/g, ""),
												adId : records[0].adId,
												success : function(data) {
													
													getAds({
														accountId : $.cookie("aid"),
														fromDate : defaultState.fromDate,
														toDate : defaultState.toDate,
														success : function(data) {
															ads = data.list;
															renderTableAds();
														},
														error : function(error) {
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
			},
			{
				label : "Download report",
				icon : "down",
				disabled : true,
				fire : function(records, source) {
					
					if(records.length > 0) {
	
						var list = [];
						$(records).each(function(index) {
							list.push(records[index].adId);
						});
						
						exportTo({
							accountId : $.cookie("aid"),
							fromDate : defaultState.fromDate,
							toDate : defaultState.toDate,
							top : 5000,
							adsList : list
						});
						
					}
					
				}
			}
		]
	});
	
};

var defaultState = {
	fromDate : null,
	toDate : null
};

var account = {
	externalId : null
};

$(function () {
	
	getAccountDetails({
		accountId : $.cookie("aid"), // TODO: accountId
		success : function(_data) {
			
			account.externalId = _data.externalId;
			
			$("#daterange").dateRange({
				ranges : [
				    { description: "Custom", value : { from : 0, to : 0 }, isCustom : true },
					{ description: "Today", value : { from : 0 }, isDefault : true },
					{ description: "Yesterday", value: { from : -1 } },
					{ description: "Last 7 days", value : { from : -7, to : 0 } },
					{ description: "Last 14 days", value : { from : -14, to : 0 } },
					{ description: "Last 30 days", value: { from : -30, to : 0 } },
					{ description: "All time", value : { from : -364, to : 0 } }
				],
				change : function(data) {
		
					defaultState.fromDate = data.fromDate.format(dateFormat.masks.isoDate) + " 00:00";
					defaultState.toDate = data.toDate.format(dateFormat.masks.isoDate) + " 23:59";
			
					getAds({
						accountId : $.cookie("aid"),
						fromDate : defaultState.fromDate,
						toDate : defaultState.toDate,
						success : function(data) {
							ads = data.list;
							renderTableAds();
						},
						error : function(error) {
							ads = [];
							renderTableAds();
						}
					});
			
				},
				ready : function(data) {
			
					defaultState.fromDate = data.fromDate.format(dateFormat.masks.isoDate) + " 00:00";
					defaultState.toDate = data.toDate.format(dateFormat.masks.isoDate) + " 23:59";
			
					getAds({
						accountId : $.cookie("aid"),
						fromDate : defaultState.fromDate,
						toDate : defaultState.toDate,
						success : function(data) {
							ads = data.list;
							renderTableAds();
						},
						error : function(error) {
							ads = [];
							renderTableAds();
						}
					});
			
				}
			});
			
			
		},
		error: function(error) {
			
		}
	});
		

	
	
	$("#button_customize_columns").click(function() {	
		if(!$("#placeholder_customize_columns").is(":visible")) {	
			$("#placeholder_customize_columns").show();
		} else {
			$("#placeholder_customize_columns").hide();
		}
	});
	
       
});

function openUrl(s) {
    $.colorbox({ html: "<h3>" + s + "</h3>" });
}

function openPreview(s) {
    $.colorbox({ iframe: true, href: "Preview/PreviewAd.aspx?auid=" + s, width: "770px", height: "500px", scrolling: false });
}

function openResource(s) {
	$.colorbox({ iframe: true, href: s, width: "682px", height: "430px", scrolling: false });
}

</script>

</asp:Content>
