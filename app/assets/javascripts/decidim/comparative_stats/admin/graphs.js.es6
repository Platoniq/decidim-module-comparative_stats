//= require chartkick
//= require Chart.bundle


$(function() {
	//create trigger to resizeEnd event
	$(window).resize(function() {
	    if(this.resizeTO) clearTimeout(this.resizeTO);
	    this.resizeTO = setTimeout(function() {
	        $(this).trigger('resizeEnd');
	    }, 100);
	});
});