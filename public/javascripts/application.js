jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})
// 
// // Place your application-specific JavaScript functions and classes here
// // This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
 	// $('.expandable').fancybox();

	resetButtons();

	
})
// 

function filter_dates(){
	var day_offset		=	parseInt($('input[name=day_offset]:checked').val());
	var hour			=	parseInt($('input[name=hour]:checked').val());
	var minute_offset	=	parseInt($('input[name=minute_offset]:checked').val());
	var hour_offset		=	parseInt($('input[name=hour_offset]:checked').val());
	var duration		= 	parseInt($('select[name=duration]').val());
	
	var start 	= day_offset + hour + minute_offset + hour_offset;
	var end 	= start + duration;
	
	var $container = $("#objects_container");
	
	var isoFilters = []
	
	for(i = start; i < end; i++){
		isoFilters.push(".timeslot-" + i);
	}
	var selector = ":not(" + isoFilters.join("") + ")";
	
	alert(selector);
	$container.isotope({filter : selector});
}

function resetButtons(){
	$('input').button();
	$('.radio').buttonset();
	$(".link").button();	
}

// function formatTitle(title, currentArray, currentIndex, currentOpts) {
//     return '<div id="preview-title"><span><a href="javascript:;" onclick="$.fancybox.close();"><img src="images/closelabel.gif" /></a></span>' + (title && title.length ? '<b>' + title + '</b>' : '' ) + '</div>';
// }
// 
