$(document).ready(function(){
	var intervalID = setInterval(function(){
		$('#loading-icon-heart').velocity(
			{scale: "+=50%"}, [500,20]
		);
	}, 1000)
	var intervalID2 = setInterval(function(){
		$('#loading-icon-heart').velocity(
			{scale: "-=50%"}, [500,20]
		);
	}, 2000)
})
