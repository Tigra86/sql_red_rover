-- Homework #2
-- Work with classicmodels database and write these queries below
-- Save your work in your SQL forlder Homework2.sql

-- show all customers in Australia
select * 
from classicmodels.customers 
where country = 'Australia';

-- show First and Last name of customers in Melbourne
select contactFirstName, contactLastName, city 
from classicmodels.customers 
where city = 'Melbourne';

-- show all customers with Credit Limit over $200,000
select * 
from classicmodels.customers 
where creditLimit > 200000;

-- who is the president of the company?
select * 
from classicmodels.employees
where jobTitle like '%president%';

-- how many Sales Reps are in the company?
select count(*) 
from classicmodels.employees
where jobTitle like '%sales%rep%';

-- show payments in descending order
select * 
from classicmodels.payments
order by amount desc;

-- what was the check# for the payment done on December 17th 2004
select checkNumber, paymentDate 
from classicmodels.payments 
where paymentDate = '2004-12-17'; 

-- show product line with the word 'realistic' in the description
select productLine, textDescription 
from classicmodels.productlines
where textDescription like '% realistic %';

-- show product name for vendor 'Unimax Art Galleries'
select productName, productVendor 
from classicmodels.products
where productVendor like '%Unimax Art Galleries%';

-- what is the customer number for the highest amount of payment
select customerNumber, amount
from classicmodels.payments
order by amount desc
limit 1;