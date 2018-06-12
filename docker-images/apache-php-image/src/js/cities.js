$(function(){
	console.log("Loading cities");

	function loadCities() {
		$.getJSON( "/api/cities/", function(cities) {
			console.log(cities);
			$(".list-cities").empty(); //vide la liste
			if (cities.length > 0) {
				for(var i = 0; i < cities.length; ++i){
					var p = document.createElement('p');
					p.innerHTML = cities[i].city + ", " + cities[i].country;
					$(".list-cities").append(p);
				}
			}else{
				var p = document.createElement('p');
			    p.innerHTML = "No city found";
			    $(".list-cities").append(p);
			}
		});
	};

	loadCities();
	setInterval(loadCities, 2000);
});
