
-- Lesson #1 Intro to SQL
-- Lesson Plan  
-- Info about Course (Intro SQL Blocks.xlsx)
-- Costco Database  (Intro SQL Blocks.xlsx)
-- Inroduction to SQL (Intro SQL Blocks.xlsx)
-- SQL Course Materials: https://drive.google.com/drive/folders/1HXu-5cXw4E7OdnUapg3mA6YQG6tb6Skh
-- Slack channel: #qa_sql
-- MySQL Workbench (layout, shema/database, file, sql statements, EER diagram) 

-- MySQL Workbench 
-- Why MySQL Workbench? other tools e.g. SQL Navigator, SQL Assistant, Toad
-- Installation of MySQL/MySQL Workbench is done correctly when in Shchemas you see 'sys' database
-- To remove Safe Mode: Edit - Preferences - Sql editor - Safe Updates - uncheck the box

-- Layout
-- MySQL Workbench layout - three boxes in the right upper corner, play with them
-- MySQL Workbench has Results Grid window (query result; you can limit number of records)
-- MySQL Workbench has Action Output window (time, action, message, duration)
-- Action Output window Error messages - read them!

-- Shema/Database (on the left)
-- Sys schema (do not touch!) 
-- Check out databases, tables, columns, relationship structure
-- Shortcuts: Right click options (create table, create schema)
-- Refresh: If you don't see the changes after your action - right click on a white space - Refresh All

-- File
-- SQL files have extention .sql
-- SQL files can be also opened in notepad
-- To open a new query: File - New Query Tab
-- To open a script: File - Open Sql Script
-- To save a query: File - Save Script as xxxxxx

-- SQL statements
-- To run sql statement: 
-- 2 ways to Run SQL Statement
--    1.highlight statement - Query - Execute (All or Selection) or 
--    2.highlight statement - Click on 'yellow lightning' shortcut
-- 2 ways to Write SQL Notes: -- text OR /*text*/ 
-- SQL reserved words are in green/blue; to use them as regular words, quote them with `grave accent mark e.g.`database`

-- EER Diagram (Enhanced Entity Relationship)
-- EER Diagram: Database - Reverse Engineer - Next - Next - Choose the Database - Next - Next - Excecute - Finish



-- -------------------------------------------------------------
-- SQL Homework #1
/*  1.Install MySQL and MySQL Workbench
    2.In MySQL Workbench remove Safe Mode: 
    Edit - Preferences - Sql editor - Safe Updates - uncheck the box
    3.Create 'SQL' Folder in your local drive 
 
	4.Download our 1st database (Sample Database classicmodels)
	a.Go to https://www.mysqltutorial.org/mysql-sample-database.aspx 
	Click on Link: Download MySQL Sample Database
	b.Move mysqlsampledatabase.zip from your download folder to your local SQL folder 
	Unnzip 
    c.In MySQL Workbench: 
    File - Open SQL Script - choose mysqlsampledatabase.sql from your SQL folder
      *** Do not change anything in database scripts such as mysqlsampledatabase.sql
    d.Query - Execute. 
    Check on the left panel if classicmodels database was created
    e.File - New Query Tab - write this statement: 
    select * from classicmodels.customers;
    Query - Execute
    See the results in the Result Grid
    f.Check table relationships in EER Diagram: Database - Reverse Engineer - Next - Next - Choose the Database - Next - Next - Excecute - Finish
*/