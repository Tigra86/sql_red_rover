-- Lesson #5 Group by, Union, Subquery

-- --------------- Homework#4 ---------------------	
-- write sql for #6, 8, 9, 10, 11, 14, 16, 17, 21

-- 6.which vendor sells 1966 Shelby Cobra?
SELECT prod.productVendor, prod.productName
FROM classicmodels.products prod
WHERE prod.productName LIKE '%1966 Shelby Cobra%';

-- 8.which product is the most and least expensive?
SELECT msrp as mostexp, productName 
FROM classicmodels.products
ORDER BY msrp desc
LIMIT 1; 

/*SELECT max(msrp) as mostexp, min(msrp) as leastexp
FROM classicmodels.products ;*/

SELECT msrp as leastexp, productName 
FROM classicmodels.products
ORDER BY msrp 
LIMIT 1;

-- 9.which product has the most quantityInStock?
SELECT productName, quantityInStock  -- select *
FROM classicmodels.products
ORDER BY quantityInStock desc
LIMIT 1;

-- 10.list all products that have quantity in stock less than 20
SELECT productName, quantityInStock
FROM classicmodels.products
WHERE quantityInStock < 20;

-- 11.which customer has the highest and lowest credit limit?
SELECT customerNumber, creditLimit as highestLimit
FROM classicmodels.customers
ORDER BY creditlimit desc
LIMIT 1;

SELECT customerNumber, creditLimit as lowestLimit
FROM classicmodels.customers
ORDER BY creditlimit 
LIMIT 1;

-- 14
-- #1 customers in what city are the most profitable to the company? -- based on highest single payment
SELECT c.city, c.customerNumber, p.amount as payedAmount
FROM classicmodels.customers c
JOIN classicmodels.payments p ON c.customerNumber = p.customerNumber 
ORDER BY p.amount desc
LIMIT 1;

-- 16
-- #1 who is the best customer? --based on single payment
SELECT c.customerName as BestCustomer, p.amount as amountPayed
FROM classicmodels.payments p
JOIN classicmodels.customers c ON p.customerNumber = c.customerNumber
ORDER BY amount desc
LIMIT 1;

-- 17
-- customers without payment
SELECT c.customerNumber, c.customerName, p.amount
FROM classicmodels.customers c
LEFT JOIN classicmodels.payments p ON c.customerNumber = p.customerNumber
WHERE p.amount is Null;

-- 21
-- list all employees by their (full name: first + last) in alpabetical order
SELECT
CONCAT(lastName, ' ', firstName) as fullName
FROM classicmodels.employees
ORDER BY fullName;

-- Part 2
-- find all information (query each table seporately for book_id = 252)
select * from library_simple.book c where id =252;
select * from library_simple.author_has_book b where book_id = 252;
select * from library_simple.author a where id in (750,770,794);
select * from library_simple.copy f where book_id = 252;
select * from library_simple.issuance g where copy_id in (182,774,1024);
select * from library_simple.reader h where id in (170,76,91);
select * from library_simple.category_has_book d where book_id = 252;
select * from library_simple.category e where id in (46,142);


-- Which books did Van Parks write?
select a.id, a.first_name, a.last_name,
b.author_id, b.book_id, 
c.id, c.ISBN, c.name, c.page_num, c.pub_year
from library_simple.author a
join library_simple.author_has_book	b
on a.id = b.author_id
join library_simple.book c 
on b.book_id = c.id
where a.first_name = 'Van' and a.last_name = 'Parks';

-- Which books where published in 2003?
select a.id, a.first_name, a.last_name,
b.author_id, b.book_id, 
c.id, c.ISBN, c.name, c.page_num, c.pub_year
from library_simple.author a
join library_simple.author_has_book	b
on a.id = b.author_id
join library_simple.book c 
on b.book_id = c.id
where c.pub_year = '2003';

select * from library_simple.book c 
where c.pub_year = '2003';
-- ----------------- end Homework #4 ---------------------

-- Lesson #5
-- GROUP BY (most common): COUNT, SUM, MAX, MIN, AVG
-- --------------- customer table ---------------------
select * from  classicmodels.customers;

-- general analyses	(record counts, count of distinct values, min/max/avg)
SELECT COUNT(*) as Customer_Cnt, COUNT(distinct country), COUNT(distinct city), 
MAX(creditLimit), MIN(creditLimit), AVG(creditLimit)
FROM classicmodels.customers;

-- analysis by country
SELECT country, COUNT(*) as Customer_Cnt, COUNT(distinct city), 
MAX(creditLimit), MIN(creditLimit), AVG(creditLimit)
FROM classicmodels.customers
GROUP BY country;

-- --------------- employee table ----------------- 
-- general analyses	(record count, count of distinct values, min/max/avg)
SELECT COUNT(*) as Employee_Cnt, COUNT(distinct jobTitle)
FROM classicmodels.employees;

-- by job title
SELECT jobTitle, COUNT(*) as Employee_Cnt
FROM classicmodels.employees
GROUP BY jobTitle;

