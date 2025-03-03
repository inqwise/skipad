<%@ Page Title="Campaigns" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Campaigns.aspx.cs" Inherits="Campaigns" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

	<link rel="stylesheet" type="text/css" href="css/datatable/datatable.css" />
	<link rel="stylesheet" type="text/css" href="css/datepicker/datepicker.css" />
	<link rel="stylesheet" type="text/css" href="css/tipsy/tipsy.css" />
	
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
    			<h1>All online campaigns</h1>
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
	    		<li><a href="campaigns.aspx" class="selected" title="Campaigns"><span>Campaigns</span></a></li>
	    		<li><a href="ads.aspx" title="Ads"><span>Ads</span></a></li>
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
			    							<li class="added">Video Clicks<span>Added</span><a>Add</a></li>
			    							<li class="added">Video CTR<span>Added</span><a>Add</a></li>
			    							<li>Complete<span>Added</span><a>Add</a></li>
			    							<li>First quartile<span>Added</span><a>Add</a></li>
			    							<li>midpoint<span>Added</span><a>Add</a></li>
			    							<li>Third quartile<span>Added</span><a>Add</a></li>
			    							<li class="added">Bounce rate<span>Added</span><a>Add</a></li>
			    							<li>Mute<span>Added</span><a>Add</a></li>
			    							<li>Pause<span>Added</span><a>Add</a></li>
			    							<li>Slide started<span>Added</span><a>Add</a></li>
			    							<li class="added">Skip Ad fitted<span>Added</span><a>Add</a></li>
			    							<li class="added">% Fit from served<span>Added</span><a>Add</a></li>
			    							<li>% success fit<span>Added</span><a>Add</a></li>
			    							<li>Slide missed<span>Added</span><a>Add</a></li>
			    							<li>Skip button<span>Added</span><a>Add</a></li>
			    							<li>Skip slider<span>Added</span><a>Add</a></li>
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
			    							<li class="fixed-column">Campaign id</li>
			    							<li class="fixed-column">Campaign name</li>
			    						</ul>
			    					</div>
			    					<div style="width: 166px;">
			    						<ul>
			    							<li class="dragged-column">Served<a>Remove</a></li>
			    							<li class="dragged-column">Video Clicks<a>Remove</a></li>
			    							<li class="dragged-column">Video CTR<a>Remove</a></li>
			    							<li class="dragged-column">Complete<a>Remove</a></li>
			    							<li class="dragged-column">Bounce rate<a>Remove</a></li>
			    							<li class="dragged-column">Slide started<a>Remove</a></li>
			    							<li class="dragged-column">Skip Ad fitted<a>Remove</a></li>
			    							<li class="dragged-column">% Fit from served<a>Remove</a></li>
			    							<li class="dragged-column">% success fit<a>Remove</a></li>
			    							<li class="dragged-column">Slide missed<a>Remove</a></li>
			    							<li class="dragged-column">Skip Ad Clicks<a>Remove</a></li>
			    							<li class="dragged-column">Skip Ad CTR<a>Remove</a></li>
			    							<li class="dragged-column">Total Engagement Time<a>Remove</a></li>
			    							<li class="dragged-column">Avg. Engagement Time<a>Remove</a></li>
			    							<li class="dragged-column">Time saved<a>Remove</a></li>
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
				<div id="table_campaigns"></div>
			</div>
		</div>
	
    </div>
    
    
<script type="text/javascript">
var servletUrl = "handlers/campaigns.ashx";

