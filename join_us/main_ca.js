var express = require('express');
var app = express();
var bodyParser = require("body-parser");
var mysql = require('mysql2');

app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json())
app.use(express.static(__dirname + "/public"));

var connection = mysql.createConnection({
    host: "localhost",
    user: "root",
    database: "dbProject",
    password: "zhou123456"
});

app.get("/", function (req, res) {
    res.render("account");
});

app.get("/homepage", function (req, res) {
    res.render("homepage");
});

app.get("/delivery", function (req, res) {
    res.render("delivery", { data: "UpdatedAfterConfirmation" });
});

app.get("/reservation", function (req, res) {
    res.render("reservation");
});

app.get("/review", function (req, res) {
    res.render("review");
});

var delivery = null;
app.post("/deliveryconfirm", function (req, res) {
    console.log("delivery_request");
    rest_id = req.body.rest_id;
    // console.log(rest_id);

    console.log(req.body.dlvy_time)
    delivery = {
        dlvy_num: Math.floor(Math.random() * 1000000000),
        dlvy_time: req.body.dlvy_time,
        res_id: rest_id,
        res_name: null,
        res_address: null,
        fee: null,
        instructions: req.body.instruct,
        buyer_name: req.body.username,
        buyer_address: req.body.address,
        buyer_contact: req.body.phone
    };

    var select_rest = "SELECT name, address FROM restaurant WHERE id=?"
    connection.query(select_rest, rest_id, function (error, result) {
        if (error) throw error;
        console.log(result[0]);
        rest_name = result[0].name;
        rest_address = result[0].address;
        setValue(rest_name, rest_address);
    });

    function setValue(n, a) {
        delivery.res_name = n
        delivery.res_address = a;
        console.log(delivery);

        f1 = req.body.food1;
        f2 = req.body.food2;
        f3 = req.body.food3;
        f4 = req.body.food4;

        var select_food = "SELECT SUM(food_price) AS p FROM food WHERE (food_id=? or food_id=? or food_id=? or food_id=?) and (res_id=?)"
        connection.query(select_food, [f1, f2, f3, f4, rest_id], function (error, result) {
            if (error) throw error;
            value = result[0].p;
            setPrice(value);
        });

        function setPrice(v) {
            delivery.fee = v;
            console.log(delivery.fee);
            res.render("delivery", { data: v });
        }
    }
});

app.post("/deliveryreturn", function (req, res) {
    res.render("homepage");
});

app.post("/deliveryrequest", function (req, res) {
    console.log(delivery);
    var insert_delivery = 'INSERT INTO delivery SET ?';
    if (delivery != null) {
        connection.query(insert_delivery, delivery, function (error, result) {
            if (error) throw error;
            res.send("Delivery inserted");
        });
    }
});

app.post("/insert", function (req, res) {
    // if(post.submit){
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

    if (user.password != req.body.confirmpass) {
        res.send("Password don't match.");
    }
    else if (user.password.length < 6 || user.password.length > 19) {
        res.send("Please input a password that is 5-20 characters long");
    }
    else if (user.phone.length != 10) {
        res.send("Please input a proper phone number.");
    }
    else if (user.username == "" || user.password == "" || user.phone == "") {
        res.send("Plese do not leave required fields (*) blanck");
    }
    else if (payment.card_num != "" && payment.card_num.length != 16) {
        res.send("Please input a proper card number.");
    }
    else if (payment.card_num != "" && payment.security_num.length != 3) {
        res.send("Please input a proper securitynum.");
    }
    else if (payment.card_num != "" && !userKeyRegExp.test(payment.expir_date)) {
        res.send("Please input the expiration date in the format Month-Year, e.g. 01-22");
    }
    else if (payment.card_num != "" && (payment.expir_date == "" || payment.security_num == "")) {
        res.send("Plese do not leave security num or expiration date blank");
    }
    else {
        connection.query(insert_user, user, function (error, result) {
            // console.log(error.errno);
            if (!error) {
                // valid = true;
                console.log("Valid user added");
                if (payment.card_num == "") {
                    console.log("Successfully logged in");
                    res.redirect("/homepage");
                }
            }
            else if (error.errno == 1062) {
                res.send("Username taken");
            } else {
                throw error;
            }
        });

        if (payment.card_num != "") {
            connection.query(insert_payment, payment, function (error, result) {
                console.log(error);
                if (!error) {
                    console.log("Payment added to user");
                    console.log("Successfully logged in");
                    res.redirect("/homepage");
                }
                else if (error.errno == 1062) {
                    res.send("Payment previously added");
                } else {
                    throw error;
                }
            });
        }
    }
    // }

});

