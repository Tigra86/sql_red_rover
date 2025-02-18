-- Homework #3  
-- Part 1 - mywork database
select * 
from mywork.dept;
    
-- Write sql 
	-- 1. Add column 'country' to dept table in mywork database
alter table mywork.dept 
add column country varchar (50);
    
	-- 2. Rename column 'loc' to 'city'
alter table mywork.dept 
rename column loc to city;

	-- 3. Add three more departments: HR, Engineering, Marketing
insert into mywork.dept (deptno, dname)
values
    (5, 'HR'),
	(6, 'Engineering'),
    (7, 'Marketing');
    
	-- 4. Write sql statement to show which department is in Atlanta
select dname, city
from mywork.dept
where city like 'Atlanta';

    -- Save your work 


-- Part 2  - library_simple database
-- Run library_simple.sql script  (takes a few minutes)
-- (source: https://github.com/amyasnov/stepic-db-intro/tree/2650f9a7f9c72e1219ea93cb4c4e410cca046e54/test)

-- Look at table relationships in EER Diagram

-- DO YOUR COUNTS BEFORE YOU START WORKING ON ANY DATABASE
select count(*) from library_simple.author; -- 86
select count(*) from library_simple.author_has_book; -- 596
select count(*) from library_simple.book; -- 322
select count(*) from library_simple.category; -- 184
select count(*) from library_simple.category_has_book; -- 556
select count(*) from library_simple.copy; -- 1121
select count(*) from library_simple.issuance; -- 2000
select count(*) from library_simple.reader; -- 241

-- or 

SELECT table_schema, table_name, table_rows
FROM INFORMATION_SCHEMA.tables
WHERE TABLE_SCHEMA = 'library_simple'; 

-- Write sql 
	-- 1. What is the first name of the author with the last name Swanson?
select first_name, last_name 
from author 
where last_name like 'Swanson';

	-- 2. How many pages are in Men Without Fear book?
select name, page_num 
from book 
where `name` like 'Men Without Fear';    
    
	-- 3. Show all book categories that start with with letter 'W'
select *
from category
where `name` like 'W%';