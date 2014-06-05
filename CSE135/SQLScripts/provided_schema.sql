DROP TABLE users CASCADE;
DROP TABLE categories CASCADE;
DROP TABLE products CASCADE;
DROP TABLE sales CASCADE;
DROP TABLE agerange CASCADE;
DROP TABLE states CASCADE;

CREATE TABLE users (
   id          SERIAL PRIMARY KEY,
   name        TEXT NOT NULL UNIQUE,
   role        TEXT NOT NULL,
   age         INTEGER NOT NULL,
   state       TEXT NOT NULL
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
    cid         INTEGER REFERENCES categories (id) ON DELETE CASCADE,
    name        TEXT NOT NULL,
    SKU         TEXT NOT NULL UNIQUE,
    price       INTEGER NOT NULL
);
INSERT INTO products (cid, name, SKU, price) VALUES(1, 'Apple MacBook','103001',1200);
INSERT INTO products (cid, name, SKU, price) VALUES(1, 'HP Laptop',    '106044', 480);
INSERT INTO products (cid, name, SKU, price) VALUES(1, 'Dell Laptop',  '109023', 399);
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'Iphone 5s',        '200101', 709);
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'Samsung Galaxy S4','208809', 488);
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'LG Optimus g',     '209937', 375);
INSERT INTO products (cid, name, SKU, price) VALUES(3, 'Sony DSC-RX100M','301211', 689);
INSERT INTO products (cid, name, SKU, price) VALUES(3, 'Canon EOS Rebel T3',  '304545', 449);
INSERT INTO products (cid, name, SKU, price) VALUES(3, 'Nikon D3100',  '308898', 520);
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'Xbox 360',  '405065', 249);
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'Nintendo Wii U ',  '407033', 430);
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'Nintendo Wii',  '408076', 232);
SELECT * FROM products order by id asc;


CREATE TABLE sales (
    id          SERIAL PRIMARY KEY,
    uid         INTEGER REFERENCES users (id) ON DELETE CASCADE,
    pid         INTEGER REFERENCES products (id) ON DELETE CASCADE,
    quantity    INTEGER NOT NULL,
    price       INTEGER NOT NULL
);
INSERT INTO sales (uid, pid, quantity,price) VALUES(3, 1 , 2, 1200);
INSERT INTO sales (uid, pid, quantity,price) VALUES(3, 2 , 1, 480);
INSERT INTO sales (uid, pid, quantity,price) VALUES(4, 10, 4, 249);
INSERT INTO sales (uid, pid, quantity,price) VALUES(5, 12, 2, 465);
INSERT INTO sales (uid, pid, quantity,price) VALUES(5, 9 , 5, 520);
INSERT INTO sales (uid, pid, quantity,price) VALUES(5, 5 , 3, 488);
INSERT INTO sales (uid, pid, quantity,price) VALUES(6, 10, 3, 249);
SELECT * FROM sales order by id desc;

CREATE TABLE agerange
(
  rangeid INTEGER NOT NULL,
  lower_limit INTEGER NOT NULL,
  upper_limit INTEGER NOT NULL,
  CONSTRAINT agerange_pkey PRIMARY KEY (rangeid)
);

INSERT INTO agerange(rangeid, lower_limit, upper_limit) VALUES (1, 12, 18);
INSERT INTO agerange(rangeid, lower_limit, upper_limit) VALUES (2, 18, 45);
INSERT INTO agerange(rangeid, lower_limit, upper_limit) VALUES (3, 45, 65);
INSERT INTO agerange(rangeid, lower_limit, upper_limit) VALUES (4, 65, 200);
SELECT * FROM agerange order by rangeid asc;

CREATE TABLE states
(
  id integer NOT NULL,
  name text NOT NULL,
  abbreviation text NULL
);

