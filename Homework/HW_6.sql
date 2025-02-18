-- Homework#6 Part 1 - Answers to 24 questions - classicmodels database
select * from classicmodels.customers; 
select * from classicmodels.employees;
select * from classicmodels.offices;
select * from classicmodels.payments;
select * from classicmodels.orderdetails;
select * from classicmodels.orders;
select * from classicmodels.productlines;
select * from classicmodels.products;

select count(*) from classicmodels.customers;-- 122
select count(*) from classicmodels.employees; -- 23
select count(*) from classicmodels.offices; -- 7
select count(*) from classicmodels.payments; -- 273
select count(*) from classicmodels.orderdetails; -- 2996
select count(*) from classicmodels.orders; -- 326
select count(*) from classicmodels.productlines; -- 7
select count(*) from classicmodels.products; -- 110


-- 1.how many vendors, product lines, and products exist in the database?
SELECT
	COUNT(distinct ProductVendor) as Vendors_count,
	COUNT(distinct ProductLine) as Product_lines_count,
	COUNT(distinct productCode) as Products_count
FROM classicmodels.products;


-- 2.what is the average price (buy price, MSRP) per product vendor?
SELECT
	productVendor,
    AVG (buyPrice) as AvgPrice,
    AVG (MSRP) as AvgMSRP
FROM classicmodels.products
GROUP BY productVendor;    


-- 3.what is the average price (buy price, MSRP) per customer?
SELECT
orders.customerNumber, AVG(det.priceEach) as AvgPrice, AVG(prod.buyPrice) as AvgBuyPrice, AVG(prod.MSRP) as AvgMSRP 
FROM classicmodels.orders orders 
JOIN classicmodels.orderdetails det on det.orderNumber = orders.orderNumber
JOIN classicmodels.products prod on prod.productCode = det.productCode
GROUP BY orders.customerNumber
ORDER BY orders.customerNumber;

-- chat GPT (mysql classicmodels database  what is the average price (buy price, MSRP) per customer?)
SELECT c.customerNumber,
       c.customerName,
       AVG(od.priceEach) AS averageBuyPrice,
       AVG(p.MSRP) AS averageMSRP
FROM classicmodels.customers c
JOIN classicmodels.orders o ON c.customerNumber = o.customerNumber
JOIN classicmodels.orderdetails od ON o.orderNumber = od.orderNumber
JOIN classicmodels.products p ON od.productCode = p.productCode
GROUP BY c.customerNumber, c.customerName;

-- 4.Pay Attention!!! which fields: productCode or quatityOrdered? quatityOrdered is correct
-- what product was sold the most?
SELECT prod.productName,
COUNT(prod.productCode) as prod_cnt, 
SUM(det.quantityOrdered) as quantity_ordered_sum,
MAX(det.quantityOrdered) as order_cnt -- select *
FROM classicmodels.orderdetails det
JOIN classicmodels.products prod ON det.productCode = prod.productCode
GROUP BY prod.productCode
ORDER BY prod_cnt DESC -- order_cnt DESC 
LIMIT 1;


-- 5.how much money was made between buyPrice and MSRP?
-- wrong!
SELECT 
-- msrp, buyPrice, (msrp - buyPrice)difference
SUM(msrp - buyPrice) as moneyMade, SUM(msrp)- SUM(buyPrice) as difference
-- select * 
FROM classicmodels.products;

-- correct   
SELECT SUM(prod.msrp * det.quantityOrdered) as msrp_sales, 
SUM(prod.buyPrice * det.quantityOrdered) as buyPrice_sales,
SUM(prod.msrp * det.quantityOrdered) - SUM(prod.buyPrice * det.quantityOrdered) as difference_in_sales
FROM classicmodels.products prod
JOIN classicmodels.orderdetails det on prod.productCode = det.productCode;

-- 6.which vendor sells 1966 Shelby Cobra?
SELECT prod.productVendor, prod.productName
FROM classicmodels.products prod
WHERE prod.productName LIKE '1966 Shelby Cobra%';

