<%@ Page Title="Themes" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Themes.aspx.cs" Inherits="Themes" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

	<link rel="stylesheet" type="text/css" href="css/datatable/datatable.css" />
	<link rel="stylesheet" type="text/css" href="css/tipsy/tipsy.css" />
	
	<link rel="stylesheet" type="text/css" href="css/minicolors/minicolors.css" />
	
	<script type="text/javascript" src="scripts/datatable/datatable.js"></script>
	<script type="text/javascript" src="scripts/tipsy/tipsy.min.js" charset="utf-8"></script>
	<script type="text/javascript" src="scripts/validator/validator-1.2.8.js"></script>
	<script type="text/javascript" src="scripts/minicolors/minicolors.js"></script>

</asp:Content>

<asp:Content ID="TitleContent" runat="server" ContentPlaceHolderID="TitleHolder">
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    	<tr>
    		<td valign="top">
    			<h1>Themes</h1>
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
	    		<li><a href="/" title="Dashboard"><span>Dashboard</span></a></li>
	    		<li><a href="campaigns.aspx" title="Campaigns"><span>Campaigns</span></a></li>
	    		<li><a href="ads.aspx" title="Ads"><span>Ads</span></a></li>
	    		<!-- <li><a href="reports.aspx" title="Reports"><span>Reports</span></a></li> -->
	    		<!-- <li><a href="resources.aspx"><span>Resources</span></a></li> -->
				<li><a href="themes.aspx" class="selected" title="Themes"><span>Themes</span></a></li>
				<li><a href="account.aspx" title="Account"><span>Account</span></a></li>
	    	</ul>
    	</div>
    </div>
    <div style="clear: both; padding-top: 20px;">
		
		
		<div id="table_themes"></div>
		
		
		<!--
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td valign="top" style="width: 450px">
					
				</td>
				<td valign="top">
					<div style="padding-left: 10px;">
						<h3 class="light-header-white">Account Preferences</h3>
						<div style="padding-top: 10px">
							<div class="params">
								<div class="param-name">Group:</div>
								<div class="param-value"><select id="select_group"></select></div>
							</div>
							<div>
								<table class="ti">
									<thead>
										<tr>
											<th>Property Name</th>
											<th>Value</th>
											<th>Type</th>
										</tr>
									</thead>
									<tbody id="table_body_properties"></tbody>
								</table>
							</div>
							<div style="padding-top: 10px; display: none" id="container_update_properties">
								<a id="button_update_properties" class="button-green" title="Update Properties"><span>Update Properties</span></a>
							</div>
						</div>
					</div>
				</td>
			</tr>
		</table>
		-->
		
    </div>
    
    
<script type="text/javascript">
var servletUrl = "handlers/accounts.ashx";


