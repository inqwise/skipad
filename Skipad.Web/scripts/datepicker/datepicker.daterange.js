
// $.cookie('the_cookie', 'the_value');
;
(function ($) {
    $.fn.extend({
    	dateRange: function (o) {
    		
        	var a = $(this),
            options = $.extend({
            	ranges : [
					{ description: "Custom", value : { from : 0, to : 0 }, isCustom : true },
					{ description: "Today", value : { from : 0 }, isDefault : true },
					{ description: "Yesterday", value: { from : -1 } },
					{ description: "Last 7 days", value : { from : -7, to : 0 } },
					{ description: "Last 14 days", value : { from : -14, to : 0 } },
					{ description: "Last 30 days", value: { from : -30, to : 0 } },
					{ description: "All time", value : { from : 0, to : 0 } } 
            	],
            	active : 0,
            	change : null,
            	ready : null
            }, o);


			var now = new Date();
			var before = new Date();
				before.setDate(now.getDate()-30);
			
			var formatedDateRange = null;
			var dateRange = [before.format(dateFormat.masks.isoDate),  now.format(dateFormat.masks.isoDate)]; //[before.format(dateFormat.masks.isoDate),  now.format(dateFormat.masks.isoDate)];
			var newDateRange = [before.format(dateFormat.masks.isoDate),  now.format(dateFormat.masks.isoDate)]; //[before.format(dateFormat.masks.longDate),  now.format(dateFormat.masks.longDate)]; //[before.format(dateFormat.masks.isoDate),  now.format(dateFormat.masks.isoDate)];
			
			var getDateRange = function() {
				var tmp = [];
				$.each(dateRange, function(n, v){
					tmp.push(v);
				});
				return tmp;
			};
			
			var getNewDateRange = function() {
				var tmp = [];
				$.each(newDateRange, function(n, v){
					tmp.push(v);
				});
				return tmp;
			};
			
			var parseDate = function(input, format) {
				format = format || 'yyyy-mm-dd'; // default format
				var parts = input.match(/(\d+)/g), 
				     i = 0, fmt = {};
				// extract date-part indexes from the format
				format.replace(/(yyyy|dd|mm)/g, function(part) { fmt[part] = i++; });
				return new Date(parts[fmt['yyyy']], parts[fmt['mm']]-1, parts[fmt['dd']]);
			};
			
			var formatDateRange = function(range) {
				var a = parseDate(range[0]);// new Date(range[0]);
				var b = parseDate(range[1]); // new Date(range[1]);
				return {
					fromDate : a.format(dateFormat.masks.mediumDate),
					toDate : b.format(dateFormat.masks.mediumDate)
				}
			};
			
			
			
			
			
			
			
			var rangeToSet = {
				description: null,
				fromDate: null,
				toDate : null,
				value : null
			};
			
			var tempSelected = null;
			var lastSelected = null;
			
			
			var isCookies = false;
			
			var customFromDate = null; 
			var customToDate = null;


			var init = function() {
		
		
				var el = $("<div class=\"datepicker-text\" id=\"datepicker_text\">" +
			    				"<div class=\"datepicker-date-range-container\">" +
			    					"<div id=\"datepicker_date_range_description\"></div>" +
			    					"<div id=\"datepicker_date_range_value\"></div>" +
			    				"</div>" +
			    				"<div id=\"datepicker_editor\">" +
			    					"<div>" +
				    					"<ul id=\"datepicker_ranges\"></ul>" +
			    					"</div>" +
			    					"<div class=\"datepicker-actions\">" +
			    						"<a id=\"datepicker_button_set\" class=\"button-green\" title=\"OK\"><span>OK</span></a>" +
			    					"</div>" +
			    				"</div>" +
			    			"</div>").appendTo(a);
				
				
				var p = null;
				
				
				
				
				
				
				
				
				
				
				
				
			   
				
				
				
				
				$("#datepicker_ranges").empty();
				
				
				
				
				if($.cookie) {
					if($.cookie('datepicker_daterange') != null) {
						isCookies = true;
					}
				}
				
				
				var isMatch = false;
				
				for(var i = 0; i < options.ranges.length; i++) {
					
					
					var item = $("<li/>")
						.text(options.ranges[i].description)
						.attr({ index : i, description: options.ranges[i].description })
						.click(function() {
							
							
							if(lastSelected != null && lastSelected != $(this)) {
								lastSelected.removeClass("selected");
							}
							lastSelected = $(this);
							
							lastSelected.addClass("selected");
							
							
							if(!$(this).hasClass("custom")) {
							
								var a = new Date();
								var b = new Date();
								
								
								if(options.ranges[parseInt($(this).attr("index"))].value != null) {
									b.setDate(a.getDate()+options.ranges[parseInt($(this).attr("index"))].value.from);
									
									if(options.ranges[parseInt($(this).attr("index"))].value.to != undefined) {
										a.setDate(a.getDate()+options.ranges[parseInt($(this).attr("index"))].value.to);
									} else {
										a.setDate(a.getDate()+options.ranges[parseInt($(this).attr("index"))].value.from);
									}
									
								} else {
									// all time
									// alert("ALL TIME");
								}
								
								rangeToSet = {
									description: $(this).attr("description"),
									fromDate: b, // .format(dateFormat.masks.mediumDate)
									toDate : a, // .format(dateFormat.masks.mediumDate)
									value : options.ranges[parseInt($(this).attr("index"))].value
								};
								
								
								
								
								
							
							}
							
							
						})
						.appendTo("#datepicker_ranges");
					
					
							// custom
							if(options.ranges[i].isCustom) {
								
								item.addClass("custom");
								
								$("<div class=\"datepicker-custom\">" +
				    				"<div class=\"datepicker-custom-fields\">" +
										"<div class=\"datepicker-custom-from\"><input type=\"text\" id=\"dpd1\" size=\"12\" maxlength=\"12\" />&nbsp;-&nbsp;</div>" +
										"<div class=\"datepicker-custom-to\"><input type=\"text\" id=\"dpd2\" size=\"12\" maxlength=\"12\" /></div>" +
									"</div>" +
								"</div>").appendTo(item);
								
								
								
								
								
							}
							
							
							if(isCookies) {
						 		
								if(options.ranges[i].description == JSON.parse($.cookie('datepicker_daterange')).description) { 
									
										if(!isMatch) {
										
											
											var defaultA = null;
											var defaultB = null;
											
											if(options.ranges[i].isCustom) {
												
												customFromDate = JSON.parse($.cookie('datepicker_daterange')).fromDate; 
												customToDate = JSON.parse($.cookie('datepicker_daterange')).toDate;
												
												defaultA = new Date(customToDate);
												defaultB = new Date(customFromDate);
												
											} else {
											
												defaultA = new Date();
												defaultB = new Date();
											
												if(options.ranges[i].value != null) {
													defaultB.setDate(defaultA.getDate()+options.ranges[i].value.from);
													
													if(options.ranges[i].value.to != undefined) {
														defaultA.setDate(defaultA.getDate()+options.ranges[i].value.to);
													} else {
														defaultA.setDate(defaultA.getDate()+options.ranges[i].value.from);
													}
													
												}
											}
											
											
											rangeToSet = {
												description: options.ranges[i].description,
												fromDate: defaultB, // .format(dateFormat.masks.mediumDate)
												toDate : defaultA, // .format(dateFormat.masks.mediumDate)
												value : options.ranges[i].value
											};
											
											$("#datepicker_date_range_description").text(rangeToSet.description);
											$('#datepicker_date_range_value').text(rangeToSet.fromDate.format(dateFormat.masks.mediumDate) + (rangeToSet.value.to != undefined ? " - " + rangeToSet.toDate.format(dateFormat.masks.mediumDate) : ""));
											
											
											lastSelected = $(item);
											lastSelected.addClass("selected");
											
											tempSelected = lastSelected;
											
											if(options.ready != null 
													&& typeof options.ready == 'function') {
												options.ready(rangeToSet);
											}
											
									
											isMatch = true;
										
										}
									
									
								}
						 		
								
						 	} else {
							
								// default
								if(options.ranges[i].isDefault != undefined) {
									
									
									var defaultA = new Date();
									var defaultB = new Date();
									
									if(options.ranges[i].value != null) {
										defaultB.setDate(defaultA.getDate()+options.ranges[i].value.from);
										
										if(options.ranges[i].value.to != undefined) {
											defaultA.setDate(defaultA.getDate()+options.ranges[i].value.to);
										} else {
											defaultA.setDate(defaultA.getDate()+options.ranges[i].value.from);
										}
										
									} else {
										// all time
										// alert("ALL TIME");
									}
									
									rangeToSet = {
										description: options.ranges[i].description,
										fromDate: defaultB, // .format(dateFormat.masks.mediumDate)
										toDate : defaultA, // .format(dateFormat.masks.mediumDate)
										value : options.ranges[i].value
									};
									
									$("#datepicker_date_range_description").text(rangeToSet.description);
									$('#datepicker_date_range_value').text(rangeToSet.fromDate.format(dateFormat.masks.mediumDate) + (rangeToSet.value.to != undefined ? " - " + rangeToSet.toDate.format(dateFormat.masks.mediumDate) : ""));
									
									
									lastSelected = $(item);
									lastSelected.addClass("selected");
									
									tempSelected = lastSelected;
									
									if(options.ready != null 
											&& typeof options.ready == 'function') {
										options.ready(rangeToSet);
									}
									
								}
					
						 	}
					 	
					
					
				}
				
				// click
				$("#datepicker_button_set").click(function() {
					
					if(lastSelected != null) {
						if(lastSelected.hasClass("custom")) {
							
							
							
							
							
							var a = new Date();
							var b = new Date();
							
							
							var valueA = $.trim($('#dpd1').val());
							
							if (valueA == null || valueA == '') {
								//$(this).addClass('error');
							}
			
							if(!/Invalid|NaN/.test(new Date(valueA))) {
								var d = new Date(Date.parse(valueA));
						       	a = d;
								a.format(dateFormat.masks.isoDate);
								
							} else {
								//$(this).addClass('error');
							}
							
							
							
							var valueB = $.trim($('#dpd2').val());
							
							if (valueB == null || valueB == '') {
								//$(this).addClass('error');
							}
			
							if(!/Invalid|NaN/.test(new Date(valueB))) {
								var d = new Date(Date.parse(valueB));
						       	b = d;
								b.format(dateFormat.masks.isoDate);
							} else {
								//$(this).addClass('error');
							}
							
							
							
							
							rangeToSet = {
								description: lastSelected.attr("description"),
								fromDate: a, // .format(dateFormat.masks.mediumDate)
								toDate : b, // .format(dateFormat.masks.mediumDate)
								value : {
									from : 0,
									to : 0
								}
							};
							
							
						}
					}
					
					
					
					tempSelected = lastSelected;
					
					
					
					
					
					
					
					
					
					
					$("#datepicker_date_range_description").text(rangeToSet.description);
					$('#datepicker_date_range_value').text(rangeToSet.fromDate.format(dateFormat.masks.mediumDate) + (rangeToSet.value.to != undefined ? " - " + rangeToSet.toDate.format(dateFormat.masks.mediumDate) : ""));
					
					
					// hide datepicker
					p.removeClass('active');
					$('#datepicker_editor').hide();
					
					
					
					
					// set cookies
					if($.cookie) {
						$.cookie('datepicker_daterange', JSON.stringify(rangeToSet));
					}

					
					
					
					if(options.change != null 
							&& typeof options.change == 'function') {
						options.change(rangeToSet);
					}
					
					
				});
				
				
				
				
				
				
				var fromDate = null;
				var toDate = null;
				
				if(customFromDate != null 
						&& customToDate != null) {
					
					fromDate = new Date(customFromDate);
					toDate = new Date(customToDate);
					
				} else {
					
					fromDate = new Date(formatDateRange(getNewDateRange()).fromDate);
					toDate = new Date(formatDateRange(getNewDateRange()).toDate);
					
				}
				
				
				
				
				
			
				$('.datepicker-date-range-container').click(function() {
					
					p = $(this);
					if(!p.hasClass('active')) {
			
						
			
						$("ul#datepicker_ranges li").each(function(i, el) {
							$(el).removeClass("selected");
						});
						
						if(tempSelected != null) {
							
							lastSelected = tempSelected;
							lastSelected.addClass("selected");
							
						} else {
							
							
							
							
							// set default
							/*
							 * if(ranges[i].isDefault != undefined) {
						
									rangeToSet = {
										description: $(item).text(),
										fromDate: formatDateRange(getDateRange()).fromDate,
										toDate : formatDateRange(getDateRange()).toDate	
									};
									
									lastSelected = $(item);
									lastSelected.addClass("selected");
								}
							 */
							
						}
						
						
						
			
						// Show
						p.addClass('active');
						$('#datepicker_editor').show();
						
					} else {
						
						p.removeClass('active');
						$('#datepicker_editor').hide();
						
					}
					
				});
				
				$('.datepicker-text').click(function(){ return false; });
				
				jQuery(document).click(function(){
					if(p != undefined) {
						if(p.hasClass('active')) {
							p.removeClass('active');
							$('#datepicker_editor').hide();
						}
					}
				}); 

	
	
				
				
				
				/*
				var nowTemp = new Date();
			    var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
			    */
				
			    var checkin = $('#dpd1').datepicker({
				    /*
			    	onRender: function(date) {
				    	return date.valueOf() > now.valueOf() ? 'disabled' : '';
				    }
				    */
				}).on('changeDate', function(ev) {
					/* format: "mm-dd-yyyy" */
					/*
					if (ev.date.valueOf() > checkout.date.valueOf()) {
				    	var newDate = new Date(ev.date);
				    	newDate.setDate(newDate.getDate() + 1);
				    	checkout.setValue(newDate);
				    }
				    */
				    checkin.hide();
				    //$('#dpd2')[0].focus();
				}).data('datepicker');
			    
			    checkin.setValue(fromDate);
			    
			    
			    var checkout = $('#dpd2').datepicker({
			    	/* format: "mm-dd-yyyy" */
				    /*
			    	onRender: function(date) {
				    	return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';
				    }
				    */
			    }).on('changeDate', function(ev) {
			    	checkout.hide();
			    }).data('datepicker');
				
			    checkout.setValue(toDate);
				
				/*
				// format: 'mm-dd-yyyy'
				var checkin = $('#dpd1').datepicker({
					format: "mm-dd-yyyy"
				}).on('changeDate', function(ev) {
					checkin.hide();
				});
				
				var checkout = $('#dpd2').datepicker({
					format: "mm-dd-yyyy"
				}).on('changeDate', function(ev) {
					checkout.hide();
				});
				*/

			};
			
			init();
	
    	}
    });
})(jQuery); 