-- 7.which vendor sells more products?
SELECT prod.productVendor, SUM(det.quantityOrdered) as quantity, count(det.productcode) as quantity2
FROM classicmodels.products prod
JOIN classicmodels.orderdetails det on prod.productCode = det.productCode
GROUP BY prod.productVendor
ORDER BY quantity desc
LIMIT 1;

-- 8.which product is the most and least expensive?
(SELECT msrp as mostexp, productName 
FROM classicmodels.products
ORDER BY msrp desc
LIMIT 1)
UNION
(SELECT msrp as leastexp, productName 
FROM classicmodels.products
ORDER BY msrp 
LIMIT 1);

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
(SELECT customerNumber, creditLimit as highestLimit
FROM classicmodels.customers
ORDER BY creditlimit desc
LIMIT 1)
UNION
(SELECT customerNumber, creditLimit as lowestLimit
FROM classicmodels.customers
ORDER BY creditlimit
LIMIT 1);

-- 12.rank customers by credit limit
select customerNumber, creditLimit,
RANK() OVER (ORDER BY creditLimit DESC) as credlimit
from classicmodels.customers;

-- 13
-- #1 list the most sold product by city
-- WITH is used for CTE (Common Table Expression)
WITH a as (
SELECT c.City, od.productCode, sum(quantityOrdered) as quantitySold,
(ROW_NUMBER() OVER (PARTITION BY c.City ORDER BY sum(quantityOrdered) DESC)) as rowNum
FROM classicmodels.orderDetails od
JOIN classicmodels.orders o on o.orderNumber = od.orderNumber
JOIN classicmodels.customers c on c.customerNumber = o.customerNumber
GROUP BY c.City, od.productCode
ORDER BY quantitySold desc
)  
SELECT a.City, a.productCode, a.quantitySold
FROM a
WHERE rowNum = 1;

-- #2 list the most sold product by city
select * from (
select  c.city, p.productname, SUM(od.quantityOrdered), COUNT(p.productcode)
,RANK() OVER (PARTITION BY c.city ORDER BY sum(od.quantityOrdered) DESC)  as myrank
from -- classicmodels.offices oc 
-- join classicmodels.employees e on oc.officecode=e.officecode
-- join
 classicmodels.customers c -- on c.salesrepemployeenumber=e.employeenumber
join classicmodels.orders o on o.customernumber=c.customernumber
join classicmodels.orderdetails od on o.ordernumber=od.ordernumber
join classicmodels.products p on p.productcode=od.productcode
group by  c.city, p.productname
order by SUM(od.quantityOrdered) desc
) a
where myrank = 1 ;

-- 14
-- #1 customers in what city are the most profitable to the company?
SELECT c.city, p.amount as payedAmount
FROM classicmodels.customers c
JOIN classicmodels.payments p ON c.customerNumber = p.customerNumber 
ORDER BY p.amount desc
LIMIT 1;

-- #2
select  c.city, sum(quantityordered*priceeach) as revenue 
from classicmodels.customers c 
join classicmodels.orders o on c.customernumber=o.customernumber
join classicmodels.orderdetails od on o.ordernumber=od.ordernumber
group by c.city 
order by revenue desc 
limit 1;

-- #3 ChatGPT (mysql classicmodels database customers in what city are the most profitable to the company?)
SELECT c.city, SUM((p.MSRP - p.buyPrice) * od.quantityOrdered) AS totalProfit
FROM classicmodels.customers c
JOIN classicmodels.orders o ON c.customerNumber = o.customerNumber
JOIN classicmodels.orderdetails od ON o.orderNumber = od.orderNumber
JOIN classicmodels.products p ON od.productCode = p.productCode
GROUP BY c.city
ORDER BY totalProfit DESC
LIMIT 1;

-- 15 what is the average number of orders per customer?
-- #1 -- 3.3265
SELECT (COUNT(distinct orderNumber)/COUNT(distinct customerNumber)) as avgPerCust
FROM classicmodels.orders;

