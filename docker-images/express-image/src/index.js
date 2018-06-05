var Chance = require('chance');
var chance = new Chance();
var Express = require('express');
var app = Express();

app.get('/', function(req, res) {
   res.send(generateStudents());
});

app.listen(3000, function() {
  console.log('Accepting HTTP requests on port 3000.');
}); 

function generateStudents() {
	//Generate a random number of students
	var numberOfStudents = chance.integer({
		min: 0,
		max: 10
	});

	console.log("Number of students: " + numberOfStudents);
	var students = [];

	//Generate a specified number of students
	for(var i = 0; i < numberOfStudents; i++) {
		var gender = chance.gender();
		var birthYear = chance.year({
			min: 1986,
			max: 1996
		});

		//Push student in the list
		students.push({
			firstName: chance.first({
				gender: gender
			}),
			lastName: chance.last(),
			gender: gender,
			birthday: chance.birthday({
				year: birthYear
			})
		});
	};
	console.log("List of students: " + students);
	return students;
}