<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

	<link rel="stylesheet" type="text/css" href="css/datatable/datatable.css" />
	<link rel="stylesheet" type="text/css" href="css/datepicker/datepicker.css" />
	<link rel="stylesheet" type="text/css" href="css/chosen/chosen.css" />

	<script type="text/javascript" src="scripts/datatable/datatable.js"></script>
	<script type="text/javascript" src="scripts/utils/date.min.js"></script>
	<script type="text/javascript" src="scripts/datepicker/datepicker.js"></script>
	<script type="text/javascript" src="scripts/datepicker/datepicker.daterange.js"></script>
	<script type="text/javascript" src="scripts/chosen/chosen.jquery.min.js"></script>
	
	<script type="text/javascript" src="highcharts/js/highcharts.js"></script>
	<script type="text/javascript" src="highcharts/js/modules/data.js"></script>

</asp:Content>

<asp:Content ID="TitleContent" runat="server" ContentPlaceHolderID="TitleHolder">
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    	<tr>
    		<td valign="top"><h1>Dashboard</h1></td>
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
	    		<li><a href="/" class="selected" title="Dashboard"><span>Dashboard</span></a></li>
	    		<li><a href="campaigns.aspx" title="Campaigns"><span>Campaigns</span></a></li>
	    		<li><a href="ads.aspx" title="Ads"><span>Ads</span></a></li>
	    		<!-- <li><a href="reports.aspx" title="Reports"><span>Reports</span></a></li> -->
	    		<!-- <li><a href="resources.aspx"><span>Resources</span></a></li> -->
				<li><a href="themes.aspx" title="Themes"><span>Themes</span></a></li>
				<li><a href="account.aspx" title="Account"><span>Account</span></a></li>
	    	</ul>
    	</div>
    </div>
    <div style="clear: both; padding-top: 24px;">
	
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<!--
				<td style="width: 364px;" valign="top">
					<div>
						
						<div>
							<select id="select_campaigns" autocomplete="off"></select>
						</div>
						<div style="Xpadding-top: 10px;">
							<h3 class="light-header">Status</h3>
							<div style="padding: 10px 0 24px 6px;">
								<ul class="columns">
									<li>
										<div class="column-name">Running Campaigns</div>
										<div class="column-value"><a href="campaigns.aspx"><b id="label_running_campaigns">0</b></a></div>
									</li>
									<li>
										<div class="column-name">Running Ads</div>
										<div class="column-value"><a href="ads.aspx"><b id="label_running_ads">0</b></a></div>
									</li>
								</ul>
							</div>
						</div>
						
					</div>
				</td>
				-->
				<td valign="top">
					<div style="padding-left: 10px;">
						<div style="height: 22px;">
							<div style="float: left; margin-right: 6px;">
								<select autocomplete="off" id="select_chart_campaign"></select>
							</div>
							<div style="float: left; margin-right: 6px;">
								<select autocomplete="off" id="select_chart_campaign_ad"><option>- All Ads -</option></select>
							</div>
							<div style="float: left; margin-right: 6px;">
								<select autocomplete="off" id="select_chart_campaign_value"></select>
							</div>
							<div style="float: left; margin-right: 6px;">
								<span>vs</span>
							</div>
							<div style="float: left;">
								<select autocomplete="off" id="select_chart_campaign_camparison_value"></select>
							</div>
						</div>
						<div style="height: 22px; display: none">
							<label style="margin-right: 6px;"><input type="checkbox" id="checkbox_campare_with" autocomplete="off" /><span style="margin-left: 6px;">Compare to:</span></label><select autocomplete="off" id="select_chart_camparison_campaign" disabled="" style="margin-right: 6px;"></select><select autocomplete="off" id="select_chart_camparison_campaign_ad" style="margin-right: 6px;" disabled=""><option>All Ads</option></select><select autocomplete="off" id="select_chart_camparison_campaign_value" disabled="" style="margin-right: 6px;"></select><span style="margin-right: 6px;">vs</span><select autocomplete="off" id="select_chart_camparison_campaign_camparison_value" disabled=""></select>
						</div>
						<div style="padding-top: 10px;">
							<div id="chart" style="height: 200px;"></div>
						</div>
						
						<div style="padding-top: 24px; clear: both;">
							
							<h3 class="light-header-white">Activities</h3>
							
							<div style="padding-top: 12px;">
								<table class="ti">
									<thead>
										<tr>
											<th class="align-right">Video Clicks</th>
											<th class="align-right">Video CTR (%)</th>
											<th class="align-right">Bounce rate (%)</th>
											<th class="align-right">Skip Ad fitted</th>
											<th class="align-right">Skip Ad fitted / Served (%)</th>
											<th class="align-right">Skip Ad fitted / Slide (%)</th>
											<th class="align-right">Skip Ad Clicks</th>
											<th class="align-right">Skip Ad CTR (%)</th>
											<th class="align-right">Total Engagement Time</th>
											<th class="align-right">Avg. Engagement Time (in secs)</th>
											<th class="align-right">Time Saved</th>
										</tr>
									</thead>
									<tbody id="table_activities">
										
										
										<!--
										<tr>
											<td colspan="11" style="background: #e9e9e9"><b>#48 Complex</b></td>
										</tr>
										-->
										<tr>
											<td class="align-right">0</td>
											<td class="align-right">0%</td>
											<td class="align-right">0%</td>
											<td class="align-right">0</td>
											<td class="align-right">0%</td>
											<td class="align-right">0%</td>
											<td class="align-right">0</td>
											<td class="align-right">0%</td>
											<td class="align-right">0</td>
											<td class="align-right">0</td>
											<td class="align-right">0</td>
										</tr>
										
										<!--
										<tr>
											<td colspan="11" style="background: #e9e9e9"><b>#47 Test</b></td>
										</tr>
										<tr>
											<td class="align-right">0</td>
											<td class="align-right">0%</td>
											<td class="align-right">0%</td>
											<td class="align-right">0</td>
											<td class="align-right">0%</td>
											<td class="align-right">0%</td>
											<td class="align-right">0</td>
											<td class="align-right">0%</td>
											<td class="align-right">0</td>
											<td class="align-right">0</td>
											<td class="align-right">0</td>
										</tr>
										-->
										
									</tbody>
								</table>
							</div>
							
							<div style="height: 40px;">&nbsp;</div>
							
						</div>
						
					</div>
				</td>
			</tr>
		</table>
		
    </div>
    
    
