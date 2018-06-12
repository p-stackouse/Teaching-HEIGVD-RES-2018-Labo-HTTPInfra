var Chance = require('chance');
var chance = new Chance();
var ip = require('ip');
var Express = require('express');
var app = Express();

var ip_str = ip.address();

app.get('/', function(req, res) {
   res.send(generateCities());
   res.render('index', { title: 'Page Title' });
});

app.listen(3000, function() {
  console.log('Accepting HTTP requests on port 3000.');
}); 

function generateCities() {
	//Generate a random number of cities
	var  numberOfCities = chance.integer({
		min: 0,
		max: 10
	});

	console.log("Number of cities: " + numberOfCities);
	var cities = [];

	//Generate a specified number of cities
	for(var i = 0; i < numberOfCities; i++) {
		var city = chance.city();
		var country = chance.country()

		//Push cities in the list
		cities.push({
			city: city,
			country: country
		});
	};
	console.log("List of cities: " + cities);
	return cities;
}