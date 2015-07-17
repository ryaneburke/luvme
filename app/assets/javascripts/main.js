// how to make this contingent, only accessible on loading

var $heart = $('#loading-icon-heart')

$(document).ready(function(){

	if($heart != undefined || $heart != null ){ 
		var intervalID = setInterval(function(){
			$heart.velocity(
				{scale: "+=50%"}, [500,20]
			);
		}, 1000);

		var intervalID2 = setInterval(function(){
			$heart.velocity(
				{scale: "-=50%"}, [500,20]
			);
		}, 1000);
	  
	  var timeoutID = setTimeout(function(){
	    window.location.href="http://desolate-hamlet-2924.herokuapp.com/browse";
	  }, 5000);
	};

})
