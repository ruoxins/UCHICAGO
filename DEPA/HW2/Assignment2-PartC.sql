/***********************************************
** File: Assignment2-PartC.sql
** Desc: Combining Data, Nested Queries, Views and Indexes, Transforming Data
** Author: Ruoxin Shi
** Date: 10/20/2021
************************************************/
USE sakila;
######## QUESTION 1 ######## – { 20 Points }
# a) List the actors (firstName, lastName) who acted in more then 25 movies.
# Note: Also show the count of movies against each actor
SELECT a.first_name, a.last_name, COUNT(*) as count
FROM actor as a 
LEFT JOIN film_actor as fa ON a.actor_id = fa.actor_id
LEFT JOIN film as f ON fa.film_id = f.film_id
GROUP BY a.first_name, a.last_name
HAVING count > 25;


# b) List the actors who have worked in the German language movies.
# Note: Please execute the below SQL before answering this question. 
SET SQL_SAFE_UPDATES=0;
UPDATE film SET language_id=6 WHERE title LIKE "%ACADEMY%";

SELECT a.first_name, a.last_name, a.actor_id, l.name
FROM actor as a
LEFT JOIN film_actor as fa on a.actor_id = fa.actor_id
LEFT JOIN film as f on fa.film_id = f.film_id
LEFT JOIN language as l on l.language_id = f.language_id
WHERE l.name = "German";

# select * from language;

# c) List the actors who acted in horror movies.
# Note: Show the count of movies against each actor in the result set.
SELECT a.first_name, a.last_name, COUNT(f.title) as count
FROM actor as a
LEFT JOIN film_actor as fa on a.actor_id = fa.actor_id
LEFT JOIN film as f on fa.film_id = f.film_id
LEFT JOIN film_category as fc on f.film_id = fc.film_id
LEFT JOIN category as c on fc.category_id = c.category_id
WHERE c.name = "horror"
GROUP BY a.first_name, a.last_name;

# select * from category;



# d) List all customers who rented more than 3 horror movies.
SELECT c.first_name, c.last_name, COUNT(distinct(f.film_id)) as count
FROM customer as c
LEFT JOIN rental as r ON r.customer_id = c.customer_id
LEFT JOIN inventory as i ON r.inventory_id = i.inventory_id
LEFT JOIN film as f ON i.film_id = f.film_id
LEFT JOIN film_category as fc on f.film_id = fc.film_id
LEFT JOIN category as ca on fc.category_id = ca.category_id
WHERE ca.name = "horror"
GROUP BY c.first_name, c.last_name
HAVING count > 3;


# e) List all customers who rented the movie which starred SCARLETT BENING
SELECT distinct(c.customer_id), c.first_name, c.last_name
FROM customer as c
LEFT JOIN rental as r ON r.customer_id = c.customer_id
LEFT JOIN inventory as i ON r.inventory_id = i.inventory_id
LEFT JOIN film as f ON i.film_id = f.film_id
LEFT JOIN film_actor as fa ON f.film_id = fa.film_id
LEFT JOIN actor as a ON fa.actor_id = a.actor_id
WHERE a.first_name = "SCARLETT" and a.last_name = "BENING";


# f) Which customers residing at postal code 62703 rented movies that were
# Documentaries.
SELECT c.first_name, c.last_name, a.postal_code
FROM customer as c
LEFT JOIN rental as r ON r.customer_id = c.customer_id
LEFT JOIN inventory as i ON r.inventory_id = i.inventory_id
LEFT JOIN film as f ON i.film_id = f.film_id
LEFT JOIN film_category as fc on f.film_id = fc.film_id
LEFT JOIN category as ca on fc.category_id = ca.category_id
LEFT JOIN address as a on a.address_id = c.address_id
WHERE a.postal_code = "62703" and ca.name = "Documentary";

# g) Find all the addresses where the second address line is not empty (i.e., contains some
# text), and return these second addresses sorted.

# All the address2 are empty
SELECT *
FROM address
WHERE address2 IS NOT NULL and address2 <> '';

# h) How many films involve a “Crocodile” and a “Shark” based on film description ?
SELECT COUNT(f.title) as count
FROM film as f
LEFT JOIN film_text as ft ON ft.film_id = f.film_id
WHERE ft.description LIKE "%Crocodile%" and ft.description LIKE "%Shark%";



