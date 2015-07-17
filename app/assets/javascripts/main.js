// how to make this contingent, only accessible on loading

$(document).ready(function(){

	if( $('#loading-icon-heart') ){
		var intervalID = setInterval(function(){
			$('#loading-icon-heart').velocity(
				{scale: "+=50%"}, [500,20]
			);
		}, 1000);

		var intervalID2 = setInterval(function(){
			$('#loading-icon-heart').velocity(
				{scale: "-=50%"}, [500,20]
			);
		}, 1000);
	  
	  var timeoutID = setTimeout(function(){
	    window.location.href="http://desolate-hamlet-2924.herokuapp.com/browse";
	  }, 5000);
	};

})

