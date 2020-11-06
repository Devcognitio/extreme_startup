$(document).ready(function() {

	$('#advance').click(function(){
	    $.get('/advance_round');
		$.post('/advance_round', function(data) {
		  location.reload();
		});
	});

	$('#pause').click(function(){
 		$.post('/pause', function(data) {
		  location.reload();
		});
	});

	$('#resume').click(function(){
 		$.post('/resume', function(data) {
		  location.reload();
		});
	});
	
});