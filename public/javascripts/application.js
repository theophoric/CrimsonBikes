jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})
// 
// // Place your application-specific JavaScript functions and classes here
// // This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
 	// $('.expandable').fancybox();

	resetButtons();
	// ISOTOPE
	// var $container = $('#gallery_container')
	// filters = {};
	// 
	// 
	// // $('#filters a').click(function(){
	// //   var selector = $(this).attr('data_filter');
	// //   $container.isotope({ filter: selector });
	// //   return false;
	// // });
	// 
	// 
	// 
	// $('.filter a').click(function(){
	//     var $this = $(this),
	//         isoFilters = [],
	//         prop, selector;
	//     // store filter value in object
	//     // i.e. filters.color = 'red'
	//     filters[ $this.attr('data_group') ] = $this.attr('data_filter');
	// 
	//     for ( prop in filters ) {
	//       isoFilters.push( filters[ prop ] )
	//     }
	//     selector = isoFilters.join('');
	//     $container.isotope({ filter: selector });
	// 
	//     return false;
	//   });
	// 
	// 
	// 
	// 
	//   $('#options').find('.option-set a').click(function(){
	//     var $this = $(this);
	// 
	//     // don't proceed if already selected
	//     if ( !$this.hasClass('selected') ) {
	//       $this.parents('.option-set').find('.selected').removeClass('selected');
	//       $this.addClass('selected');
	//     }
	//   });
	// 
	// $(function(){
	// 	$container : '.link'
	// });
	// 
})

function resetButtons(){
	$('input').button();
	$('.radio').buttonset();
	$(".link").button();	
}

// function formatTitle(title, currentArray, currentIndex, currentOpts) {
//     return '<div id="preview-title"><span><a href="javascript:;" onclick="$.fancybox.close();"><img src="images/closelabel.gif" /></a></span>' + (title && title.length ? '<b>' + title + '</b>' : '' ) + '</div>';
// }
// 
