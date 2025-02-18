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
    
    Query - Execute
    See the results in the Result Grid
    f.Check table relationships in EER Diagram: Database - Reverse Engineer - Next - Next - Choose the Database - Next - Next - Excecute - Finish
*/

select * 
from classicmodels.customers;