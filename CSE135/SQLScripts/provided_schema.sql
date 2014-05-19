
DROP TABLE users CASCADE;
DROP TABLE categories CASCADE;
DROP TABLE products CASCADE;
DROP TABLE carts CASCADE;


CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    role        TEXT,
    age   	INTEGER,
    state  	TEXT
);
INSERT INTO users (name, role, age, state) VALUES('Adam','owner',35,'california');
INSERT INTO users (name, role, age, state) VALUES('Bruce','owner',46,'Illinois');
INSERT INTO users (name, role, age, state) VALUES('David','customer',33,'New York');
INSERT INTO users (name, role, age, state) VALUES('Floyd','customer',27,'Florida');
INSERT INTO users (name, role, age, state) VALUES('James','customer',55,'Texas');
INSERT INTO users (name, role, age, state) VALUES('Ross','customer',24,'Arizona');
SELECT * FROM  users order by id asc;




CREATE TABLE categories (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    description TEXT
);
INSERT INTO categories (name, description) VALUES('Computers','A computer is a general purpose device that can be programmed to carry out a set of arithmetic or logical operations automatically. Since a sequence of operations can be readily changed, the computer can solve more than one kind of problem.');
INSERT INTO categories (name, description) VALUES('Cell Phones','A mobile phone (also known as a cellular phone, cell phone, and a hand phone) is a phone that can make and receive telephone calls over a radio link while moving around a wide geographic area. It does so by connecting to a cellular network provided by a mobile phone operator, allowing access to the public telephone network.');
INSERT INTO categories (name, description) VALUES('Cameras','A camera is an optical instrument that records images that can be stored directly, transmitted to another location, or both. These images may be still photographs or moving images such as videos or movies.');
INSERT INTO categories (name, description) VALUES('Video Games','A video game is an electronic game that involves human interaction with a user interface to generate visual feedback on a video device..');
SELECT * FROM categories order by id asc;


CREATE TABLE products (
    id          SERIAL PRIMARY KEY,
    cid         INTEGER REFERENCES categories (id),
    name        TEXT NOT NULL,
    SKU         TEXT NOT NULL UNIQUE,
    price       FLOAT NOT NULL
);
INSERT INTO products (cid, name, SKU, price) VALUES(1, 'Apple MacBook','103001',1200);
INSERT INTO products (cid, name, SKU, price) VALUES(1, 'HP Laptop',    '106044', 480);
INSERT INTO products (cid, name, SKU, price) VALUES(1, 'Dell Laptop',  '109023', 399.99);
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'Iphone 5s',        '200101', 709);
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'Samsung Galaxy S4','208809', 488.5);
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'LG Optimus g',     '209937', 375);
INSERT INTO products (cid, name, SKU, price) VALUES(3, 'Sony DSC-RX100M','301211', 689.7);
INSERT INTO products (cid, name, SKU, price) VALUES(3, 'Canon EOS Rebel T3',  '304545', 449.9);
INSERT INTO products (cid, name, SKU, price) VALUES(3, 'Nikon D3100',  '308898', 520);
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'Xbox 360',  '405065', 249.99);
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'Nintendo Wii U ',  '407033', 430.99);
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'Nintendo Wii',  '408076', 232.99);
SELECT * FROM products order by id asc;


CREATE TABLE carts (
    id          SERIAL PRIMARY KEY,
    uid         INTEGER REFERENCES users (id) ON DELETE SET NULL,
    pid         INTEGER REFERENCES products (id) ON DELETE SET NULL,
    quantity    INTEGER,
    price       FLOAT
);
INSERT INTO carts (uid, pid, quantity,price) VALUES(3, 1 , 2, 1200);
INSERT INTO carts (uid, pid, quantity,price) VALUES(3, 2 , 1, 480);
INSERT INTO carts (uid, pid, quantity,price) VALUES(4, 10, 4, 249.99);
INSERT INTO carts (uid, pid, quantity,price) VALUES(5, 12, 2, 465.98);
INSERT INTO carts (uid, pid, quantity,price) VALUES(5, 9 , 5, 520);
INSERT INTO carts (uid, pid, quantity,price) VALUES(5, 5 , 3, 488.5);
INSERT INTO carts (uid, pid, quantity,price) VALUES(6, 10, 3, 249.99);
SELECT * FROM carts order by id desc;

