--additional sql queries yet to implement
SELECT * FROM restaurant WHERE avg_rating = 1;
SELECT * FROM restaurant WHERE avg_rating = 2;
SELECT * FROM restaurant WHERE avg_rating = 3;
SELECT * FROM restaurant WHERE avg_rating = 4;
SELECT * FROM restaurant WHERE avg_rating = 5;

SELECT * FROM restaurant WHERE restaurant = req.body.restaurant;