<script type="text/javascript">

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

var getAds = function(params) {
	
	var obj = {
		getAds : {
			accountId : params.accountId,
			campaignId : params.campaignId,
			top : params.top,
			fromDate : params.fromDate,
			toDate : params.toDate
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

var getCampaignActivities = function(params) {
	
	var obj = {
		getCampaignActivities : {
			accountId : params.accountId,
			fromDate : params.fromDate,
			toDate : params.toDate,
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


var defaultState = {
	fromDate : null,
	toDate : null
};


var initChart = function() {
	
	// Register a parser for the American date format used by Google
    Highcharts.Data.prototype.dateFormats['m/d/Y'] = {
        regex: '^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{2})$',
        parser: function (match) {
            return Date.UTC(+('20' + match[3]), match[1] - 1, +match[2]);
        }
    };


	/*
    // Get the CSV and create the chart
    $.get("analytics.csv", function (csv) {
        
        $('#container').highcharts({

            data: {
                csv: csv
            },
            title: null,
			
            subtitle: null,
            chart: {
                type: 'area',
                style: {
		            fontFamily: 'arial',
		            color: "#000"
		        }
            },
            xAxis: {
                type: 'datetime',
                tickInterval: 7 * 24 * 3600 * 1000,
                labels : {
                	style: {
			            font: '12px arial, sans-serif'
			         }
                }
            },

            yAxis: [{ // left y axis
                title: {
                    text: null
                },
                labels: {
                    align: 'left',
                    x: 3,
                    y: 16,
                    formatter: function() {
                        return Highcharts.numberFormat(this.value, 0);
                    },
                    style: {
			            font: '12px arial, sans-serif'
			         }
                },
                showFirstLabel: false
            }, { // right y axis
                linkedTo: 0,
                gridLineWidth: 0,
                opposite: true,
                title: {
                    text: null
                },
                labels: {
                    align: 'right',
                    x: -3,
                    y: 16,
                    formatter: function() {
                        return Highcharts.numberFormat(this.value, 0);
                    },
                    style: {
			            font: '12px arial, sans-serif'
			         }
                },
                showFirstLabel: false
            }],

            legend : {
            	itemStyle: {
			            fontFamily: 'arial'
			    }
            },

            tooltip: {
                shared: true,
                crosshairs: true,
                style: {
			            font: '12px arial, sans-serif'
			         }
            },

            plotOptions: {
            	area: {
                    marker: {
                        enabled: true,
                        symbol: 'circle',
                        radius: 4,
                        states: {
                            hover: {
                                enabled: true
                            }
                        }
                    }
                },
                series: {
                    cursor: 'pointer',
                    point: {
                        events: {
                            click: function() {
                                hs.htmlExpand(null, {
                                    pageOrigin: {
                                        x: this.pageX,
                                        y: this.pageY
                                    },
                                    headingText: this.series.name,
                                    maincontentText: Highcharts.dateFormat('%A, %b %e, %Y', this.x) +':<br/> '+
                                        this.y +' visits',
                                    width: 200
                                });
                            }
                        }
                    },
                    marker: {
                        lineWidth: 1
                    }
                }
            },

            series: [
				{
                	name: 'Skip Ad Clicks'
            	}, 
            	{
                	name: 'Video Clicks'
            	}
            ]
        });
    });
	*/
	
	
};


var chart = null;

function buildChart(data) {
	var videoClicks = [];
	var videoCTR = [];
	for(var i = 0; i < data.videoClicks.length; i++) {
		videoClicks.push([Date.parse(data.videoClicks[i][0]), data.videoClicks[i][1]]);
		videoCTR.push([Date.parse(data.videoCTR[i][0]), data.videoCTR[i][1]]);
	}
	
	//console.log(JSON.stringify(videoClicks));
	
	createChart(videoClicks, videoCTR);
	
};

function createChart(videoClicks, videoCTR) {
	
	var colors = Highcharts.getOptions().colors;
	
	var options = {
			chart: {
				/*type : 'area',*/
				renderTo: 'chart',
				style: {
					/*fontFamily: "open sans",*/
					/*margin: "auto",*/
					fontFamily: "arial,sans-serif",
					fontSize: "11px"
	           	}
				/*,
	           	events: {
	                load: function(event) {
	                    getChartData();
	                }
	            }
				*/
			},
			credits: {
			      enabled: false
			},
			title : {
				text : null
			},
			subtitle : {
				text : null
			},
			xAxis: {
				type : 'datetime',
				dateTimeLabelFormats: {
					month: '%e. %b',
					year: '%b'
				},
				labels : {
					style : {
						fontFamily: "arial,sans-serif"
					},
					y :24
				}
				/*lineColor: 'red',*/
			    /*tickColor: 'red'*/
	            /*tickInterval: 7 * 24 * 3600 * 1000, // one week*/
	            /*
	            tickWidth: 0,
	            gridLineWidth: 1
	            */
			},
			yAxis: [{ 
				title: { 
					text : null
				},
				labels : {
					style : {
						fontFamily: "arial,sans-serif"
					},
					formatter: function() {
	                    return Highcharts.numberFormat(this.value, 0);
	                }
				},
				min: 0,
				gridLineColor: '#ccc'
			    /*minorGridLineColor: 'rgba(255,255,255,0.07)'*/
			},{
				linkedTo :0,
				gridLineWidth: 0,
				opposite : true,
				title: {
					text: null
				},
				labels : {
					style : {
						fontFamily: "arial,sans-serif"
					},
					align : 'right',
					/*x: -3,*/
					/*y: 16,*/
					formatter: function() {
	                    return Highcharts.numberFormat(this.value, 0);
	                }
				}
			}],
			legend: {
	            enabled: false
	        },
			tooltip: {
				shared: true,
				crosshairs: true,
				style: {
	                /*fontWeight: 'bold',*/
	                fontFamily: "arial,sans-serif",
	                fontSize: '11px'
	            },
	            borderRadius: 0
				/*
				formatter: function() {
					return "<b>" + this.series.name + "</b><br/>" + Highcharts.dateFormat('%e. %b', this.x) + ": " + this.y + " m";
				}
				*/
			},
			/*
			plotOptions: {
				series: {
	                fillOpacity: 0.3
	            }
	        },
	        */
			series:[{
				name: "Video Clicks",
				type : "area",
	            fillOpacity: 0.1,
				data: videoClicks,
				/*color: '#a856a1',*/
				marker: {
	                symbol: 'circle',
	                radius: 3
	            }
			},
			{
				name : "Skip Ad Clicks",
				data : videoCTR,
				/*type : "area",
	            fillOpacity: 0.3,*/
				color: '#ED7E17', /* '#50B432', */
				marker: {
	                symbol: 'circle',
	                radius: 3
	            }
			}
			/*
			,{
				name: "Completed",
				type : "area",
	            fillOpacity: 0.1,
				data:completed,
				color: '#3b5998', //'324E8D'
				marker: {
	                symbol: 'circle',
	                radius: 3
	            }
			},{
				name: "Partial (Incomplete)",
				type : "area",
				fillOpacity: 0.1,
				data:partial,
				color: '#8bbc21', //'#57a610'
				marker: {
	                symbol: 'circle',
	                radius: 3
	            }
			}
			*/
			]
		};
	
		chart = new Highcharts.Chart(options);
	
	
};


function renderTableActivities(data) {
	
	$("#table_activities").empty();
	
	$("<tr>" +
		"<td class=\"align-right\">" + data.videoClicks + "</td>" +
		"<td class=\"align-right\">" + data.videoCTR + "%</td>" +
		"<td class=\"align-right\">" + data.bounceRate + "%</td>" +
		"<td class=\"align-right\">" + data.imageFitted + "</td>" +
		"<td class=\"align-right\">" + data.imageFittedServed + "%</td>" +
		"<td class=\"align-right\">" + data.imageFittedSlide + "%</td>" +
		"<td class=\"align-right\">" + data.imageClicks + "</td>" +
		"<td class=\"align-right\">" + data.imageCTR + "%</td>" +
		"<td class=\"align-right\">" + data.totalEngagementTime + "</td>" +
		"<td class=\"align-right\">" + data.avgEngagementTime + "</td>" +
		"<td class=\"align-right\">" + data.timeSaved + "</td>" +
	"</tr>").appendTo("#table_activities");
	
};

$(function() {

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
			
			// TODO:	
			getCampaignActivities({
				accountId : $.cookie("aid"),
				fromDate : defaultState.fromDate,
				toDate : defaultState.toDate,
				campaignId : ($("#select_chart_campaign").val() != "" ? $("#select_chart_campaign").val() : null),
				success : function(data) {
					
					renderTableActivities(data);
					
				},
				error: function(error) {
					alert("ERROR -> " + JSON.stringify(error));
				}
			});
			
		},
		ready : function(data) {
			
			defaultState.fromDate = data.fromDate.format(dateFormat.masks.isoDate) + " 00:00";
			defaultState.toDate = data.toDate.format(dateFormat.masks.isoDate) + " 23:59";
			
			getCampaignActivities({
				accountId : $.cookie("aid"),
				fromDate : defaultState.fromDate,
				toDate : defaultState.toDate,
				success : function(data) {
					
					renderTableActivities(data);
					
				},
				error: function(error) {
					alert("ERROR -> " + JSON.stringify(error));
				}
			});
			
			
			//initChart();
			
		}
	});
	
	getCampaigns({
		accountId : $.cookie("aid"),
		top : 5000,
		success : function(data) {
		
			if(data.list.length != 0) {
				
				
				
				/*
				$("#select_campaigns").empty();
				
		        var q = $("#select_campaigns")[0].options;
		        
		        var k = new Option("All Campaigns", "");
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
				*/
				
				
				
				
				function initChartDetails() {
					
					// chart
					$("#select_chart_campaign").empty();
					$("#select_chart_camparison_campaign").empty();
			        var chartCampaign = $("#select_chart_campaign")[0].options;
					var chartCamparisonCampaign = $("#select_chart_camparison_campaign")[0].options;
			        var defaultOption = new Option("All Campaigns", "");
					//var defaultOption2 = new Option("- Select Campaign -", "");
	                try {
	                    chartCampaign.add(defaultOption);
						//chartCamparisonCampaign.add(defaultOption2);
	                } catch (ex) {
	                    chartCampaign.add(defaultOption, null);
						//chartCamparisonCampaign.add(defaultOption2, null);
	                }
			        for(var i = 0; i < data.list.length; i++) {
			        	var option = new Option("#" + data.list[i].campaignId + " - " + data.list[i].campaignName, data.list[i].campaignId);
						var option2 = new Option("#" + data.list[i].campaignId + " - " + data.list[i].campaignName, data.list[i].campaignId);
	                    try {
	                        chartCampaign.add(option);
							chartCamparisonCampaign.add(option2);
	                    } catch (ex) {
	                        chartCampaign.add(option, null);
							chartCamparisonCampaign.add(option2, null);
	                    }
			        }
					
					
					
					
					/*
					$('#select_chart_campaign_ad').empty();
					$('#select_chart_camparison_campaign_ad').empty();
					var select_chart_campaign_ad = $('#select_chart_campaign_ad')[0].options;
					var select_chart_camparison_campaign_ad = $("#select_chart_camparison_campaign_ad")[0].options;
					*/
					
					// chosen
					$("#select_chart_campaign").chosen({});
					$("#select_chart_campaign_ad").chosen({});
					// select_chart_campaign_ad
					
					var values = [
						{ value : "videoClicks", caption : "Video Clicks"},
						{ value : "videoCTR", caption : "Video CTR (%)"},
						{ value : "bounceRate", caption : "Bounce rate (%)"},
						{ value : "skipAdFitted", caption : "Skip Ad fitted"},
						{ value : "skipAdClicks", caption : "Skip Ad Clicks"},
						{ value : "skipAdCTR", caption : "Skip Ad CTR (%)"}
					];
					
					
					
					$("#select_chart_campaign_value").empty();
					$("#select_chart_campaign_camparison_value").empty();
					$("#select_chart_camparison_campaign_value").empty();
					$("#select_chart_camparison_campaign_camparison_value").empty();
					var select_chart_campaign_value = $("#select_chart_campaign_value")[0].options;
					var select_chart_campaign_camparison_value = $("#select_chart_campaign_camparison_value")[0].options;
					var select_chart_camparison_campaign_value = $("#select_chart_camparison_campaign_value")[0].options;
					var select_chart_camparison_campaign_camparison_value = $("#select_chart_camparison_campaign_camparison_value")[0].options;
					
					var camparisonDefOpt1 = new Option("None", "");
					var camparisonDefOpt2 = new Option("None", "");
					try {
						select_chart_campaign_camparison_value.add(camparisonDefOpt1);
						select_chart_camparison_campaign_camparison_value.add(camparisonDefOpt2);
					} catch(ex) {
						select_chart_campaign_camparison_value.add(camparisonDefOpt1, null);
						select_chart_camparison_campaign_camparison_value.add(camparisonDefOpt2, null);
					}
					
					for(var y = 0; y < values.length; y++) {
						var opt1 = new Option(values[y].caption, values[y].value);
						var camparisonOpt1 = new Option(values[y].caption, values[y].value);
						var opt2 = new Option(values[y].caption, values[y].value);
						var camparisonOpt2 = new Option(values[y].caption, values[y].value);
						try { 
							select_chart_campaign_value.add(opt1);
							select_chart_campaign_camparison_value.add(camparisonOpt1);
							select_chart_camparison_campaign_value.add(opt2);
							select_chart_camparison_campaign_camparison_value.add(camparisonOpt2);
						} catch(ex) {
							select_chart_campaign_value.add(opt1, null);
							select_chart_campaign_camparison_value.add(camparisonOpt1, null);
							select_chart_camparison_campaign_value.add(opt2, null);
							select_chart_camparison_campaign_camparison_value.add(camparisonOpt2, null);
						}
					}
					
					$("#checkbox_campare_with").change(function(){
						if($(this).prop("checked")) {
							$("#select_chart_camparison_campaign, #select_chart_camparison_campaign_ad, #select_chart_camparison_campaign_value, #select_chart_camparison_campaign_camparison_value").prop("disabled", false);
						} else {
							$("#select_chart_camparison_campaign, #select_chart_camparison_campaign_ad, #select_chart_camparison_campaign_value, #select_chart_camparison_campaign_camparison_value").prop("disabled", true);
						}
					});
					
					/*		
					<option>Skip Ad fitted</option>
					<option>Skip Ad fitted / Served (%)</option>
					<option>Skip Ad fitted / Slide (%)</option>
					<option>Skip Ad Clicks</option>
					<option>Skip Ad CTR (%)</option>
					<option>Time spent on Skip Ad</option>
					<option>Avg. Time on Skip Ad</option>
					<option>Time saved</option>
					*/
					
					
					// getData
					// temp data
					// fromDate :
					// toDate :
					// campaignId :
					// values : [ "videoClicks", "videoCTR" ] - 
					var charts = {
						videoClicks : [["May 12, 2014 00:00:00",0],["May 12, 2014 23:59:00",33]],
						videoCTR : [["May 12, 2014 00:00:00",0],["May 12, 2014 23:59:00",4]]
					};
					
					
					
					buildChart(charts);
					
					
				}
				
				
				initChartDetails();
				
				
				
				
		        
		        
		        //$("#label_running_campaigns").text(data.list.length);
				
				
				/*
				// get ads
				getAds({
					accountId : $.cookie("aid"),
					success : function(ads) {
						
						//$("#label_running_ads").text(ads.list.length);
						
					}
				});
				*/
				
				
				//$("#select_chart_campaign_ad").chosen({});
				// select_chart_campaign_ad
				
				
				$("#select_chart_campaign").change(function() {
					
					
					var newCampaignId = ($(this).val() != "" ? $(this).val() : null);
					
					if(newCampaignId != null) {
						
						// fill ads
						//console.log("fill ads");
						
						getAds({
							accountId : $.cookie("aid"),
							campaignId : newCampaignId,
							success : function(ads) {
						
								$('#select_chart_campaign_ad').empty();
								var select_chart_campaign_ad = $('#select_chart_campaign_ad')[0].options;
								var defaultOption = new Option("- All Ads -", "");
				                try {
				                    select_chart_campaign_ad.add(defaultOption);
				                } catch (ex) {
				                    select_chart_campaign_ad.add(defaultOption, null);
				                }
								
								for(var i = 0; i < ads.list.length; i++) {
									var option = new Option("#" + ads.list[i].adId + " - " + ads.list[i].adName, ads.list[i].adId);
				                    try {
				                        select_chart_campaign_ad.add(option);
				                    } catch (ex) {
				                        select_chart_campaign_ad.add(option, null);
				                    }
								}
								
								$("#select_chart_campaign_ad").chosen('destroy');
								$("#select_chart_campaign_ad").chosen({});
						
							}
						});
						
					} else {
						
						$('#select_chart_campaign_ad').empty();
						var select_chart_campaign_ad = $('#select_chart_campaign_ad')[0].options;
						var defaultOption = new Option("- All Ads -", "");
		                try {
		                    select_chart_campaign_ad.add(defaultOption);
		                } catch (ex) {
		                    select_chart_campaign_ad.add(defaultOption, null);
		                }
						
						$("#select_chart_campaign_ad").chosen('destroy');
						$("#select_chart_campaign_ad").chosen({});

						
					}
					
					getCampaignActivities({
						accountId : $.cookie("aid"),
						fromDate : defaultState.fromDate,
						toDate : defaultState.toDate,
						campaignId : newCampaignId,
						success : function(data) {
							
							renderTableActivities(data);
							
						},
						error: function(error) {
							alert("ERROR -> " + JSON.stringify(error));
						}
					});
					
					
					
					
				});
							
				
			}
			
			
			
		}
	});
	
	
		    
		    

});

</script>

</asp:Content>