INSERT INTO states (id,name,abbreviation) VALUES ('1','Alabama','AL');
INSERT INTO states (id,name,abbreviation) VALUES ('2','Alaska','AK');
INSERT INTO states (id,name,abbreviation) VALUES ('3','Arizona','AZ');
INSERT INTO states (id,name,abbreviation) VALUES ('4','Arkansas','AR');
INSERT INTO states (id,name,abbreviation) VALUES ('5','California','CA');
INSERT INTO states (id,name,abbreviation) VALUES ('6','Colorado','CO');
INSERT INTO states (id,name,abbreviation) VALUES ('7','Connecticut','CT');
INSERT INTO states (id,name,abbreviation) VALUES ('8','Delaware','DE');
INSERT INTO states (id,name,abbreviation) VALUES ('9','District of Columbia','DC');
INSERT INTO states (id,name,abbreviation) VALUES ('10','Florida','FL');
INSERT INTO states (id,name,abbreviation) VALUES ('11','Georgia','GA');
INSERT INTO states (id,name,abbreviation) VALUES ('12','Hawaii','HI');
INSERT INTO states (id,name,abbreviation) VALUES ('13','Idaho','ID');
INSERT INTO states (id,name,abbreviation) VALUES ('14','Illinois','IL');
INSERT INTO states (id,name,abbreviation) VALUES ('15','Indiana','IN');
INSERT INTO states (id,name,abbreviation) VALUES ('16','Iowa','IA');
INSERT INTO states (id,name,abbreviation) VALUES ('17','Kansas','KS');
INSERT INTO states (id,name,abbreviation) VALUES ('18','Kentucky','KY');
INSERT INTO states (id,name,abbreviation) VALUES ('19','Louisiana','LA');
INSERT INTO states (id,name,abbreviation) VALUES ('20','Maine','ME');
INSERT INTO states (id,name,abbreviation) VALUES ('21','Maryland','MD');
INSERT INTO states (id,name,abbreviation) VALUES ('22','Massachusetts','MA');
INSERT INTO states (id,name,abbreviation) VALUES ('23','Michigan','MI');
INSERT INTO states (id,name,abbreviation) VALUES ('24','Minnesota','MN');
INSERT INTO states (id,name,abbreviation) VALUES ('25','Mississippi','MS');
INSERT INTO states (id,name,abbreviation) VALUES ('26','Missouri','MO');
INSERT INTO states (id,name,abbreviation) VALUES ('27','Montana','MT');
INSERT INTO states (id,name,abbreviation) VALUES ('28','Nebraska','NE');
INSERT INTO states (id,name,abbreviation) VALUES ('29','Nevada','NV');
INSERT INTO states (id,name,abbreviation) VALUES ('30','New Hampshire','NH');
INSERT INTO states (id,name,abbreviation) VALUES ('31','New Jersey','NJ');
INSERT INTO states (id,name,abbreviation) VALUES ('32','New Mexico','NM');
INSERT INTO states (id,name,abbreviation) VALUES ('33','New York','NY');
INSERT INTO states (id,name,abbreviation) VALUES ('34','North Carolina','NC');
INSERT INTO states (id,name,abbreviation) VALUES ('35','North Dakota','ND');
INSERT INTO states (id,name,abbreviation) VALUES ('36','Ohio','OH');
INSERT INTO states (id,name,abbreviation) VALUES ('37','Oklahoma','OK');
INSERT INTO states (id,name,abbreviation) VALUES ('38','Oregon','OR');
INSERT INTO states (id,name,abbreviation) VALUES ('39','Pennsylvania','PA');
INSERT INTO states (id,name,abbreviation) VALUES ('40','Rhode Island','RI');
INSERT INTO states (id,name,abbreviation) VALUES ('41','South Carolina','SC');
INSERT INTO states (id,name,abbreviation) VALUES ('42','South Dakota','SD');
INSERT INTO states (id,name,abbreviation) VALUES ('43','Tennessee','TN');
INSERT INTO states (id,name,abbreviation) VALUES ('44','Texas','TX');
INSERT INTO states (id,name,abbreviation) VALUES ('45','Utah','UT');
INSERT INTO states (id,name,abbreviation) VALUES ('46','Vermont','VT');
INSERT INTO states (id,name,abbreviation) VALUES ('47','Virginia','VA');
INSERT INTO states (id,name,abbreviation) VALUES ('48','Washington','WA');
INSERT INTO states (id,name,abbreviation) VALUES ('49','West Virginia','WV');
INSERT INTO states (id,name,abbreviation) VALUES ('50','Wisconsin','WI');
INSERT INTO states (id,name,abbreviation) VALUES ('51','Wyoming','WY');
SELECT * FROM states order by id asc;

CREATE TABLE pre_customers_cat
(
	uid integer NOT NULL,
	cid integer NOT NULL,
	sales integer NOT NULL,
	state text NOT NULL
);

CREATE TABLE pre_customers
(
	uid integer NOT NULL,
	sales integer NOT NULL,
	state text NOT NULL
);

CREATE TABLE pre_states
(
	state text NOT NULL,
	cid integer NOT NULL,
	sales integer NOT NULL
);

CREATE TABLE pre_products
(
	pid integer NOT NULL,
	state text NOT NULL,
	sales integer NOT NULL,
	cid integer NOT NULL
);

CREATE TABLE pre_customers_products
(
	uid integer NOT NULL,
	pid integer NOT NULL,
	sales integer NOT NULL
);

CREATE INDEX ON pre_customers_cat USING hash (uid);
CREATE INDEX ON pre_customers_cat USING btree (sales);
CREATE INDEX ON pre_customers USING hash (uid);
CREATE INDEX ON pre_customers USING btree (sales);
CREATE INDEX ON pre_states USING hash (state);
CREATE INDEX ON pre_states USING btree (sales);
CREATE INDEX ON pre_products USING hash (pid);
CREATE INDEX ON pre_products USING btree (sales);
CREATE INDEX ON pre_products USING hash (state);

-- TODO: do we need these two?
CREATE INDEX ON pre_customers_products USING hash (uid);
CREATE INDEX ON pre_customers_products USING hash (pid);
