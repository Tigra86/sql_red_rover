-- Homework #5
-- Part #1
-- 1. use union: (classicmodels db) show products with buyPrice or msrp > $100 and < $200
-- 110 -- query works but doesn't make sence because we pull ALL records
select productName, productLine, buyPrice
from classicmodels.products
where buyPrice >100
UNION
select productName, productLine, buyPrice
from classicmodels.products
where buyPrice <200;
 
-- a much better query
select productName, productLine, buyPrice
from classicmodels.products
where buyPrice between 100 and 200;

-- 2. use subquery: (classicmodels db) show all customer names with employees in San Francisco office
-- subquery version 1
-- 12
select salesRepEmployeeNumber, customerName
from classicmodels.customers
where salesRepEmployeeNumber in 
(select distinct employeeNumber from classicmodels.employees 
where officeCode in 
(select officeCode from classicmodels.offices where city = 'San Francisco'));

-- subquery version 2
-- 12
select salesRepEmployeeNumber, customerName
from classicmodels.customers c
where salesRepEmployeeNumber in
(select distinct e.EmployeeNumber -- ,o.officeCode 
from classicmodels.employees e
join classicmodels.offices o 
on e.officecode = o.officecode
where o.city = 'San Francisco');

-- without subquery version 3
-- 12
select c.salesRepEmployeeNumber, o.city, c.customerName
from classicmodels.customers c
join classicmodels.employees e on c.salesRepEmployeeNumber = e.employeeNumber 
join classicmodels.offices o on e.officeCode  = o.officeCode
 where o.city = 'San Francisco';
 
 -- 3. use count (*) in subquery
select count(*) from
(select salesRepEmployeeNumber, customerName
from classicmodels.customers
where salesRepEmployeeNumber in 
(select distinct employeeNumber from classicmodels.employees 
where officeCode in 
(select officeCode from classicmodels.offices where city = 'San Francisco')))a;
 
-- Part #2
-- Classicmodels Database - Keep working on these queries
-- write sql for #1,2,3,4,5,7
-- 1.how many vendors, product lines, and products exist in the database?
-- 2.what is the average price (buy price, MSRP) per vendor?
-- 3.what is the average price (buy price, MSRP) per customer?
-- 4.what product was sold the most?
-- 5.how much money was made between buyPrice and MSRP?
-- 7.which vendor sells more products?

-- 1.how many vendors, product lines, and products exist in the database?
SELECT
	COUNT(distinct ProductVendor) as Vendors_count,
	COUNT(distinct ProductLine) as Product_lines_count,
	COUNT(distinct productCode) as Products_count
FROM classicmodels.products;

-- 2.what is the average price (buy price, MSRP) per vendor?
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

-- 4.Pay Attention!!! which fields: productCode or quatityOrdered?
-- what product was sold the most?
SELECT prod.productName,
COUNT(prod.productCode) as prod_cnt, 
SUM(det.quantityOrdered) as quantity_ordered_sum,
MAX(det.quantityOrdered) as order_cnt
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


-- Part #3 library_simple database
-- Database: library_simple
select count(*) from library_simple.author; -- 86
select count(*) from library_simple.author_has_book; -- 596
select count(*) from library_simple.book; -- 322
select count(*) from library_simple.category; -- 184
select count(*) from library_simple.category_has_book; -- 556
select count(*) from library_simple.copy; -- 1121
select count(*) from library_simple.issuance; -- 2000
select count(*) from library_simple.reader; -- 241 

-- join all tables
select distinct 
-- a.id, a.first_name, a.last_name,
-- b.author_id, b.book_id, 
c.id, c.ISBN, c.name, c.page_num, c.pub_year,
-- d.category_id, d.book_id,	
-- e.id, e.name,
f.id, f.book_id, f.number, f.admission_date,
g.id, g.copy_id, -- g.reader_id, 
g.issue_date, g.release_date, g.deadline_date,	
h.id, h.first_name, h.last_name, h.reader_num	-- select *
from library_simple.author a
join library_simple.author_has_book	b
on a.id = b.author_id
join library_simple.book c 
on b.book_id = c.id
join library_simple.category_has_book d
on c.id = d.book_id
join library_simple.category e
on d.category_id = e.id
join library_simple.copy f
on c.id = f.book_id
join library_simple.issuance g
on f.id = g.id 
join library_simple.reader h
on h.id = g.reader_id
where c.name = 'Lord Of Dread'
;

-- Find all release dates for book 'Dog With Money'
-- 3
select * from 
library_simple.book c 
join library_simple.copy f 
on  c.id = f.book_id --  where c.name = 'Dog With Money'
 join library_simple.issuance g
 on f.id = g.id -- f.id = g.copy_id 
where c.name = 'Dog With Money';
 
 
 select f.id, f.book_id, f.number, f.admission_date, 
 g.id as issuance_id, g.copy_id, g.reader_id, g.issue_date, g.release_date, g.deadline_date 
 from 
 library_simple.copy f 
 left join library_simple.issuance g
 on f.id = g.copy_id 
 where book_id = 61;
 -- where c.name = 'Dog With Money'

-- to verify 
select * from library_simple.book where name = 'Dog With Money';
select * from library_simple.copy f where book_id = 61;
select * from library_simple.issuance where id in (573,768,960);
-- select * from library_simple.issuance where copy_id in (573,768,960);

