DROP DATABASE dbProject;
CREATE DATABASE dbProject;
USE dbProject;

CREATE TABLE restaurant(
    id CHAR(9) NOT NULL,
    name VARCHAR(20) NOT NULL,
    address VARCHAR(100) NOT NULL,
    website VARCHAR(200),
    avg_rating INT,
    menu VARCHAR(2000) NOT NULL,
    open_time TIME NOT NULL,
    end_time TIME NOT NULL,
    phone CHAR(10),
    num_of_reviewers INT,
    PRIMARY KEY (id),
    CONSTRAINT name_address UNIQUE (name, address)
);

INSERT INTO restaurant VALUES
(123456789, "Jenis1", "1", "web1", NULL,
    "menu1","9:00","6:00",1234567890,NULL),
(223456789, "Jenis2", "2", "web2", NULL,
    "menu2","9:00","6:00",2234567890,NULL),
(323456789, "Jenis3", "3", "web3", NULL,
    "menu3","9:00","6:00",3234567890,NULL),
(423456789, "Jenis4", "4", "web4", NULL,
    "menu4","9:00","6:00",4234567890,NULL),
(523456789, "Jenis5", "5", "web5", NULL,
    "menu5","9:00","6:00",5234567890,NULL),
(623456789, "Jenis6", "6", "web6", NULL,
    "menu6","9:00","6:00",6234567890,NULL);


CREATE TABLE convenience_food(
    id CHAR(9) NOT NULL,
    drive_through BOOLEAN DEFAULT (false) NOT NULL,
    parking BOOLEAN DEFAULT (false) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES restaurant(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO convenience_food(id) VALUES
(123456789), 
(223456789),
(523456789);

CREATE TABLE fine_dinning(
    id CHAR(9) NOT NULL,
    dressing_req VARCHAR(50) DEFAULT "Formal Dressing",
    parking BOOLEAN NOT NULL DEFAULT (false),
    avail_seats INT NOT NULL DEFAULT (500),
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES restaurant(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO fine_dinning(id) VALUES
(323456789);

CREATE TABLE snacks_and_drinks(
    id CHAR(9) NOT NULL,
    group_order BOOLEAN NOT NULL DEFAULT (false),
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES restaurant(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO snacks_and_drinks(id) VALUES
(423456789),
(623456789);

CREATE TABLE food(
    res_id CHAR(9) NOT NULL,
    food_id CHAR(9) NOT NULL,
    food_name VARCHAR(50) NOT NULL,
    food_type VARCHAR(50),
    food_price DECIMAL(5,1) NOT NULL,
    PRIMARY KEY (res_id, food_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO food VALUES
(123456789, 123456789, "apple", NULL, 30.1),
(123456789, 123456788, "grape", NULL, 30.1),
(223456789, 123456789, "pear", NULL, 30.1),
(323456789, 123456789, "apple3", NULL, 30.1),
(423456789, 123456789, "apple4", NULL, 30.1),
(423456789, 123456788, "pear4", NULL, 30.1),
(423456789, 123456787, "grape4", NULL, 30.1),
(423456789, 123456786, "banana4", NULL, 30.1),
(523456789, 123456789, "apple5", NULL, 30.1),
(523456789, 123456788, "grape5", NULL, 30.1),
(623456789, 123456789, "apple6", NULL, 30.1);



CREATE TABLE user(
    username VARCHAR(20) NOT NULL,
    password VARCHAR(20) NOT NULL,
    start_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    email VARCHAR(50),
    phone CHAR(10) NOT NULL,
    PRIMARY KEY (username),
    CONSTRAINT username_phone UNIQUE (username, phone),
    CHECK (CHAR_LENGTH(password) > 5 and CHAR_LENGTH(password) < 20 and CHAR_LENGTH(phone) = 10)
);
INSERT INTO user VALUES
('Amy','00000000',DEFAULT, 'amy@gmail.com',1234567890),
('Bob','00000000',DEFAULT, 'bob@gmail.com',1234567890),
('Alice','00000000',DEFAULT, 'alice@gmail.com',1234567890);

CREATE TABLE payment(
    username VARCHAR(20) NOT NULL,
    card_num CHAR(16) NOT NULL,
    security_num CHAR(3) NOT NULL,
    expir_date CHAR(5) NOT NULL,
    PRIMARY KEY (username, card_num),
    FOREIGN KEY (username) REFERENCES user(username) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (CHAR_LENGTH(card_num) = 16 and CHAR_LENGTH(security_num) = 3 and CHAR_LENGTH(expir_date) = 5)
);

CREATE TABLE delivery(
    dlvy_num CHAR(9) NOT NULL,
    dlvy_time TIME NOT NULL,
    res_id CHAR(9) NOT NULL,
    fee DECIMAL(6,2) NOT NULL,
    instructions VARCHAR(100),
    buyer_name VARCHAR(20) NOT NULL,
    buyer_address VARCHAR(100) NOT NULL,
    buyer_contact CHAR(10) NOT NULL,
    PRIMARY KEY (dlvy_num),
    FOREIGN KEY (res_id) REFERENCES restaurant(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (buyer_name, buyer_contact) REFERENCES user(username, phone)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE delivery_food(
    dlvy_num CHAR(9) NOT NULL,
    res_id CHAR(9) NOT NULL,
    food_id CHAR(9) NOT NULL,
    PRIMARY KEY (dlvy_num, res_id, food_id),
    FOREIGN KEY (dlvy_num) REFERENCES delivery(dlvy_num)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (res_id, food_id) REFERENCES food(res_id, food_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE reservation(
    reserv_num CHAR(9) NOT NULL,
    res_id CHAR(9) NOT NULL,
    reserv_name VARCHAR(20) NOT NULL,
    reserv_contact CHAR(10) NOT NULL,
    reserv_time DATETIME NOT NULL,
    special_request VARCHAR(20),
    PRIMARY KEY (reserv_num),
    FOREIGN KEY (res_id) REFERENCES restaurant(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (reserv_name, reserv_contact) REFERENCES user(username, phone)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE review(
    review_num CHAR(9) NOT NULL,
    res_id CHAR(9) NOT NULL,
    rating INT NOT NULL,
    review_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reviewer VARCHAR(20) NOT NULL,
    content VARCHAR(250) NOT NULL,
    images VARCHAR(200),
    PRIMARY KEY (review_num),
    FOREIGN KEY (res_id) REFERENCES restaurant(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (reviewer) REFERENCES user(username)
    ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO review VALUES
('222222222','123456789',4,'2020-11-30 10:59:00', 
'Amy', 'It tastes fantastic', 'image 1'),
('333333333','123456789',5,'2022-12-30 11:00:00', 
'Bob', 'I like the rainbow flavor', 'image 2'),
('444444444','223456789',2,'2022-12-30 11:00:00', 
'Bob', 'I hate the taste', 'image 4'),
('555555555','323456789',1,'2022-12-30 11:00:00', 
'Alice', 'I don"t like the rainbow flavor', 'image 5'),
('666666666','323456789',2,'2022-12-30 11:00:00', 
'Bob', 'Hate it', 'image 6'),
('777777777','323456789',3,'2022-12-30 11:00:00', 
'Amy', 'Hate it, actually no', 'image 7');

UPDATE restaurant SET num_of_reviewers = (SELECT COUNT(*) FROM review WHERE  restaurant.id = review.res_id);
UPDATE restaurant SET avg_rating = (SELECT AVG(rating) FROM review WHERE restaurant.id = review.res_id);