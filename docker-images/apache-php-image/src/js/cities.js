$(function(){
	console.log("Loading cities");

	function loadCities() {
		$.getJSON( "/api/cities/", function(cities) {
			$(".list-cities").text("");
			console.log(cities);
			var message = "NO city found.";

			if (cities.length > 0) {
				for(var i = 0; i < cities.length; ++i){
					if(i == 0)
						message = cities[i].city + ", " + cities[i].country + ' - ';
					else
						message += cities[i].city + ", " + cities[i].country + ' - ';
				}
			}
			$(".list-cities").text(message);
		});
	};

	loadCities();
	setInterval(loadCities, 2000);
});