# i) List the actors who played in a film involving a “Crocodile” and a “Shark”, along with
# the release year of the movie, sorted by the actors’ last names.
SELECT f.title, a.first_name, a.last_name, f.release_year
FROM film as f
LEFT JOIN film_text as ft ON ft.film_id = f.film_id
LEFT JOIN film_actor as fa ON f.film_id = fa.film_id
LEFT JOIN actor as a ON fa.actor_id = a.actor_id
WHERE ft.description LIKE "%Crocodile%" and ft.description LIKE "%Shark%"
ORDER BY a.last_name;


# j) Find all the film categories in which there are between 55 and 65 films. Return the
# names of categories and the number of films per category, sorted from highest to lowest by
# the number of films.
SELECT ca.name, count(*) as count
FROM category as ca
LEFT JOIN film_category as fa ON fa.category_id = ca.category_id
LEFT JOIN film as f ON f.film_id = fa.film_id
GROUP BY ca.name
HAVING count BETWEEN 55 AND 65
ORDER BY count DESC;


# k) In which of the film categories is the average difference between the film replacement
# cost and the rental rate larger than 17$?
SELECT ca.name, ((SUM(f.replacement_cost) - SUM(f.rental_rate)) / COUNT(*)) as avg_difference
FROM category as ca
LEFT JOIN film_category as fa ON fa.category_id = ca.category_id
LEFT JOIN film as f ON f.film_id = fa.film_id
GROUP BY ca.name
HAVING avg_difference > 17;


# l) Many DVD stores produce a daily list of overdue rentals so that customers can be
# contacted and asked to return their overdue DVDs. To create such a list, search the rental
# table for films with a return date that is NULL and where the rental date is further in the
# past than the rental duration specified in the film table. If so, the film is overdue and we
# should produce the name of the film along with the customer name and phone number.
SELECT r.return_date, r.rental_date, f.rental_duration, f.title, c.first_name, c.last_name, a.phone
FROM rental as r
LEFT JOIN inventory as i ON i.inventory_id = r.inventory_id
LEFT JOIN film as f ON f.film_id = i.film_id
LEFT JOIN customer as c ON r.customer_id = c.customer_id
LEFT JOIN address as a ON a.address_id = c.address_id
WHERE r.return_date IS NULL and DATEDIFF(CURRENT_DATE(), r.rental_date) > f.rental_duration;
 



# m) Find the list of all customers and staff given a store id
# Note : use a set operator, do not remove duplicates
(SELECT s.store_id, c.first_name, c.last_name, "customer" as label
FROM store as s
LEFT JOIN customer as c on s.store_id = c.store_id) UNION ALL
(SELECT s.store_id, stf.first_name, stf.last_name, "staff" as label
FROM store as s
LEFT JOIN staff as stf on s.store_id = stf.store_id);




######## QUESTION 2 ######## – { 10 Points }
# a) List actors and customers whose first name is the same as the first name of the actor
# with ID 8.
(SELECT a.actor_id as id, a.first_name, a.last_name
FROM actor as a
WHERE a.first_name = (SELECT first_name FROM actor WHERE actor_id = 8))
UNION ALL
(SELECT c.customer_id as id, c.first_name, c.last_name
FROM customer as c
WHERE c.first_name = (SELECT first_name FROM actor WHERE actor_id = 8));


# b) List customers and payment amounts, with payments greater than average the
# payment amount 
SELECT c.first_name, c.last_name, p.amount
FROM customer as c
LEFT JOIN payment as p ON c.customer_id = p.customer_id
WHERE p.amount > (SELECT AVG(amount) FROM payment);


# c) List customers who have rented movies at least once
# Note: use IN clause
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (SELECT r.customer_id FROM rental as r);

# d) Find the floor of the maximum, minimum and average payment amount
SELECT FLOOR(MAX(amount)), FLOOR(MIN(amount)), FLOOR(AVG(amount))
FROM payment;


