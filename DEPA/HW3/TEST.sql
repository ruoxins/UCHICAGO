select * from sakila_snowflake.fact_rental;

select rental_id, dollar_amount from sakila_snowflake.fact_rental where dollar_amount is null;


select * from sakila_snowflake.dim_film;

select * from sakila_snowflake.dim_actor;
delete from sakila_snowflake.dim_actor;

select * from dim_date;

select * from sakila_snowflake.dim_customer;
select * from sakila_snowflake.dim_location_address;
select * from sakila_snowflake.dim_location_city;

select r.rental_date_key, r.count_rentals, d.month
from sakila_snowflake.fact_rental as r
left join sakila_snowflake.dim_date as d on d.date_Id = r.rental_date_key
where d.date_id is not null;

select * from sakila.film;

select * from sakila.payment;

select * from sakila.actor;

select * from sakila_snowflake.dim_staff;


select sum(count_returns) from sakila_snowflake.fact_rental;
select sum(count_rentals) from sakila_snowflake.fact_rental;