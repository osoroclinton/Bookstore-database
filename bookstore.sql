-- step 1 create the database
-- drop database bookstore if it exists
DROP DATABASE IF EXISTS bookstore;
-- create database bookstore
CREATE DATABASE bookstore;

-- Step 2: Use the database
USE bookstore;

-- drop tables if they exist
DROP TABLE IF EXISTS order_history;
DROP TABLE IF EXISTS order_line;
DROP TABLE IF EXISTS cust_order;
DROP TABLE IF EXISTS shipping_method;
DROP TABLE IF EXISTS customer_address;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS address_status;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS book_author;
DROP TABLE IF EXISTS author;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS publisher;
DROP TABLE IF EXISTS book_language;
DROP TABLE IF EXISTS country;
DROP TABLE IF EXISTS order_status;

-- Step 3: Create tables starting with supporting tables
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_code VARCHAR(50)
);

CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(255)
);

CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(255)
);

CREATE TABLE country (
    country_id INT PRIMARY KEY,
    country_code VARCHAR(10),
    country_name VARCHAR(100)
);

CREATE TABLE address_status (
    status_id INT PRIMARY KEY,
    address_status VARCHAR(100)
);

CREATE TABLE shipping_method (
    method_id INT PRIMARY KEY,
    method_name VARCHAR(100),
    cost DECIMAL(10, 2)
);

CREATE TABLE order_status (
    status_id INT PRIMARY KEY,
    status_details VARCHAR(255)
);

-- Step 4: Create main tables

CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    isbn VARCHAR(50),
    publication_date DATE,
    language_id INT,
    publisher_id INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    phone BIGINT
);

CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street_no VARCHAR(20),
    street_name VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    status_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    shipping_method_id INT,
    shipping_address_id INT,
    order_total DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(method_id),
    FOREIGN KEY (shipping_address_id) REFERENCES address(address_id)
);

CREATE TABLE order_line (
    line_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    book_id INT,
    price DECIMAL(10, 2),
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    status_id INT,
    status_date DATE,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- Step 4: Create users and assign privileges (setting up user groups and roles)
-- Joel: Admin (Full privileges)
DROP USER IF EXISTS 'joel'@'%';
CREATE USER 'joel'@'%' IDENTIFIED BY 'Pass123!';
GRANT ALL PRIVILEGES ON bookstore.* TO 'joel'@'%';

-- Osoro: Sales Clerk (Can view books and insert customer/orders)
DROP USER IF EXISTS 'osoro'@'%';
CREATE USER 'osoro'@'%' IDENTIFIED BY 'osoch123!';
GRANT SELECT ON bookstore.book TO 'osoro'@'%';
GRANT SELECT, INSERT ON bookstore.customer TO 'osoro'@'%';
GRANT SELECT, INSERT ON bookstore.cust_order TO 'osoro'@'%';

-- George: Analyst (Read-only access to all tables)
DROP USER IF EXISTS 'george'@'%';
CREATE USER 'george'@'%' IDENTIFIED BY 'Gigo123!';
GRANT SELECT ON bookstore.* TO 'george'@'%';

-- Apply changes immediately
FLUSH PRIVILEGES;

-- step 6 insert data
-- Insert book languages
INSERT INTO book_language (language_code) VALUES 
('EN'), ('SW');

-- Insert publishers
INSERT INTO publisher (publisher_name) VALUES 
('Longhorn Publishers'), 
('East African Educational Publishers');

-- Insert authors
INSERT INTO author (author_name) VALUES 
('Ngugi wa Thiong\'o'), 
('Grace Ogot'), 
('Meja Mwangi'),
('Ali Mazrui'), 
('Margaret Ogola');

-- Insert books
INSERT INTO book (title, isbn, publication_date, language_id, publisher_id, price) VALUES
('Weep Not, Child', '9789966254831', '2003-06-15', 1, 1, 850.00),
('The River and The Source', '9789966465121', '2010-03-10', 1, 2, 950.00),
('Kill Me Quick', '9789966251298', '2006-08-01', 2, 1, 790.00),
('The Trial of Dedan Kimathi', '9789966468825', '2005-07-20', 1, 2, 880.00),
('Petals of Blood', '9789966258741', '2009-04-14', 1, 1, 900.00),
('I Swear by Apollo', '9789966467019', '2011-02-25', 1, 2, 770.00);

-- Link books to authors
INSERT INTO book_author (book_id, author_id) VALUES 
(1, 1), 
(2, 2), 
(3, 3),
(4, 1), 
(5, 1), 
(6, 5);

-- Insert countries
INSERT INTO country (country_id, country_code, country_name) VALUES 
(1, 'KE', 'Kenya');

-- Insert address statuses
INSERT INTO address_status (status_id, address_status) VALUES 
(1, 'Current'), 
(2, 'Previous');

-- Insert addresses
INSERT INTO address (street_no, street_name, city, postal_code, country_id) VALUES
('45', 'Kenyatta Avenue', 'Nairobi', '00100', 1),
('87', 'Moi Avenue', 'Mombasa', '80100', 1),
('12', 'Kisumu-Busia Road', 'Kisumu', '40100', 1),
('9', 'Ngong Road', 'Nairobi', '00505', 1),
('22', 'Luthuli Avenue', 'Nakuru', '20100', 1);

-- Insert customers
INSERT INTO customer (first_name, last_name, email, phone) VALUES 
('Mary', 'Wanjiku', 'mary.wanjiku@yahoo.com', 0722123456),
('James', 'Odhiambo', 'james.odhiambo@yahoo.com', 0711223344),
('Brian', 'Otieno', 'brian.otieno@gmail.com', 0722123000),
('Catherine', 'Njeri', 'catherine.njeri@hotmail.com', 0711555000);

-- Link customers to addresses
INSERT INTO customer_address (customer_id, address_id, status_id) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 4, 1),
(4, 5, 1);

-- Insert shipping methods
INSERT INTO shipping_method (method_id, method_name, cost) VALUES
(1, 'G4S Delivery', 250.00),
(2, 'Postal Parcel', 100.00);


-- Insert orders
INSERT INTO cust_order (order_id, customer_id, order_date, shipping_method_id, shipping_address_id, order_total) VALUES
(1, 1, '2024-12-01', 1, 1, 1100.00),
(2, 2, '2025-01-10', 2, 2, 950.00),
(3, 3, '2025-02-15', 1, 4, 880.00),
(4, 4, '2025-02-20', 2, 5, 900.00);

-- Insert order lines
INSERT INTO order_line (order_id, book_id, price, quantity) VALUES
(1, 1, 850.00, 1),
(1, 3, 790.00, 1),
(2, 2, 950.00, 1);

-- Insert order statuses
INSERT INTO order_status (status_id, status_details) VALUES 
(1, 'Pending'), 
(2, 'Shipped'), 
(3, 'Delivered');

-- Insert order history
INSERT INTO order_history (order_id, status_id, status_date) VALUES
(1, 1, '2024-12-01'),
(1, 2, '2024-12-03'),
(3, 1, '2025-02-15'),
(4, 1, '2025-02-20'),
(2, 1, '2025-01-10');