"/delete"
app.post("/delete", function (req, res) {
    var username = req.body.username;
    var delete_user = 'DELETE FROM user WHERE username = ?';

    if (req.body.password == "") {
        res.send("Type DELETE in the password field to confirm deletion");
    }
    else if (req.body.password == "DELETE") {
        connection.query(delete_user, username, function (error, result) {
            if (error) throw error;
            console.log("User deleted");
            res.redirect("/homepage");
        });
    }
});

// "/update"
app.post("/update", function (req, res) {
    var update_pass = 'UPDATE user SET password = ? WHERE username = ?';
    var update_email = 'UPDATE user SET email = ? WHERE username = ?';
    var update_phone = 'UPDATE user SET phone = ? WHERE username = ?';
    u = req.body.username;

    if (u == "") {
        res.send("Please input the username you would like to update");
    }
    else {

        if (req.body.password != "") {
            connection.query(update_pass, [req.body.password, u], function (error, result) {
                if (error) throw error;
                res.send("Password updated");
            });
        }

        if (req.body.email != "") {
            connection.query(update_email, [req.body.email, u], function (error, result) {
                if (error) throw error;
                res.send("Email updated");
            });
        }

        if (req.body.phone != "") {
            connection.query(update_phone, [req.body.phone, u], function (error, result) {
                if (error) throw error;
                res.send("Phone updated");
            });
        }
    }
});

app.post("/check-reserve", function (req, res) {
    var reserv_num = req.body.reservID;

    if (reserv_num == "" || reserv_num.length != 9) {
        res.send("Please input a valid reservation number");
    }
    // use join
    var get_resv = 'SELECT reserv_num, reserv_name, res_id, name, reserv_time, address, website\
                    FROM restaurant R1, reservation R2\
                    WHERE R2.reserv_num = ? and R1.id = R2.res_id';
    connection.query(get_resv, reserv_num, function (error, result) {
        if (error) throw error;
        else if (result.length === 0) res.send('No Reservation Found');
        // else res.send(result[0]);
        else res.send('Reservation Number: ' + result[0].reserv_num +
            '<br/>Host Name: ' + result[0].reserv_name +
            '<br/>Restaurant ID:  ' + result[0].res_id +
            '<br/>Restaurant Name: ' + result[0].name +
            '<br/>Reservation Time: ' + result[0].name +
            '<br/>Address: ' + result[0].address +
            '<br/>Website: ' + result[0].website);

    });

});

app.post("/make-reserve", function (req, res) {
    // if(post.submit){
    const resvID = Math.floor(Math.random() * 1000000000);

    var usr_reservation = {
        reserv_name: req.body.hostname,
        res_id: req.body.restid,
        reserv_contact: req.body.phone,
        reserv_time: req.body.time,
        reserv_num: resvID,
        special_request: req.body.request,
    };
    var insert_resv = 'INSERT INTO reservation SET ?';

    if (usr_reservation.reserv_name == "" || usr_reservation.reserv_time == "" || usr_reservation.res_id == "") {
        res.send("Please do not leave fields blank");
    }
    else if (usr_reservation.reserv_contact.length != 10) {
        res.send("Please input a proper phone number.");
    }

    else {
        connection.query(insert_resv, usr_reservation, function (err, result) {
            // console.log(error.errno);
            if (!err) {
                res.send("Reservation created. Reservation ID: " + resvID);
            }
            else if (err.code === 1062) {
                res.send("Reservation failed, please request the reservation again");
            }
            // hasn't dealt with wrong restaurant ID
            else {
                throw err;
            }
        });

    }
});

var results_table = null;
app.post("/search-review", function (req, res) {
    var id = req.body.restid;

    if (id.length != 9) {
        res.send("Please input a valid reservation number");
    }
    // use join
    var get_resv = 'SELECT res_id, name, address, rating, review_date, reviewer, content, review_date\
                    FROM restaurant R1, review R2\
                    WHERE R1.id = ? and R1.id = R2.res_id';


    connection.query(get_resv, id, function (error, result) {
        if (error) throw error;
        else if (result.length === 0) res.send('No Restaurant Found');
        else {
            var num_review = result.length;
            var result_str = '';
            for (let i = 0; i < num_review; i++) {
                var str = 'Review #' + (i + 1) +
                    '<br/>Restaurant ID:  ' + result[i].res_id +
                    '<br/>Restaurant Name: ' + result[i].name +
                    '<br/>Restaurant Address: ' + result[i].addres +
                    '<br/>Reviewer: ' + result[i].reviewer +
                    '<br/>Rating: ' + result[i].rating +
                    '<br/>Content: ' + result[i].content +
                    '<br/>Review Date: ' + result[i].review_date + '<br/><br/>';
                result_str += str;
            }
            res.send(result_str);
        }
    });




});


app.listen(8080, function () {
    console.log('Server running on 8080!');
});
