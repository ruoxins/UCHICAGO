/***********************************************
** DATA ENGINEERING PLATFORMS (MSCA 31012)
** File: OnPremiseSQLExercises.sql
** Desc: Example of an OnPremise Solution
** Auth: Shreenidhi Bharadwaj
** Date: 03/02/2019
** Ref : http://www.mysqltutorial.org/
** ALL RIGHTS RESERVED | DO NOT DISTRIBUTE
************************************************/

# Staring from the 3rd highest credit limit, get the next 5 customers
SELECT 
    contactLastname,
    contactFirstname,
    customerNumber,
    state,
    city,
    creditLimit
FROM
    customers
ORDER BY creditlimit DESC
LIMIT 5 OFFSET 3;


######### SUBSTRING - extracts part of the string ##########
SELECT 
    customerNumber,
    addressLine1,
    # extract the street number 
    substring(addressLine1,1,4) AS streetNumber,
	# extract all characters from position 5 till end of string
	substring(addressLine1,5) AS streetName1,
	substring(addressLine1 FROM 5) AS streetName2,
	# extract all characters from position -10 for length 6
    substring(addressLine1, -10, 6) AS streetName3,
    substring(addressLine1 FROM -10 for 6) AS streetName4
FROM
    customers
WHERE
    country = 'USA';
