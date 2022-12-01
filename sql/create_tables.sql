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
    "menu4","9:00","6:00",4234567890,NULL);


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
(223456789);

CREATE TABLE fine_dinning(
    id CHAR(9) NOT NULL,
    dressing_req VARCHAR(50),
    parking BOOLEAN NOT NULL DEFAULT (false),
    avail_seats INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES restaurant(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO fine_dinning(id) VALUES
(323456789);

CREATE TABLE snacks_and_drinks(
    id CHAR(9) NOT NULL,
    group_order BOOLEAN DEFAULT (false) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES restaurant(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO snacks_and_drinks(id) VALUES
(423456789);

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
(423456789, 123456789, "apple4", NULL, 30.1);


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

CREATE TABLE payment(
    username VARCHAR(20) NOT NULL,
    card_num CHAR(16) NOT NULL,
    security_num CHAR(3) NOT NULL,
    expir_date CHAR(5) NOT NULL,
    PRIMARY KEY (username, card_num),
    FOREIGN KEY (username) REFERENCES user(username)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (CHAR_LENGTH(card_num) = 16 and CHAR_LENGTH(security_num) = 3 and CHAR_LENGTH(expir_date) = 5)
);

CREATE TABLE delivery(
    dlvy_num CHAR(9) NOT NULL,
    dlvy_time DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP + INTERVAL 30 MINUTE),
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
    res_name VARCHAR(20) NOT NULL,
    res_address VARCHAR(100) NOT NULL,
    reserv_name VARCHAR(20) NOT NULL,
    num_of_people INT NOT NULL,
    reserv_contact CHAR(10) NOT NULL,
    reserv_time DATETIME NOT NULL,
    PRIMARY KEY (reserv_num),
    FOREIGN KEY (res_id) REFERENCES restaurant(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (reserv_name, reserv_contact) REFERENCES user(username, phone)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE reservation_request(
    reserv_num CHAR(9) NOT NULL,
    special_request VARCHAR(20),
    PRIMARY KEY (reserv_num,special_request),
    FOREIGN KEY (reserv_num) REFERENCES reservation(reserv_num)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE review(
    review_num CHAR(9) NOT NULL,
    res_id CHAR(9) NOT NULL,
    res_name VARCHAR(20) NOT NULL,
    res_address VARCHAR(100) NOT NULL,
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