var properties = {
	getGroups : function(params) {
			
		var obj = {
			getGroups: {
				accountId : params.accountId
			}
		};
			
		$.ajax({
			url: "handlers/properties.ashx",
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
		
	},
	getProperties : function(params) {
		
		var obj = {
			getProperties: {
				accountId : params.accountId,
				groupId : params.groupId
			}
		};
		
		$.ajax({
			url: "handlers/properties.ashx",
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
		
	},
	updateProperties : function(params) {
			
		var obj = {
			updateProperties: {
				accountId : params.accountId,
				groupId : params.groupId,
				list : params.list
			}
		};
		
		$.ajax({
			url: "handlers/properties.ashx",
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


var get = function(params) {
	
	var obj = {
		get: {
			accountId : params.accountId
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

var update = function(params) {
	
	var obj = {
		update: {
			accountId : params.accountId,
			name : params.name
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

var getValueTypeName = function(valueTypeId) {
	var name = "Not defined";
	switch(valueTypeId) {
		case 1: 
			name = "Color";
			break;
		case 2: 
			name = "Text";
			break;
		case 3:
			name = "Number";
			break;
		case 4:
			name = "Boolean";
			break;
		case 5: 
			name = "HTML";
			break;
	}
	
	return name;
};

//takes a hex color and computes the grayscale value
var grayValue = function( color ) {
    var color_arr = color.split( "" );
    
    var red = parseInt( ( color_arr[1] + color_arr[2] ), 16 );
    var green = parseInt( ( color_arr[3] + color_arr[4] ), 16 );
    var blue = parseInt( ( color_arr[5] + color_arr[6] ), 16 );

    return ( red + green + blue ) / 3;
};

function getProperties(groupId) {
	
	properties.getProperties({
		groupId : groupId,
		accountId : $.cookie("aid"),
		success : function(_properties) {
			
			if(_properties.list.length != 0) {
				
				for(var i =0; i < _properties.list.length; i++) {
					
					var tr = $("<tr id=\"" + _properties.list[i].propertyTypeId + "\" data-value=\"" + _properties.list[i].valueTypeId + "\">" +
						"<td>" + _properties.list[i].propertyTypeName + "</td>" +
						"<td>" +
							(_properties.list[i].valueTypeId != 5 ? "<input type=\"text\" class=\"" + (_properties.list[i].valueTypeId == 1 ? "colorwell" : "") + "\" value=\"" + (_properties.list[i].value != null ? _properties.list[i].value : "") + "\" />" : "<textarea style=\"width: 316px; height: 46px\">" + decodeURIComponent(_properties.list[i].value != null ? _properties.list[i].value : "") + "</textarea>") +
						"</td>" +
						/*"<td><input type=\"text\" class=\"" + (_properties.list[i].valueTypeId == 1 ? "colorwell" : "") + "\" value=\"" + (_properties.list[i].value != null ? _properties.list[i].value : "") + "\" /></td>" +*/
						"<td>" + getValueTypeName(_properties.list[i].valueTypeId) + "</td>" +
					"</tr>").appendTo("#table_body_properties");
					
					if(_properties.list[i].valueTypeId == 1) {
					
						// black or white color
						if(_properties.list[i].value != null) {
							if( grayValue(_properties.list[i].value) < 127 ) {
		            			tr.find('input.colorwell').css( "color", "#ffffff" );
		            		} else {
		            			tr.find('input.colorwell').css( "color", "#000000" );
		            		}
						}
					
						tr.find('input.colorwell').minicolors({
							change : function(hex, opacity) {
		    					if( grayValue(hex) < 127 ) {
				            		$(this).css( "color", "#ffffff" );
				            	} else {
				            		$(this).css( "color", "#000000" );
				            	}
			    				// trigger
			    				$(this).trigger( "change" );
							
							}
						});
					
					}
										
				}
				
				
				$('#container_update_properties').show();
				$('#button_update_properties').click(function(e) {
					var obj = [];
					$('#table_body_properties tr').each(function(i, el) {	
						obj.push({
							propertyTypeId : parseInt($(el).attr("id")),
							value : (parseInt($(el).attr("data-value")) != 5 ? $(el).find('input').val() : encodeURIComponent($(el).find('textarea').val())) 
						});
					});
					
					properties.updateProperties({
						accountId : $.cookie("aid"),
						groupId : groupId,
						list : obj,
						success : function(data) {
							
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
						error: function() {
							
							var modal = new lightFace({
								title : "Error",
								message : "Please try again...",
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
							
						}
					});
					
					e.preventDefault();
				});
				
				
			} else {
				
				$('#table_body_properties').empty();
				$("<tr class=\"nop\"><td colspan=\"3\"><b>No records found.</b></td></tr>").appendTo("#table_body_properties");
				
			}
			
		},
		error: function() {
			$('#table_body_properties').empty();
			$("<tr class=\"nop\"><td colspan=\"3\"><b>No records found.</b></td></tr>").appendTo("#table_body_properties");
		}
	});
	
}

var	themes = {
	rename : function(params) {
		
		var obj = {
			rename : {
				accountId : params.accountId,
				themeName : params.themeName,
				themeId : params.themeId
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
	},
	create : function(params) {
		
		var obj = {
			create : {
				accountId : params.accountId,
				themeName : params.themeName
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
	},
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
	},
	deleteList : function(params) {
		
		var obj = {
			deleteList : {
				accountId : params.accountId,
				list : params.list
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

var _themes = [];
var tableThemes = null;
function renderTableThemes() {
	$('#table_themes').empty();
	tableThemes = $('#table_themes').dataTable({
		tableColumns : [
			{ key : 'themeId', label : '#', sortable: true, width: 46, style : { header: { 'text-align' : 'right' }, cell : { 'text-align' : 'right' } } },
			{ key : 'themeExternalId', label : 'External Id', sortable : true, width: 80 },
			{ key : 'themeName', label : 'Theme', sortable: true, formatter : function(cell, value, record, source) {
				return $("<a href=\"theme.aspx?theme_id=" + record.themeId + "\" title=\"" + record.themeName + "\">" + record.themeName + "</a>");
			}},
			{ key : 'modifyDate', label : 'Modify Date', sortable : true, width: 120 }
		],
		dataSource : _themes, 
		pagingStart : 25,
		show : [5, 10, 25, 50, 100],
		selectable : true,
		actions : [
			{
				label : "New theme",
				color: "green",
				icon : "add-white",
				fire : function() {
					
					location.href = "newtheme.aspx";
					
				}
			},
			{ 
				label : "Delete",
				disabled : true,
				fire : function(records, source) {

					if(records.length > 0) {
	
						var list = [];
						$(records).each(function(index) {
							list.push(records[index].themeId);
						});
						
						var modal = new lightFace({
							title : "Deleting themes",
							message : "Are you sure you want to delete selected themes?",
							actions : [
								{ 
									label : "Delete", 
									fire : function() {
										
										themes.deleteList({
											accountId : $.cookie("aid"),
											list : list,
											success : function() {
												
												themes.getList({
													accountId : $.cookie("aid"),
													success : function(data) {
														_themes = data.list;
														renderTableThemes();
													},
													error : function() {
														_themes = [];
														renderTableThemes();
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
							location.href = "theme.aspx?theme_id=" + records[0].themeId;
						}
					},
					{ 
						label : "Rename", 
						fire : function(records, source) {
							
							var v = null;
							var M = $("<div>" +
								"<div style=\"padding: 0 0 12px 0\">Enter a new theme name.</div>" +
								"<div class=\"row\">" +
									"<div class=\"cell\">" +
										"<div><input type=\"text\" id=\"text_rename_theme_name\" name=\"rename_theme_name\" maxlength=\"100\" autocomplete=\"off\" style=\"width: 323px;\" /></div>" +
										"<div><label id=\"status_rename_theme_name\"></label></div>" +
									"</div>" +
								"</div>" +
							"</div>");
							
							var I = M.find('#text_rename_theme_name');
							var B = M.find('#status_rename_theme_name');
							
							var modal = new lightFace({
								title : "Rename theme",
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
									I.val(records[0].themeName).select();
									
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
											
											themes.rename({
												accountId : $.cookie("aid"),
												themeName : $.removeHTMLTags(I.val()).replace(/\r/g, ""),
												themeId : records[0].themeId,
												success : function(data) {
													
													themes.getList({
														accountId : $.cookie("aid"),
														success : function(data) {
			
															_themes = data.list;
															renderTableThemes();
			
														},
														error: function(error) {
			
															_themes = [];
															renderTableThemes();
			
														}
													});
													
												},
												error: function(error) {
													console.log(error);
												}
											});
												
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

$(function() {
	
	
	themes.getList({
		accountId : $.cookie("aid"),
		success : function(data) {
			
			_themes = data.list;
			renderTableThemes();
			
		},
		error: function(error) {
			
			_themes = [];
			renderTableThemes();
			
		}
	});
	
	/*
	get({
		accountId : $.cookie("aid"), // TODO: accountId
		success : function(data) {
			
			$('#text_account_name').val(data.name);
			$('#label_external_account_id').text(data.externalId);
			$('#label_create_date').text(data.createDate);
			
			// propertiess
			properties.getGroups({
				accountId : $.cookie("aid"),
				success : function(groups) {
					
					if(groups.list.length != 0) {
             		   
             		   	var e = $('#select_group')[0].options;
						for(var i = 0; i < groups.list.length; i++) {
	              		   var k = new Option(groups.list[i].name, groups.list[i].groupId);
	              		   try {
	              			   e.add(k);
	              		   } catch (ex) {
	              			   e.add(k, null)
	              		   }
						}
						
						
						// event
						$('#select_group').change(function() {
							getProperties($(this).val());
						});
						
						// get default
						getProperties($('#select_group').val());
						
						
					}
					
				},
				error: function(){
					//
				}
			});
			
			
			
			var v = null;
			v = new validator({
				elements : [
			    	{
						element : $('#text_account_name'),
						status : $('#status_account_name'),
						rules : [
							{ method : 'required', message : 'This field is required.' }
						]
					}
				],
				submitElement : $('#button_update'),
				accept : function () {
					
					update({
						accountId : $.cookie("aid"), // TODO: accountId,
						name : $('#text_account_name').val(),
						success : function(data) {
							location.href = location.href;
						},
						error: function(error) {
							console.log(JSON.stringify(error));
						}
					});
					
				}
			});
			
		},
		error: function(error) {
			// console.log(JSON.stringify(error));
		}
	});
	*/
		
});

</script>

</asp:Content>