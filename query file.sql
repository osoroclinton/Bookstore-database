-- test the database with queries
use bookstore;
-- query 1 List All Customers and Their Emails
SELECT customer_id, CONCAT(first_name, ' ', last_name) AS full_name, email
FROM customer;

-- query 2 Total Revenue Generated from Orders
SELECT SUM(order_total) AS total_revenue
FROM cust_order;

-- query 3 -- Get all books in English or Swahili
SELECT title, 'English' AS language
FROM book
JOIN book_language ON book.language_id = book_language.language_id
WHERE language_code = 'EN'

UNION

SELECT title, 'Swahili' AS language
FROM book
JOIN book_language ON book.language_id = book_language.language_id
WHERE language_code = 'SW';

-- query 4 Orders and Books Purchased
SELECT co.order_id, c.first_name AS customer, b.title AS book, ol.quantity, ol.price
FROM cust_order co
JOIN customer c ON co.customer_id = c.customer_id
JOIN order_line ol ON co.order_id = ol.order_id
JOIN book b ON ol.book_id = b.book_id;

-- query 5 List Customers and Their Current Addresses
SELECT c.first_name, c.last_name, a.street_no, a.street_name, a.city, a.postal_code
FROM customer c
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN address a ON ca.address_id = a.address_id
JOIN address_status s ON ca.status_id = s.status_id
WHERE s.address_status = 'Current';