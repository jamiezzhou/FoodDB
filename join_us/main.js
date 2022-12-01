var express = require('express');
var app = express();
var bodyParser = require("body-parser");
var mysql = require('mysql2');

app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json())
app.use(express.static(__dirname + "/public"));

var connection = mysql.createConnection({
    host: "localhost",
    user: "root",
    database: "dbProject",
    password: "Julia412"
});

app.get("/", function(req,res){
    // //Find count of users in DB
    // var q = 'SELECT COUNT(*) As count FROM users';
    // connection.query(q, function(err, results){
    //     if (err) throw err;
    //     var count = results[0].count;
    //     //res.send('We have ' + count + " uesrs in our db");
    //     res.render("home", {data: count});
    // });
    // console.log('SOMEONE REQUESTED US!');
    // res.send("You've reached the Home Page!");
    res.render("account");
});

// app.get("/", function (req, res) {
    // var joke = "What do you call a dog that does magic tricks? A labracadabrador.";
    // res.send(joke);
//     console.log('SOMEONE REQUESTED US!');
//     res.send("You've reached the Home Page!");
// });

app.get("/homepage", function(req, res){
    res.render("homepage");
});

app.get("/delivery", function(req, res){
    res.render("delivery");
});

app.post("/register", function(req, res){
    // console.log(req.body);
    var user = {
        username: req.body.username,
        password: req.body.password,
        email: req.body.email,
        phone: req.body.phone
    };

    var payment = {
        username: req.body.username,
        card_num: req.body.cardnum,
        security_num: req.body.securitynum,
        expir_date: req.body.expirdate
    }
    
    var insert_user = 'INSERT INTO user SET ?';
    var insert_payment = 'INSERT INTO payment SET ?';
    const userKeyRegExp = /^([0-9]{2}\-[0-9]{2})$/;

    if (user.password != req.body.confirmpass){
        console.log("Password don't match.");
    }
    else if (user.password.length < 6 || user.password.length > 19){
        console.log("Please input a password that is 5-20 characters long");
    }
    else if (user.phone.length != 10){
        console.log("Please input a proper phone number.");
    }
    else if (user.username == "" || user.password == "" || user.phone == ""){
        console.log("Plese do not leave required fields (*) blanck");
    }
    else if(payment.card_num != "" && payment.card_num.length!= 16){
        console.log("Please input a proper card number.");
    }
    else if (payment.card_num != "" && payment.security_num.length != 3){
        console.log("Please input a proper securitynum.");
    }
    else if (payment.card_num != "" && !userKeyRegExp.test(payment.expir_date)){
        console.log("Please input the expiration date in the format Month-Year, e.g. 01-22");
    }
    else if (payment.card_num != "" && (payment.expir_date == "" || payment.security_num == "")){
        console.log("Plese do not leave security num or expiration date blank");
    }
    else{
        connection.query(insert_user, user, function(error, result) {
            // console.log(error.errno);
            if (!error){
                // valid = true;
                console.log("Valid user added");
                if (payment.card_num == ""){
                    console.log("Successfully logged in");
                    res.redirect("/homepage");
                }
            }
            else if (error.errno == 1062){
                console.log("Username taken");
            } else {
                throw error;
            }
        });

        if(payment.card_num != ""){
            connection.query(insert_payment, payment, function(error, result) {
                console.log(error);
                if (!error){
                    console.log("Payment added to user");
                    console.log("Successfully logged in");
                    res.redirect("/homepage");
                }
                else if (error.errno == 1062){
                    console.log("Payment previously added");
                } else {
                    throw error;
                }
            });
        }
    }
    
});

"/delete"
app.post("/delete", function(req, res){
    var username = req.body.username;
    var delete_user = 'DELETE FROM user WHERE username = ?';

    if (req.body.password == ""){
        console.log("Type DELETE in the password field to confirm deletion");
    }
    else if (req.body.password == "DELETE"){
        connection.query(delete_user, username, function(error, result) {
            if (error) throw error;
            console.log("User deleted");
            res.redirect("/homepage");
        });
    }
});

// "/update"
app.post("/update", function(req, res){
    var update_pass = 'UPDATE user SET password = ? WHERE username = ?';
    var update_email = 'UPDATE user SET email = ? WHERE username = ?';
    var update_phone = 'UPDATE user SET phone = ? WHERE username = ?';
    u = req.body.username;

    if(u == ""){
        console.log("Please input the username you would like to update");
    }
    else{
    
        if (req.body.password != ""){
            connection.query(update_pass, [req.body.password, u], function(error, result) {
                if (error) throw error;
                console.log("Password updated");
            });
        }

        if (req.body.email != ""){
            connection.query(update_email, [req.body.email, u], function(error, result) {
                if (error) throw error;
                console.log("Email updated");
            });
        }

        if (req.body.phone != ""){
            connection.query(update_phone, [req.body.phone, u], function(error, result) {
                if (error) throw error;
                console.log("Phone updated");
            });
        }
    }
});

app.listen(8080, function () {
    console.log('Server running on 8080!');
});