var updateCampaign = function(params) {
	
	var obj = {
		updateCampaign : {
			accountId : params.accountId,
			campaignId : params.campaignId,
			campaignName : params.campaignName
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

var deleteCampaigns = function(params) {
	
	var obj = {
		deleteCampaigns : {
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
		getCampaigns : {
			accountId : params.accountId,
			campaignsList : params.campaignsList,
			top : params.top,
			fromDate : params.fromDate,
			toDate : params.toDate
		}
	};
	
	var name = encodeURIComponent("Campaigns " + (defaultState.fromDate).replace(":", "") + "-" + (defaultState.toDate).replace(":", ""));
	window.location = "handlers/campaigns.ashx?rq=" + JSON.stringify(obj) + "&otp=xls&name=" + name + "&timestamp=" + $.getTimestamp();
	
};

var campaigns = [];
var tableCampaigns = null;
var renderTableCampaigns = function() {

	$('#table_campaigns').empty();
	tableCampaign = $('#table_campaigns').dataTable({
		tableColumns : [
			{ key : 'campaignId', label : '#', sortable: true, width: 36, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } },
			{ key : 'campaignName', label : 'Campaign', sortable : true, formatter : function(cell, value, record, source) {
				return $("<a href=\"campaign.aspx?campaign_id=" + record.campaignId + "\" title=\"" + record.campaignName + "\">" + record.campaignName + "</a>");
			}},
			{ key : 'served', label : 'Served', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help: "# of Served Videos" },
			{ key : 'videoClicks', label : 'Video Clicks', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "# of Clicks on Video" },
			{ key : 'videoCTR', label : 'Video CTR', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "CTR on Video", formatter : function(cell, value, record, source) {
				return record.videoCTR + "%";
			}},
			{ key : 'complete', label : 'Complete', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "Video Ad Complete" },
			{ key : 'bounceRate', label : 'Bounce rate', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "Page Bounce", formatter : function(cell, value, record, source) {
				return record.bounceRate + "%";
			}},
			{ key : 'slideStarted', label : 'Slide started', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "Slide Start" },
			{ key : 'percentSlideStartedFromServed', label : '% Slide started from served', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "% Slide started from Served Video", formatter : function(cell, value, record, source) {
				return record.percentSlideStartedFromServed + "%";
			}},
			{ key : 'imageFitted', label : 'Skip Ad fitted', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "# of Images correctly Fitted" },
			{ key : 'ctrFromFit', label : '% CTR from slide fit', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "The number of clicks on image divided by number of skip ad fitted.", formatter : function(cell, value, record, source) {
				return record.ctrFromFit + "%";
			}},
			/*
			{ key : 'percentFitFromServed', label : '% Fit from served', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "% Fitted from Served Video", formatter : function(cell, value, record, source) {
				return record.percentFitFromServed + "%";
			}},
			*/
			{ key : 'percentSuccessFit', label : '% success fit', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "% Success Fit from Slide", formatter : function(cell, value, record, source) {
				return record.percentSuccessFit + "%";
			}},
			{ key : 'slideMissed', label : 'Slide missed', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "# of unfitted images" },
			{ key : 'imageClicks', label : 'Skip Ad Clicks', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "# of Clicks on Images" },
			{ key : 'imageCTR', label : '% CTR from slide start', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "The number of clicks on image divided by slide started.", formatter : function(cell, value, record, source) {
				return record.imageCTR + "%";
			}},
			{ key : 'totalEngagementTime', label : 'Total Engagement Time', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } },
			{ key : 'avgEngagementTime', label : 'Avg. Engagement Time<br/> (in secs)', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } },
			{ key : 'timeSaved', label : 'Time saved', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, help : "Total time save by Skip the Video" },
			{ key : 'rateVoted', label : 'Voted', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } },
			{ key : 'avgRate', label : 'Avg. Rate', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } }, formatter : function(cell, value, record, source) {
				return (record.avgRate).toFixed(1);
			} },
			{ key : 'share', label : 'Shared', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } },
			{ key : 'reply', label : 'Replay', sortable : true, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } }
			/*
			{ key: 'modifyDate', label: 'Modify Date', sortable: true, sortBy : { dataType: "date" }, width: 126, formatter: function(cell, value, record, source) {
				if(record.modifyDate) {
					var left = record.modifyDate.substring(record.modifyDate.lastIndexOf(" "), " ");
					var right = record.modifyDate.replace(left, "");
					return left + "<b class=\"hours\">" + right + "</b>";
				} 
            }}
            */
		],
		dataSource : campaigns, 
		pagingStart : 25,
		show : [5, 10, 25, 50, 100],
		selectable : true,
		actions : [
			{
				label : "New campaign",
				color: "green",
				icon : "add-white",
				fire : function() {
					location.href = "newcampaign.aspx";
				}
			},
			{ 
				label : "Delete",
				disabled : true,
				fire : function(records, source) {

					if(records.length > 0) {
	
						var list = [];
						$(records).each(function(index) {
							list.push(records[index].campaignId);
						});
						
						var modal = new lightFace({
							title : "Deleting campaigns",
							message : "Are you sure you want to delete selected campaign?",
							actions : [
								{ 
									label : "Delete", 
									fire : function() {
										
										
										deleteCampaigns({
											accountId : $.cookie("aid"),
											list : list,
											success : function() {
												
												getCampaigns({
													accountId : $.cookie("aid"),
													fromDate : defaultState.fromDate,
													toDate : defaultState.toDate,
													success : function(data) {
														campaigns = data.list;
														renderTableCampaigns();
													},
													error : function() {
														campaigns = [];
														renderTableCampaigns();
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
							location.href = "campaignsettings.aspx?campaign_id=" + records[0].campaignId;
						}
					},
					{ 
						label : "Rename", 
						fire : function(records, source) {
							
						
							var v = null;
							var M = $("<div>" +
								"<div style=\"padding: 0 0 12px 0\">Enter a new campaign name.</div>" +
								"<div class=\"row\">" +
									"<div class=\"cell\">" +
										"<div><input type=\"text\" id=\"text_rename_campaign_name\" name=\"rename_campaign_name\" maxlength=\"100\" autocomplete=\"off\" style=\"width: 323px;\" /></div>" +
										"<div><label id=\"status_rename_campaign_name\"></label></div>" +
									"</div>" +
								"</div>" +
							"</div>");
							var I = M.find('#text_rename_campaign_name');
							var B = M.find('#status_rename_campaign_name');
							
							var modal = new lightFace({
								title : "Rename campaign",
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
									I.val(records[0].campaignName).select();
									
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
											
											updateCampaign({
												accountId : $.cookie("aid"),
												campaignName : $.removeHTMLTags(I.val()).replace(/\r/g, ""),
												campaignId : records[0].campaignId,
												success : function(data) {
													
													getCampaigns({
														accountId : $.cookie("aid"),
														fromDate : defaultState.fromDate,
														toDate : defaultState.toDate,
														success : function(data) {
															campaigns = data.list;
															renderTableCampaigns();
														},
														error : function() {
															campaigns = [];
															renderTableCampaigns();
														}
													});
													
													// refresh
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
							list.push(records[index].campaignId);
						});
						
						exportTo({
							accountId : $.cookie("aid"),
							fromDate : defaultState.fromDate,
							toDate : defaultState.toDate,
							top : 5000,
							campaignsList : list
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

$(function () {

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
			
			getCampaigns({
				accountId : $.cookie("aid"),
				fromDate : defaultState.fromDate,
				toDate : defaultState.toDate,
				success : function(data) {
					campaigns = data.list;
					renderTableCampaigns();
				},
				error : function() {
					campaigns = [];
					renderTableCampaigns();
				}
			});
			
		},
		ready : function(data) {
			
			defaultState.fromDate = data.fromDate.format(dateFormat.masks.isoDate) + " 00:00";
			defaultState.toDate = data.toDate.format(dateFormat.masks.isoDate) + " 23:59";
			
			getCampaigns({
				accountId : $.cookie("aid"),
				fromDate : defaultState.fromDate,
				toDate : defaultState.toDate,
				success : function(data) {
					campaigns = data.list;
					renderTableCampaigns();
				},
				error : function() {
					campaigns = [];
					renderTableCampaigns();
				}
			});
			
			
		}
	});

	/*
	$("#button_columns").splitButton({
		actions : [
		    {
		    	label : "Test",
		    	active : true,
				click : function(button) {
					// TODO:
				}
			}
		]
	});
	*/
	
	$("#button_customize_columns").click(function() {
		
		if(!$("#placeholder_customize_columns").is(":visible")) {	
			$("#placeholder_customize_columns").show();
		} else {
			$("#placeholder_customize_columns").hide();
		}
	});
	
});
</script>

</asp:Content>
