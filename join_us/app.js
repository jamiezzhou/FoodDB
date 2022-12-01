var express = require('express');
var app = express();
var bodyParser = require("body-parser");
var mysql = require('mysql2');

app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({extended: true}));
app.use(express.static(__dirname + "/public"));

var connection = mysql.createConnection({
    host: "localhost",
    user: "root",
    database: "join_us",
    password: "Julia412"
});

app.get("/", function(req,res){
    //Find count of users in DB
    var q = 'SELECT COUNT(*) As count FROM users';
    connection.query(q, function(err, results){
        if (err) throw err;
        var count = results[0].count;
        //res.send('We have ' + count + " uesrs in our db");
        res.render("home", {data: count});
    });
});

// app.get("/", function (req, res) {
//     console.log('SOMEONE REQUESTED US!');
//     res.send("You've reached the Home Page!");
// });

app.get("/joke", function(req, res){
    var joke = "What do you call a dog that does magic tricks? A labracadabrador.";
    res.send(joke);
});

app.post("/register", function(req, res){
    //console.log("POST REQUEST SENT TO /REGISTER email is " + req.body.email);
    var person = {
        email: req.body.email
    };

    var q = 'INSERT INTO users SET ?';

    connection.query(q, person, function(error, result) {
        if (error) throw error;
        //res.send("Thanks for joining our server!");
        //res.render(a home page)
        res.redirect("/");
    });
});

// app.get("/random_num", function(req,res){
//     var num = Math.floor(Math.random() * 10) + 1;
//     res.send("Your lucky number is:" + num);
// });

app.listen(8080, function () {
    console.log('Server running on 8080!');
});
