<%@ Page Title="Theme" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Theme.aspx.cs" Inherits="Theme" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

	<link rel="stylesheet" type="text/css" href="css/datatable/datatable.css" />
	<link rel="stylesheet" type="text/css" href="css/tipsy/tipsy.css" />
	
	<link rel="stylesheet" type="text/css" href="css/minicolors/minicolors.css" />
	
	<script type="text/javascript" src="scripts/datatable/datatable.js"></script>
	<script type="text/javascript" src="scripts/tipsy/tipsy.min.js" charset="utf-8"></script>
	<script type="text/javascript" src="scripts/validator/validator-1.2.8.js"></script>
	<script type="text/javascript" src="scripts/minicolors/minicolors.js"></script>
	
	<style type="text/css">
	.advanced-property { display: none; }
	.advanced-property.active { display: table-row; }
	.advanced-property td {
		background-color: #f7f7f7;
	}
	</style>

</asp:Content>

<asp:Content ID="TitleContent" runat="server" ContentPlaceHolderID="TitleHolder">
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    	<tr>
    		<td valign="top">
				<div class="breadcrumbs"><a href="themes.aspx" title="Themes">Themes</a>&nbsp;&rsaquo;&nbsp;</div>
    			<h1><span style="color: #666666">Theme:</span> <span id="theme_name"></span></h1>
    		</td>
    		<td valign="top">
    			
    		</td>
    	</tr>
    </table>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    
    <div style="clear: both;">
		
		<div class="params">
			<div class="param-name">Theme Id:</div>
			<div class="param-value"><b><label id="label_theme_id"></label></b></div>
		</div>
		<div class="params">
			<div class="param-name">Theme External Id:</div>
			<div class="param-value"><b><label id="label_theme_external_id"></label></b></div>
		</div>
		<div>
			<div class="params">
				<div class="param-name">Group:</div>
				<div class="param-value"><select id="select_group"></select></div>
			</div>
			<div>
				<table class="ti">
					<thead>
						<tr>
							<th>No</th>
							<th>Name</th>
							<th>Description</th>
							<th>Type</th>
							<th>Example</th>
							<th>Value</th>
						</tr>
					</thead>
					<tbody id="table_body_properties"></tbody>
				</table>
			</div>
			<div style="padding-top: 10px; display: none" id="container_update_properties">
				<table style="width: 100%" cellspacing="0" cellpadding="0">
					<tr>
						<td><a id="button_update_properties" class="button-green" title="Update Properties"><span>Update Properties</span></a></td>
						<td style="text-align: right"><label><input type="checkbox" id="checkbox_show_advanced_properties" autocomplete="off" />&nbsp;&nbsp;Show advanced properties</label></td>
					</tr>
				</table>
			</div>
		</div>
		
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
				groupId : params.groupId,
				themeId : params.themeId
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
				list : params.list,
				themeId : params.themeId
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
		themeId : <%=ThemeId %>,
		success : function(_properties) {
			
			if(_properties.list.length != 0) {
				
				$('#table_body_properties').empty();
				
				for(var i =0; i < _properties.list.length; i++) {
					
					var tr = $("<tr id=\"" + _properties.list[i].propertyTypeId + "\" data-value=\"" + _properties.list[i].valueTypeId + "\">" +
						"<td>" + _properties.list[i].propertyTypeId + "</td>" +
						"<td>" + _properties.list[i].propertyTypeName + "</td>" +
						"<td>" + (_properties.list[i].description != undefined ? _properties.list[i].description : "") + "</td>" +
						"<td>" + getValueTypeName(_properties.list[i].valueTypeId) + "</td>" +
						"<td>" + (_properties.list[i].example != undefined ? _properties.list[i].example : "") + "</td>" +
						"<td>" +
							(_properties.list[i].valueTypeId != 5 ? "<input type=\"text\" class=\"" + (_properties.list[i].valueTypeId == 1 ? "colorwell" : "") + "\" value=\"" + (_properties.list[i].value != null ? _properties.list[i].value : "") + "\" />" : "<textarea style=\"width: 316px; height: 46px\">" + decodeURIComponent(_properties.list[i].value != null ? _properties.list[i].value : "") + "</textarea>") +
						"</td>" +
					"</tr>").appendTo("#table_body_properties");
					
					if(_properties.list[i].isAdvanced) {
						tr.addClass("advanced-property");
					}
					
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
				
				// show advanced properties
				$('#checkbox_show_advanced_properties').change(function() {
					if($(this).prop("checked")) {
						$("tr.advanced-property").each(function(i, el) {
							$(el).addClass("active");
						});
					} else {
						$("tr.advanced-property").each(function(i, el) {
							$(el).removeClass("active");
						});
					}
				});
				
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
						themeId : <%=ThemeId%>,
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
	get : function(params) {
		
		var obj = {
			get : {
				accountId : params.accountId,
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
	}
};


$(function() {
	
	
	themes.get({
		accountId : $.cookie("aid"),
		themeId : <%=ThemeId%>,
		success : function(data) {
			
			$("#theme_name").text(data.themeName);
			$("#label_theme_id").text(data.themeId);
			$("#label_theme_external_id").text(data.themeExternalId);
			
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
			
		},
		error: function(error) {
			console.log(error)
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