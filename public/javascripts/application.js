jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})
// 
// // Place your application-specific JavaScript functions and classes here
// // This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
 	$('.expandable').fancybox();

	resetButtons();


	
})
// 

function filter_timeslots(){
	var day_offset		=	parseInt($('input[name=day_offset]:checked').val()) * 48;
	var start			=	parseInt($('#time_picker').slider("values", 0)) + day_offset;
	var stop			=	parseInt($('#time_picker').slider("values", 1)) + day_offset;
	if (start != stop){
		var $optionSet = $('#filters_container .filter .selected');
		var $container = $("#objects_container");
		var isoFilters = [];
		$optionSet.each(function(){isoFilters.push($(this).attr("data_filter_value"))});	
		for(i = start; i < stop; i++){
			isoFilters.push(":not(.timeslot-" + i + ")");
		}

		var selector = isoFilters.join("");
		$container.isotope({filter : selector});
		if ((stop- start) > 16){
			$('.flag').addClass("illegal");
			$('.message').html('<div class="error">Your reservation cannot exceed 8 hours.</div>');
			$('.reservation_link').button({disabled:true});
		}
		else{
			$('.flag').removeClass("illegal");
			$('.message').html("");
			$('.reservation_link').button({disabled:false});
		}
		
	}
}

function filter_properties(){
	var $container = $('#objects_container'),
        filters = {};

    // filter buttons
    $('.filter a').click(function(){
      var $this = $(this);
      // don't proceed if already selected
      if ( $this.hasClass('selected') ) {
        return; 	
      }
	 
      var $optionSet = $this.parents('.option-set');
      // change selected class
      $optionSet.find('.selected').removeClass('selected').button({icons:{}});
      $this.addClass('selected').button({icons: {secondary : "ui-icon-carat-1-e"}})
	  
      // store filter value in object
      // i.e. filters.color = 'red'
      
	  filter_timeslots();
      return false;
    });
	$('.filter a').button();
}



function resetButtons(){
	$('input').button();
	$('.radio').buttonset();
	$(".link").button();
	$('.disabled').button({disabled:true});
}

// function formatTitle(title, currentArray, currentIndex, currentOpts) {
//     return '<div id="preview-title"><span><a href="javascript:;" onclick="$.fancybox.close();"><img src="images/closelabel.gif" /></a></span>' + (title && title.length ? '<b>' + title + '</b>' : '' ) + '</div>';
// }
// 