-- #2 -- by quantity ordered 35.2190
select -- c.customername, 
AVG(quantityordered) 
from classicmodels.customers c 
join classicmodels.orders o on c.customernumber=o.customernumber
join classicmodels.orderdetails od on o.ordernumber=od.ordernumber;
-- group by c.customername
-- order by avg(quantityordered) desc;

-- #3 ChatGPT (classicmodels database what is the average number of orders per customer?)
-- 2.6721
SELECT AVG(order_count) AS average_orders_per_customer
FROM (
    SELECT c.customerNumber, COUNT(o.orderNumber) AS order_count
    FROM classicmodels.customers c
    LEFT JOIN classicmodels.orders o ON c.customerNumber = o.customerNumber
    GROUP BY c.customerNumber
) AS order_counts;

-- 16
-- #1  who is the best customer?
-- wrong
SELECT c.customerName as BestCustomer, p.amount as amountPayed
FROM classicmodels.payments p
JOIN classicmodels.customers c ON p.customerNumber = c.customerNumber
ORDER BY amount desc
LIMIT 1;
-- #2
select  c.customername, sum(quantityordered*priceeach) as revenue 
from classicmodels.customers c 
join classicmodels.orders o on c.customernumber=o.customernumber
join classicmodels.orderdetails od on o.ordernumber=od.ordernumber
group by c.customername 
order by revenue desc 
limit 1;

-- 17
-- customers without payment
SELECT c.customerNumber, c.customerName, p.amount
FROM classicmodels.customers c
LEFT JOIN classicmodels.payments p ON c.customerNumber = p.customerNumber
WHERE p.amount is Null;

-- 18
-- #1  what is the average number of days between the order date and ship date?
-- 3.5951
SELECT SUM(datediff(shippedDate,orderDate))/count(*) as averageDays 
FROM classicmodels.orders;
-- #2
-- 3.7564
SELECT AVG(datediff(shippedDate,orderDate)) as averageDays 
FROM classicmodels.orders;

-- 19
-- sales by year
SELECT
YEAR(paymentDate) as years, sum(amount) as sales 
FROM classicmodels.payments
GROUP BY years
ORDER BY years;

-- 20
-- how many orders are not shipped?
SELECT COUNT(*) -- select *
FROM classicmodels.orders 
where shippeddate is null;
-- where status <> 'Shipped'; -- wrong because there customers that are in 'Disputed' status

-- 21
-- list all employees by their (full name: first + last) in alpabetical order
SELECT
CONCAT(firstName,' ', lastName) as fullName
FROM classicmodels.employees
ORDER BY fullName;

-- 22
-- list of employees  by how much they sold in 2003?
#1 by amount
SELECT fullName, -- Year_sold, Year_ordered, 
sum(amount) as sold
from
(SELECT CONCAT(e.firstName, ' ',e.lastName) as fullName, 
YEAR(p.paymentDate) as Year_sold, 
YEAR(o.orderdate) as Year_ordered, p.amount
FROM classicmodels.employees e
JOIN classicmodels.customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN classicmodels.payments p ON c.customerNumber = p.customerNumber
JOIN classicmodels.orders o on o.customernumber=c.customernumber
where o.orderdate between'2003-01-01' and '2003-12-31') a
GROUP BY fullName -- , Year_sold, Year_ordered
ORDER BY fullName, sold;

#2 (quantityOrdered * priceEach)
use classicmodels;
SELECT 
    e.employeeNumber,
    CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales_2003
FROM employees as e
JOIN customers as c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders as o ON c.customerNumber = o.customerNumber
JOIN orderdetails as od ON o.orderNumber = od.orderNumber
WHERE YEAR(o.orderDate) = 2003
GROUP BY e.employeeNumber, e.firstName, e.lastName
ORDER BY total_sales_2003 DESC;