######## QUESTION 3 ######## – { 5 Points }
# a) Create a view called actors_portfolio which contains information about actors and
# films ( including titles and category).
DROP view actors_portfolio;
CREATE VIEW actors_portfolio AS
	SELECT a.actor_id, a.first_name, a.last_name, f.title, c.name as category 
	FROM actor as a
	LEFT JOIN film_actor as fa ON a.actor_id = fa.actor_id
	LEFT JOIN film as f ON fa.film_id = f.film_id
	LEFT JOIN film_category as fc ON fc.film_id = f.film_id
	LEFT JOIN category as c ON fc.category_id = c.category_id;

select * from actors_portfolio;
# b) Describe the structure of the view and query the view to get information on the actor
# ADAM GRANT
DESCRIBE actors_portfolio;

SELECT *
FROM actors_portfolio
WHERE first_name = "ADAM" AND last_name = "GRANT";


# ???  we cannot insert new value into a view. We can only update the base table.
# c) Insert a new movie titled Data Hero in Sci-Fi Category starring ADAM GRANT
# Note: this is feasible
INSERT INTO actors_portfolio(actor_id, first_name, last_name, title, category)
values(71, 'ADAM','GRANT', 'Data Hero', 'Sci-Fi');



######## QUESTION 4 ######## – { 5 Points }
# a) Extract the street number ( characters 1 through 4 ) from customer addressLine1
# Note: this is a compound query
SELECT 
SUBSTRING(
    a.address, 
    1,
    LOCATE(' ', address) - 1
) AS street_number, a.address
FROM address as a
WHERE a.address_id IN (SELECT c.address_id FROM customer as c);


# b) Find out actors whose last name starts with character A, B or C.
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name REGEXP '^(A|B|C)';


# c) Find film titles that contains exactly 10 characters
SELECT title
FROM film
WHERE title REGEXP '^.{10}$';


# d) Format a payment_date using the following format e.g "22/1/2016"
SELECT payment_id, DATE_FORMAT(payment_date, '%d/%m/%Y') AS 'DD/MM/YYYY'
FROM payment;


# e) Find the number of days between two date values rental_date & return_date
SELECT *, DATEDIFF(return_date, rental_date) AS numberOfDays
FROM rental;


######## QUESTION 5 ######## – { 20 Points }
# Provide 5 additional queries, data visualizations and indicate the business use
# cases/insights they address. Please refer to the in class exercises relating to Python Jupyter
# Notebook with the SQL/Plotly code
# Note: Insights should not be a flavor of the previously addressed queries within
# Assignment 2. 


# count the rental times for each category of film
# To see what kind of movie is most popular
SELECT c.name, COUNT(*)
FROM rental as r
LEFT JOIN inventory as i on i.inventory_id = r.inventory_id
LEFT JOIN film as f on f.film_id = i.film_id
LEFT JOIN film_category as fc on fc.film_id = f.film_id
LEFT JOIN category as c on fc.category_id = c.category_id
GROUP BY c.name;



# check the number of customers from each country
SELECT count(*) as count, co.country
FROM customer as c
LEFT JOIN address as a ON c.address_id = a.address_id
LEFT JOIN city ON city.city_id = c.customer_id
LEFT JOIN country as co ON city.country_id = co.country_id
GROUP BY co.country
ORDER BY count DESC;

select distinct(cus.customer_id), cus.first_name, cus.last_name, c.city, co.country
FROM customer as cus
LEFT JOIN address as a on cus.address_id = a.address_id
LEFT JOIN city as c on a.city_id = c.city_id
LEFT JOIN country as co ON c.country_id = co.country_id;


# how many times each actor's movie has been rented?
SELECT a.actor_id, count(*) as count, CONCAT(a.first_name, ' ', a.last_name) AS name  #, f.title, c.name
FROM actor as a
LEFT JOIN film_actor as fa ON fa.actor_id = a.actor_id
LEFT JOIN film as f ON f.film_id = fa.film_id
LEFT JOIN film_category as fc ON fc.film_id = f.film_id
LEFT JOIN category as c ON c.category_id = fc.category_id
GROUP BY a.actor_id
ORDER BY count DESC;


SELECT f.title, count(*) as count
FROM film as f
LEFT JOIN inventory as i on f.film_id = i.film_id
LEFT JOIN rental as r on i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY count DESC;

# calculate the avg rental rate of each film category
SELECT c.name, AVG(f.rental_rate) as avg_rental_rate
FROM film as f
LEFT JOIN film_category as fc on f.film_id = fc.film_id
LEFT JOIN category as c on c.category_id = fc.category_id
GROUP BY c.name
ORDER BY avg_rental_rate DESC;

