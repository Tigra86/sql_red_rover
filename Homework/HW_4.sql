-- Homework for Lesson #4 
-- Part #1 classicmodels database 
-- (write sql for #6, 8, 9, 10, 11, 14, 16, 17, 21) -- easy questions

-- HINT! If you don't know how to find tables and columns you need...
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, COLUMN_KEY
FROM INFORMATION_SCHEMA.columns
WHERE TABLE_SCHEMA = 'classicmodels' and COLUMN_NAME like '%vendor%';

-- 1.how many vendors, product lines, and products exist in the database?
-- 2.what is the average price (buy price, MSRP) per vendor?
-- 3.what is the average price (buy price, MSRP) per customer?
-- 4.what product was sold the most?
-- 5.how much money was made between buyPrice and MSRP?
-- 6.which vendor sells 1966 Shelby Cobra?
select productName, productVendor 
from classicmodels.products
where productName like '%1966 Shelby Cobra%';

-- 7.which vendor sells more products?
-- 8.which product is the most and least expensive?
select productName, MSRP
from classicmodels.products
order by MSRP desc 
limit 1;

select productName, MSRP
from classicmodels.products
order by MSRP asc 
limit 1;

-- 9.which product has the most quantityInStock?
select productName, quantityInStock
from classicmodels.products
order by quantityInStock desc 
limit 1;

-- 10.list all products that have quantity in stock less than 20
select productName, quantityInStock
from classicmodels.products
where quantityInStock < 20
order by quantityInStock desc;

-- 11.which customer has the highest and lowest credit limit?
select customerName, creditLimit
from classicmodels.customers
where creditLimit = (select max(creditLimit) from classicmodels.customers);

select customerName, creditLimit
from classicmodels.customers
where creditLimit = (select min(creditLimit) from classicmodels.customers);

-- 12.rank customers by credit limit
-- 13.list the most sold product by city
-- 14.customers in what city are the most profitable to the company? -- based on highest single payment
select city, amount
from classicmodels.customers as cust
inner join classicmodels.payments as pay 
on cust.customerNumber = pay.customerNumber
order by amount desc
limit 1;

-- 15.what is the average number of orders per customer?
-- 16.who is the best customer? --based on single payment
select customerName, amount
from classicmodels.customers as cust
inner join classicmodels.payments as pay 
on cust.customerNumber = pay.customerNumber
order by amount desc
limit 1;

-- 17.customers without payment
select customerName, amount
from classicmodels.customers as cust
left join classicmodels.payments as pay 
on cust.customerNumber = pay.customerNumber
where amount is null;

-- 18.what is the average number of days between the order date and ship date?
-- 19.sales by year
-- 20.how many orders are not shipped?
-- 21.list all employees by their (full name: first + last) in alpabetical order
select concat(firstName, ' ', lastName) as fullName
from classicmodels.employees
order by fullName asc;
 
-- 22.list of employees  by how much they sold in 2003?
-- 23.which city has the most number of employees?
-- 24.which office has the biggest sales?

-- Part #2  -- library_simple database
-- 1.find all information (query each table seporately for book_id = 252)
select * from library_simple.book c where id =252;
select * from library_simple.author_has_book b where book_id = 252;
select * from library_simple.author a where id in (750,770,794);
select * from library_simple.copy f where book_id = 252;
select * from library_simple.issuance g where copy_id in (182,774,1024);
select * from library_simple.reader h where id in (170,76,91);
select * from library_simple.category_has_book d where book_id = 252;
select * from library_simple.category e where id in (46,142);

-- 2.which books did Van Parks write?
select a.id, a.first_name, a.last_name,
b.author_id, b.book_id, 
c.id, c.ISBN, c.name, c.page_num, c.pub_year
from library_simple.author a
join library_simple.author_has_book	b
on a.id = b.author_id
join library_simple.book c 
on b.book_id = c.id
where a.first_name = 'Van' and a.last_name = 'Parks';

-- 3.which books where published in 2003?
select a.id, a.first_name, a.last_name,
b.author_id, b.book_id, 
c.id, c.ISBN, c.name, c.page_num, c.pub_year
from library_simple.author a
join library_simple.author_has_book	b
on a.id = b.author_id
join library_simple.book c 
on b.book_id = c.id
where c.pub_year = '2003';