-- 23
-- which city has the most number of employees?
SELECT o.city, COUNT(employeeNumber) as empNumber 
FROM classicmodels.employees e
JOIN classicmodels.offices o ON e.officeCode = o.officeCode
GROUP BY o.city
ORDER BY empNumber desc
LIMIT 1;

-- 24
-- which office has the biggest sales?
SELECT o.city, SUM(p.amount) as salesAmount
FROM classicmodels.offices o
JOIN classicmodels.employees e ON o.officeCode = e.officeCode
JOIN classicmodels.customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN classicmodels.payments p ON c.customerNumber = p.customerNumber
GROUP BY o.city
ORDER BY salesAmount desc
LIMIT 1;

-- ChatGPT (mysql classicmodels database which office has the biggest sales?)
SELECT off.officeCode, off.city, SUM(od.priceEach * od.quantityOrdered) AS totalSales -- select *
FROM classicmodels.offices off
JOIN classicmodels.employees e ON off.officeCode = e.officeCode
JOIN classicmodels.customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN classicmodels.orders o ON c.customerNumber = o.customerNumber
JOIN classicmodels.orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY off.officeCode, off.city
ORDER BY totalSales DESC
LIMIT 1;

-- Advanched Homework
-- join all tables together
-- 2,996
SELECT * -- count(1)
FROM classicmodels.customers c
JOIN classicmodels.employees e ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN classicmodels.offices o ON e.officeCode = o.officeCode
JOIN (select customerNumber, max(paymentDate) as paymentDate, sum(amount) as amount 
from classicmodels.payments group by customerNumber) p ON c.customerNumber = p.customerNumber
JOIN classicmodels.orders orders ON c.customerNumber = orders.customerNumber
JOIN classicmodels.orderdetails det ON orders.orderNumber = det.orderNumber
JOIN classicmodels.products pr ON det.productCode = pr.productCode
JOIN classicmodels.productlines pl ON pr.productLine = pl.productLine;

-- join all tables together [12,015 ROWS]
SELECT * FROM classicmodels.orders o 
JOIN classicmodels.orderdetails od ON o.orderNumber=od.orderNumber
JOIN classicmodels.customers c ON o.customerNumber=c.customerNumber
JOIN classicmodels.products p ON od.productCode=p.productCode
JOIN classicmodels.productlines pl ON p.productLine=pl.productLine
JOIN classicmodels.employees e ON c.salesRepEmployeeNumber=e.employeeNumber
JOIN classicmodels.payments py ON c.customerNumber=py.customerNumber
JOIN classicmodels.offices off ON e.officeCode=off.officeCode;
-- ---------------------------------------------------

-- Homework#6 - Part #2
-- 1976
-- select * from film.film_locations_in_san_francisco; 
-- Count distinct movies
-- 325
select count(distinct title) from film.film_locations_in_san_francisco; 

-- Count of all films by release year
select `release year`, count(distinct title) as movie_cnt 
from film.film_locations_in_san_francisco
group by `release year`; 

-- Count of all films by 'production company'
select `production company`, count(distinct title) movie_cnt
from film.film_locations_in_san_francisco
group by `production company`; 

-- Count of all films directed by Woody Allen
select director, count(distinct title) movie_cnt
from film.film_locations_in_san_francisco
where director like '%Woody Allen%'
group by director; 

-- How many movies have/don't have fun facts?
select case when `fun facts` = '' then 'no' else 'yes' end fun_fact, 
count(distinct title) movie_cnt
from film.film_locations_in_san_francisco
group by case when `fun facts` = '' then 'no' else 'yes' end; 

-- In how many movies were Keanu Reeves and Robin Williams?
select count(distinct title) movie_cnt
from film.film_locations_in_san_francisco
where `actor 1` in ('Keanu Reeves', 'Robin Williams')
or `actor 2` in ('Keanu Reeves', 'Robin Williams')
or `actor 3` in ('Keanu Reeves', 'Robin Williams');
