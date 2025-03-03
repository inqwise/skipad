<%@ Page Title="AdStatistics" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="AdStatistics.aspx.cs" Inherits="AdStatistics" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

	<link rel="stylesheet" type="text/css" href="css/datatable/datatable.css" />
	<link rel="stylesheet" type="text/css" href="css/datepicker/datepicker.css" />
	<link rel="stylesheet" type="text/css" href="css/tipsy/tipsy.css" />
	<link rel="stylesheet" type="text/css" href="Styles/colorbox/colorbox.css" />
	
	
	<script type="text/javascript" src="scripts/datatable/datatable.js"></script>
	<script type="text/javascript" src="scripts/tipsy/tipsy.min.js"></script>
	<script type="text/javascript" src="Scripts/jquery.colorbox-min.js"></script>
	<script type="text/javascript" src="scripts/validator/validator-1.2.8.js"></script>
	<script type="text/javascript" src="scripts/utils/date.min.js"></script>
	<script type="text/javascript" src="scripts/datepicker/datepicker.js"></script>
	<script type="text/javascript" src="scripts/datepicker/datepicker.daterange.js"></script>
	<script type="text/javascript" src="scripts/lightloader/1.0.1/lightloader.min.js"></script>

		
</asp:Content>

<asp:Content ID="TitleContent" runat="server" ContentPlaceHolderID="TitleHolder">
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    	<tr>
    		<td valign="top">
    			<div class="breadcrumbs"><a href="campaigns.aspx" title="Campaigns">Campaigns</a>&nbsp;&rsaquo;&nbsp;<a href="#" id="campaign_name"></a>&nbsp;&rsaquo;&nbsp;</div>
    			<h1><span style="color: #666666">Ad:</span> <span id="ad_name"></span></h1>
    		</td>
    		<td valign="top">
    			<div style="float: right; position: relative;" id="daterange"></div>
			</td>
    	</tr>
    </table>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    
<div class="content-middle-tabs-section">
	<div class="content-middle-tabs">
		<ul class="content-middle-tabs-container">
			<li><a href="adedit.aspx?ad_id=<%=AdId%>" title="Edit"><span>Edit</span></a></li>
			<li><a href="ad.aspx?ad_id=<%=AdId%>" title="Details"><span>Details</span></a></li>
	    	<li><a href="adstatistics.aspx?ad_id=<%=AdId%>" title="Referrals" class="selected"><span>Referrals</span></a></li>
	    </ul>
    </div>
</div>
<div style="clear: both; padding-top: 20px;">
	<div>
		<div style="height: 22px; margin-bottom: 8px;"><a href="#" id="button_download_report" title="Download report" class="button-white ui-button-disabled"><span><i class="icon-down">&nbsp;</i>Download report</span></a></div>
		<div id="table_domains"></div>
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


var getDomains = function(params) {
	
	var obj = {
		getDomains : {
			accountId : params.accountId,
			adId : params.adId,
			top : params.top,
			fromDate : params.fromDate,
			toDate : params.toDate
		}
	};

	$.ajax({
        url: "handlers/referrals.ashx",
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




var domains = [];
var tableDomains = null;
var renderTableDomains = function() {
	
	if(domains.length != 0) {
		$("#button_download_report").removeClass("ui-button-disabled");
	} else {
		$("#button_download_report").addClass("ui-button-disabled");
	}
	
	$('#table_domains').empty();
	tableDomains = $('#table_domains').dataTable({
		tableColumns : [
			{ key : 'domain', label : 'Source', sortable : true, formatter : function(cell, value, record, source) {
				var domainName = (record.domain.toLowerCase() != "unknown domain" ? $("<a href=\"addomainstatistics.aspx?ad_id=<%=AdId%>&domain=" + record.domain + "\" title=\"" + record.domain + "\">" + record.domain + "</a>") : record.domain);
				return domainName;
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
		dataSource : domains, 
		pagingStart : 25,
		show : [5, 10, 25, 50, 100]
	});
};

var defaultState = {
	fromDate : null,
	toDate : null
};

var account = {
	externalId : null
};

var _campaignName = "";
var _adName = "";

var exportTo = function(params) {
	
	var obj = {
		getDomains : {
			accountId : params.accountId,
			adId : params.adId,
			top : params.top,
			fromDate : params.fromDate,
			toDate : params.toDate
		}
	};
	
	var name = encodeURIComponent(_campaignName + " " + _adName + " " + (defaultState.fromDate).replace(":", "") + "-" + (defaultState.toDate).replace(":", ""));
	window.location = "handlers/referrals.ashx?rq=" + JSON.stringify(obj) + "&otp=xls&name=" + name + "&timestamp=" + $.getTimestamp();
	
};

var loader = null;
$(function () {
	
	loader = new lightLoader();
	
	getAccountDetails({
		accountId : $.cookie("aid"), // TODO: accountId
		success : function(_data) {
			
			account.externalId = _data.externalId;
			
			getAd({
				accountId : $.cookie("aid"),
				adId : <%=AdId%>,
				success : function(data) {
		
					_campaignName = data.campaignName;
					_adName = data.adName;
		
					$("#ad_name").text(data.adName);
			
					$("#campaign_name")
						.text(data.campaignName)
						.attr({ "href" : "campaign.aspx?campaign_id=" + data.campaignId, "title" : data.campaignName });
			
				},
				error: function(error) {
					//
				}
			});
			
			$("#button_download_report").click(function(event) {
				event.preventDefault();
				if(!$(this).hasClass("ui-button-disabled")) {
					
					exportTo({
						accountId : $.cookie("aid"),
						fromDate : defaultState.fromDate,
						toDate : defaultState.toDate,
						top : 5000,
						adId : <%=AdId%>
					});
					
				}
			});
			
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
			
					loader.show("Loading...");
					
					getDomains({
						accountId : $.cookie("aid"),
						fromDate : defaultState.fromDate,
						toDate : defaultState.toDate,
						top : 5000,
						adId : <%=AdId%>,
						success : function(data) {
							
							loader.hide();
							
							domains = data.list;
							renderTableDomains();
						},
						error : function() {
							
							loader.hide();
							
							domains = [];
							renderTableDomains();
						}
					});
			
				},
				ready : function(data) {
			
					defaultState.fromDate = data.fromDate.format(dateFormat.masks.isoDate) + " 00:00";
					defaultState.toDate = data.toDate.format(dateFormat.masks.isoDate) + " 23:59";
			
					loader.show("Loading...");
			
					getDomains({
						accountId : $.cookie("aid"),
						fromDate : defaultState.fromDate,
						toDate : defaultState.toDate,
						top : 5000,
						adId : <%=AdId%>,
						success : function(data) {
							
							loader.hide();
							
							domains = data.list;
							renderTableDomains();
						},
						error : function() {
							
							loader.hide();
							
							domains = [];
							renderTableDomains();
						}
					});
			
				}
			});
			
		},
		error: function(error) {
					
		}
	});
	
});

</script>

</asp:Content>
