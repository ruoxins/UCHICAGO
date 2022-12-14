/***********************************************
** File: Assignment2-PartB.sql
** Desc: Manipulating, Categorizing, Sorting and Grouping & Summarizing Data
** Author: Ruoxin Shi
** Date: 10/18/2021
************************************************/ 
######## QUESTION 1 ######## – { 10 Points }
# a) Show the list of databases.
SHOW databases;

# b) Select sakila database.
# select database
USE sakila;

# c) Show all tables in the sakila database.
SHOW tables;

# d) Show each of the columns along with their data types for the actor table.
DESCRIBE actor;

# e) Show the total number of records in the actor table.
SELECT COUNT(*)
FROM actor;

# f) What is the first name and last name of all the actors in the actor table ? 
SELECT first_name, last_name
FROM actor;


# ???? MIDDLE INITIAL
# g) Insert your first name (in first name column) and middle initial ( in the last name
# column ) into the actors table.
INSERT INTO `actor`
(`actor_id`, `first_name`, `last_name`, `last_update`)
VALUES 
(null, 'Ruoxin', 'S', DEFAULT);

# h) Update your middle initial with your last name (in last name column) in the actors
# table. 
UPDATE actor 
SET 
    last_name = 'Shi'
WHERE
    last_name = 'S';

# i) Delete the new record from the actor table where the first name and last name matches
# yours.
DELETE FROM actor 
WHERE
    first_name = 'Ruoxin'
    AND last_name = 'Shi';

# j) Create a table payment_type with the following specifications and appropriate data types
# Table Name : “Payment_type”
# Primary Key: "payment_type_id”
# Column: “Type”
# Insert following rows in to the table:
# 1, “Credit Card” ; 2, “Cash”; 3, “Paypal” ; 4 , “Cheque”
CREATE TABLE `Payment_type` (
  `payment_type_id` INT(10) NOT NULL,
  `type` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`payment_type_id`)
) ENGINE=INNODB DEFAULT CHARSET=LATIN1;

INSERT INTO `Payment_type`
(`payment_type_id`, `type`)
VALUES 
(1, 'Credit Card'),
(2, 'Cash'),
(3, 'Paypal'),
(4, 'Cheque');
#select * from Payment_type;

# k) Rename table payment_type to payment_types.
RENAME TABLE Payment_type TO payment_types;  

# l) Drop the table payment_types
DROP TABLE payment_types;


######## QUESTION 2 ######## – { 10 Points }
# a) List all the movies ( title & description ) that are rated PG-13 ?
# select * from film;
SELECT title, description
FROM film
WHERE rating = 'PG-13';



# b) List all movies that are either PG OR PG-13 using IN operator ?
SELECT *
FROM film
WHERE rating IN ('PG', 'PG-13');



# c) Report all payments greater than and equal to 2$ and Less than equal to 7$ ?
# Note : write 2 separate queries conditional operator and BETWEEN keyword
SELECT * 
FROM payment
WHERE amount >= 2 AND amount <= 7;

SELECT * 
FROM payment
WHERE amount BETWEEN 2 and 7;



# d) List all addresses that have phone number that contain digits 589. A separate query
# for phone numbers that start with 140, and a third query that ends with 589
# Note : write 3 different queries

# contain 589
SELECT 
	*
FROM
    address
WHERE
    phone LIKE '%589%';
    
# start with 140    
SELECT 
	*
FROM
    address
WHERE
    phone LIKE '140%';

# end with 589
SELECT 
	*
FROM
    address
WHERE
    phone LIKE '%589';


# e) List all staff members ( first name, last name, email ) whose password is NULL ?
SELECT
    first_name, last_name, email
FROM
    staff
WHERE
    password IS NULL;

# ????
# f) Select all films that have title names like ZOO and rental duration greater than or equal
# to 4
SELECT *
FROM film
WHERE title LIKE '%ZOO%' AND rental_duration >= 4;


# ????
# g) What is the cost of renting the movie ACADEMY DINOSAUR for 2 weeks ?
# Note : use of column alias and watch for rental_duration value
SELECT *, rental_rate/rental_duration * 14 as rate_per_2week
FROM film
WHERE title = 'ACADEMY DINOSAUR'; 
# The rental rate is 0.99 for 6 days.

# select * from film;


# h) List all unique districts where the customers, staff, and stores are located
# Note : check for NOT NULL values
SELECT DISTINCT district
FROM address
WHERE district is NOT NULL;


# i) List the top 10 newest customers across all stores based on customer_id 
SELECT 
    *
FROM
    customer
ORDER BY customer_id DESC
LIMIT 10;




######## QUESTION 3 ######## 
# a) Show total number of movies
SELECT COUNT(DISTINCT (film_id))
FROM film;

# b) What is the minimum payment received and max payment received across all
# transactions ? 
SELECT MIN(amount), MAX(amount)
FROM payment;


# ????
# c) Number of customers that rented movies between Feb-2005 & May-2005 ( based on
# paymentDate ). 
SELECT COUNT(customer_id)
FROM payment
WHERE payment_date BETWEEN '2005-02-01' AND '2005-05-31';

# select * from payment
# ORDER BY payment_date;

# d) List all movies where replacement_cost is greater than 15$ or rental_duration is
# between 6 & 10 days
SELECT *
FROM film
WHERE replacement_cost > 15 or (rental_duration BETWEEN 6 AND 10);



# e) What is the total amount spent by customers for movies in the year 2005 ?
SELECT SUM(amount)
FROM payment
WHERE payment_date BETWEEN '2005-01-01 00:00:00' AND '2005-12-31 23:59:59';


# f) What is the average replacement cost across all movies ? 
SELECT AVG(replacement_cost)
FROM film;


# g) What is the standard deviation of rental rate across all movies ?
SELECT STDDEV(rental_rate)
FROM film;


# h) What is the midrange of the rental duration for all movies 
SELECT MAX(rental_duration) + MIN(rental_duration) / 2 as midrange
FROM film;



######## QUESTION 4 ######## – { 10 Points }
# a) Customers sorted by first Name and last name in ascending order.
SELECT *
FROM customer
ORDER BY first_name, last_name ASC;

# b) Count of movies that are either G/NC-17/PG-13/PG/R grouped by rating.
SELECT rating, COUNT(film_id)
FROM film
GROUP BY rating;

# c) Number of addresses in each district.
SELECT district, COUNT(address_id)
FROM address
GROUP BY district;


# d) Find the movies where rental rate is greater than 1$ and order result set by descending
# order.
SELECT *
FROM film
WHERE rental_rate > 1
ORDER BY rental_rate DESC;

# e) Top 2 movies that are rated R with the highest replacement cost ?
SELECT *
FROM film
WHERE rating = 'R'
ORDER BY replacement_cost DESC
LIMIT 2;


# f) Find the most frequently occurring (mode) rental rate across products.
SELECT rental_rate, COUNT(*) as frequency
FROM film
GROUP BY rental_rate
ORDER BY frequency DESC
LIMIT 1;

# select * from film;

# ???? 
# g) Find the 2 longest movies with movie length greater than 50mins and which has
# commentaries as a special features.
SELECT *
FROM film
WHERE length > 50 and special_features LIKE '%commentaries%'
ORDER BY length DESC
LIMIT 2;

# h) List the years which has more than 2 movies released. 
SELECT release_year, COUNT(*)
FROM film
GROUP BY release_year
HAVING COUNT(*) > 2;