-- --------------- offices table ----------------- 
select * from classicmodels.offices;
-- general analyses	(record count, count of distinct values, min/max/avg)
SELECT COUNT(officeCode) as Offices_Cnt, COUNT(distinct city), COUNT(distinct country) 
FROM classicmodels.offices;

-- by country
SELECT country, COUNT(officeCode) as Offices_Cnt, COUNT(distinct city)
FROM classicmodels.offices
GROUP BY country;

-- --------------- products table ----------------- 
-- general analyses	(record count, count of distinct values, min/max/avg)
SELECT COUNT(productCode) as Product_Cnt, COUNT(distinct productLine),
MIN(buyPrice), MAX(buyPrice)
FROM classicmodels.products;
 
-- by productLine
SELECT productLine, COUNT(productCode) as Product_Cnt, 
MIN(buyPrice), MAX(buyPrice), AVG(buyPrice)
FROM classicmodels.products 
GROUP BY productLine;


-- ---------------  UNION vs UNION ALL ---------------------	
-- doesn't allow dups
select city
from classicmodels.customers
UNION 
select city
from classicmodels.customers
ORDER BY city;

-- allows dups
select city
from classicmodels.customers
UNION ALL
select city
from classicmodels.customers
ORDER BY city;

-- union can be from different DBs
-- 102 
select  'classicmodels' as db,  city -- 122
from classicmodels.customers
-- where city = 'San Diego'
UNION 
select  'mywork' as db,  city -- 7
from mywork.dept
-- where city = 'San Diego'
ORDER BY city;


-- 101 with distinct, why?
select  distinct 'classicmodels' as db,   city -- 122
from classicmodels.customers
-- where city = 'San Diego'
UNION 
select  distinct 'mywork' as db,  city -- 7
from mywork.dept
-- where city = 'San Diego'
ORDER BY city;

-- 102 with distinct, why?
select   'classicmodels' as db,  city -- 122
from classicmodels.customers
-- where city = 'San Diego'
UNION 
select   'mywork' as db,  city -- 7
from mywork.dept
-- where city = 'San Diego'
ORDER BY city;


-- 100
select  city
from classicmodels.customers
UNION 
select  city
from mywork.dept
ORDER BY city;

-- 129
select  city
from classicmodels.customers
UNION ALL
select  city
from mywork.dept
ORDER BY city;

-- UNION can be used many times
-- 9 records
select customerNumber, customerName, city
from classicmodels.customers
where city = 'San Francisco'
UNION
select customerNumber, customerName, city
from classicmodels.customers
where city = 'NYC'
UNION
select customerNumber, customerName, city
from classicmodels.customers
where city = 'Boston';
-- ----------------------------------------
-- SUBQUERY #1
SELECT COUNT(*) FROM
(select customerNumber, customerName, city
from classicmodels.customers
where city = 'San Francisco'
UNION
select customerNumber, customerName, city
from classicmodels.customers
where city = 'NYC'
UNION
select customerNumber, customerName, city
from classicmodels.customers
where city = 'Boston')as a;

-- same as
-- SELECT COUNT(*) FROM  classicmodels.customers where city in ('San Francisco','NYC', 'Boston')

-- SUBQUERY #2
-- show all info on customers who spent over 70K
select customerNumber, customerName, city, state, country
from classicmodels.customers
where customerNumber in 
(select customerNumber from classicmodels.payments 
group by customerNumber
having sum(amount) >70000);

-- this is why aggregation is important
select * from classicmodels.payments where customerNumber = 112;
select sum(amount) from classicmodels.payments where customerNumber = 112;

-- HAVING (like where in group by)
-- show all customers with payments >$70,000
-- 56
select customerNumber, sum(amount) 
from classicmodels.payments 
group by customerNumber
having sum(amount) >70000
order by sum(amount);

-- same but with alias
select customerNumber, sum(amount) as sum_amt
from classicmodels.payments 
group by customerNumber
having sum_amt >70000
order by sum_amt;

-- verify if agreggation was correct for one customer
select customerNumber, amount 
from classicmodels.payments 
where customerNumber = 202;

-- Homework #5
-- Part 1
-- Group By  Example by Animation: https://dataschool.com/how-to-teach-people-sql/how-sql-aggregations-work/
-- Classicmodels Database 
--  1.use union: show products with buyPrice > 100 and <200
--  2.use subquery: show all customer names with employees in San Francisco office
--  3.use subquery: based on previous query add count(*) to show total of employees in San Francisco office 

-- Part 2
-- Classicmodels Database - Keep working on these queries
-- write sql for #1,2,3,4,5,7
-- 1.how many vendors, product lines, and products exist in the database?
-- 2.what is the average price (buy price, MSRP) per vendor?
-- 3.what is the average price (buy price, MSRP) per customer?
-- 4.what product was sold the most?
-- 5.how much money was made between buyPrice and MSRP?
-- 7.which vendor sells more products?

-- Part 3
-- Library Simple db - Finish 
-- 1.Join all tables and find all release dates for book 'Dog With Money'