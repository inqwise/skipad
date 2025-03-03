<%@ Page Title="New Theme" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="NewTheme.aspx.cs" Inherits="NewTheme" %>

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
				<div class="breadcrumbs"><a href="themes.aspx" title="Themes">Themes</a>&nbsp;&rsaquo;&nbsp;</div>
    			<h1>Create New Theme</h1>
    		</td>
    		<td valign="top">
    			
    		</td>
    	</tr>
    </table>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    
    <div style="clear: both;">
		
		<div class="params">
			<div class="param-name"><span>* Theme Name:</span></div>
			<div class="param-value">
				<div><input type="text" style="width: 225px;" autocomplete="off" maxlength="254" name="theme_name" id="text_theme_name" /></div>
				<div><label id="status_theme_name"></label></div>
			</div>
		</div>
		
		<div style="height: 24px; overflow: hidden;"></div>
		<div class="params">
			<div class="param-name">&nbsp;</div>
			<div class="param-value">
				<a href="javascript:;" title="Create" class="button-green" id="button_create"><span>Create</span></a>
			</div>
			<div class="param-value" style="margin-left: 6px; line-height: 20px;">
				<a href="themes.aspx" title="Cancel">Cancel</a>
			</div>
		</div>
		
    </div>
    
    
<script type="text/javascript">
var servletUrl = "handlers/accounts.ashx";

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

var	themes = {
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
	}
};

$(function() {
	
	
	var v = new validator({
		elements : [
			{
				element : $('#text_theme_name'),
				status : $('#status_theme_name'),
				rules : [
					{ method : 'required', message : 'This field is required.' }
				]
			}
		],
		submitElement : $('#button_create'),
		messages : null,
		accept : function () {
			
			themes.create({
				accountId : $.cookie("aid"),
				themeName : $('#text_theme_name').val(),
				success : function(data) {
					if(data.themeId != undefined) {
						location.href = "theme.aspx?theme_id=" + data.themeId;
					}
				},
				error: function(error) {
					console.log(error);
				}
			});
			
		},
		error: function() {
		
		}
	});
	
	var defaultFocus = function() {
		$('#text_theme_name').focus();
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