# 
SELECT c.first_name, c.last_name, r.rental_id, f.rating, co.country
FROM customer as c
LEFT JOIN address as a ON c.address_id = a.address_id
LEFT JOIN city ON city.city_id = c.customer_id
LEFT JOIN country as co ON city.country_id = co.country_id
LEFT JOIN rental as r ON r.customer_id = c.customer_id
LEFT JOIN inventory as i ON i.inventory_id = r.inventory_id
LEFT JOIN film as f on f.film_id = i.film_id;


SELECT f.rating, COUNT(DISTINCT(r.rental_id)) as count
FROM film as f
LEFT JOIN inventory as i on f.film_id = i.film_id
LEFT JOIN rental as r on i.inventory_id = r.inventory_id
GROUP BY f.rating;


select count(*)
from rental;



# Check the influnce of special feature "Behind the Scenes" on rental count
DROP VIEW IF EXISTS BehindTheScenes;
DROP VIEW IF EXISTS NoBehindTheScenes;
DROP VIEW IF EXISTS Commentaries;
DROP VIEW IF EXISTS NoCommentaries;
DROP VIEW IF EXISTS Trailers;
DROP VIEW IF EXISTS NoTrailers;

CREATE VIEW Commentaries AS
SELECT f.title, f.special_features, COUNT(*) as count
FROM film as f
LEFT JOIN inventory as i ON i.film_id = f.film_id
LEFT JOIN rental as r ON r.inventory_id = i.inventory_id
WHERE special_features LIKE "%commentaries%"
GROUP BY f.title
ORDER BY count DESC;

CREATE VIEW NoCommentaries AS
SELECT f.title, f.special_features, COUNT(*) as count
FROM film as f
LEFT JOIN inventory as i ON i.film_id = f.film_id
LEFT JOIN rental as r ON r.inventory_id = i.inventory_id
WHERE special_features NOT LIKE "%commentaries%"
GROUP BY f.title
ORDER BY count DESC;

CREATE VIEW Trailers AS
SELECT f.title, f.special_features, COUNT(*) as count
FROM film as f
LEFT JOIN inventory as i ON i.film_id = f.film_id
LEFT JOIN rental as r ON r.inventory_id = i.inventory_id
WHERE special_features LIKE "%trailers%"
GROUP BY f.title
ORDER BY count DESC;

CREATE VIEW NoTrailers AS
SELECT f.title, f.special_features, COUNT(*) as count
FROM film as f
LEFT JOIN inventory as i ON i.film_id = f.film_id
LEFT JOIN rental as r ON r.inventory_id = i.inventory_id
WHERE special_features NOT LIKE "%trailers%"
GROUP BY f.title
ORDER BY count DESC;

CREATE VIEW BehindTheScenes AS
SELECT f.title, f.special_features, COUNT(*) as count
FROM film as f
LEFT JOIN inventory as i ON i.film_id = f.film_id
LEFT JOIN rental as r ON r.inventory_id = i.inventory_id
WHERE special_features LIKE "%Behind the Scenes%"
GROUP BY f.title
ORDER BY count DESC;

CREATE VIEW NoBehindTheScenes AS
SELECT f.title, f.special_features, COUNT(*) as count
FROM film as f
LEFT JOIN inventory as i ON i.film_id = f.film_id
LEFT JOIN rental as r ON r.inventory_id = i.inventory_id
WHERE special_features NOT LIKE "%Behind the Scenes%"
GROUP BY f.title
ORDER BY count DESC;


(SELECT "BehindTheScenes" as label, AVG(count)
FROM BehindTheScenes)
UNION ALL
(SELECT "NoBehindTheScenes" as label, AVG(count)
FROM NoBehindTheScenes)
UNION ALL
(SELECT "Commentaries" as label, AVG(count)
FROM Commentaries)
UNION ALL
(SELECT "NoCommentaries" as label, AVG(count)
FROM NoCommentaries)
UNION ALL
(SELECT "Trailers" as label, AVG(count)
FROM Trailers)
UNION ALL
(SELECT "NoTrailers" as label, AVG(count)
FROM NoTrailers);