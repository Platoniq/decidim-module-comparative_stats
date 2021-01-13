// = require chartkick
// = require Chart.bundle
// = require_self

$(() => {
	//create trigger to resizeEnd event
	$(window).resize(() => {
	    if(window.resizeTO) clearTimeout(window.resizeTO);
	    window.resizeTO = setTimeout(() => {
        $(window).trigger('resizeEnd');
	    }, 100);
	});
});