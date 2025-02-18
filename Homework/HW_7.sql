-- Homework #7
-- Answers - Data Cleaning Project - English Dicionary
-- drop table dictionary.english_dictionary_master;
-- drop table dictionary.english_dictionary_most_common_words;
select count(*) from dictionary.english_dictionary_master; -- 176,026
select count(*) from dictionary.english_dictionary_most_common_words; -- 4,341

-- 1-3
create database Dictionary;
-- 4.Show counts of both tables
select count(*) from dictionary.english_dictionary_master; -- 176,026
select count(*) from dictionary.english_dictionary_most_common_words; -- 4,341

-- Imprtant!!!
-- bug in the latest version of MySQL - can't import a csv file with one column
-- to fix: add 'column_to _delete' column (or any other name) to english_dictionary_most_common_words.csv


select * from dictionary.english_dictionary_master
limit 25;

select * from dictionary.english_dictionary_most_common_words
limit 25;

-- 5.Create copies of both tables just in case you accidentally delete the originals
create table dictionary.english_dictionary_master_copy 
as select * from dictionary.english_dictionary_master; 
-- drop table dictionary.english_dictionary_master;
-- create table dictionary.english_dictionary_master as select * from dictionary.english_dictionary_master_copy; 

create table dictionary.english_dictionary_most_common_words_copy
as select * from dictionary.english_dictionary_most_common_words;
-- drop table dictionary.english_dictionary_most_common_words;
-- create table dictionary.english_dictionary_most_common_words as select * from dictionary.english_dictionary_most_common_words_copy;  

-- 6.Rename column type to word_type and definition to word_def
alter table dictionary.english_dictionary_master rename column `Type` to word_type;
alter table dictionary.english_dictionary_master rename column `Definition` to word_def;

-- 7.Update column word_type and word_def to remove " and .
update dictionary.english_dictionary_master set word_type = replace(word_type, '"','');
update dictionary.english_dictionary_master set word_type = replace(word_type, '.','');
update dictionary.english_dictionary_master set word_def = replace(word_def, '"','');
update dictionary.english_dictionary_master set word_def = replace(word_def, '.','');
-- update dictionary.english_dictionary_master set word = trim(word);

-- 8.Add column is_common to master table and update this column with 'yes' for common words 
alter table dictionary.english_dictionary_master add column is_common varchar (6);

desc dictionary.english_dictionary_master;  
 
select max(length(word)) from dictionary.english_dictionary_master; -- 83

select word, length(word) from dictionary.english_dictionary_master
-- where length(word) = 83
order by length(word) desc
limit 1;

alter table dictionary.english_dictionary_master add column word_new varchar(83); 

update dictionary.english_dictionary_master
set word_new = word;

select * from dictionary.english_dictionary_master  limit 25;

CREATE INDEX w1 ON dictionary.english_dictionary_master (`word_new`);

/* -- table is too big to update
update dictionary.english_dictionary_master
set is_common ='yes'
where word_new in
(select distinct common_words from dictionary.english_dictionary_most_common_words);
*/
 select * from dictionary.english_dictionary_master
 limit 25;
 
 
-- 9.Using trim functon get rid off extra spaces in all columns in dictionary.english_dictionary_master
-- drop table dictionary.english_dictionary_master2;
create table dictionary.english_dictionary_master2 as
select trim(a.Word) as word, trim(a.word_type) as word_type, 
trim(a.Length) as length, trim(a.word_def) as word_def,
case when trim(a.word_new) = trim(b.common_words) then 'yes' else null end is_common
from dictionary.english_dictionary_master a
left join (select distinct trim(common_words) as common_words
from dictionary.english_dictionary_most_common_words) b
on trim(a.word_new) = trim(b.common_words);

select * from dictionary.english_dictionary_master2;

drop table dictionary.english_dictionary_master;
rename table dictionary.english_dictionary_master2 to dictionary.english_dictionary_master;

-- insert auto increment Word ID
create table dictionary.english_dictionary_master2 
(WordID int (6) auto_increment,
word	varchar (100),			
word_type	varchar (50),		
length	varchar(11)	,	
word_def	varchar (1000),		
is_common	varchar(3),			
PRIMARY KEY (WordID)); 

insert into dictionary.english_dictionary_master2 (word,word_type,length,word_def,is_common)
(select * from dictionary.english_dictionary_master);

drop table dictionary.english_dictionary_master;
rename table dictionary.english_dictionary_master2 to dictionary.english_dictionary_master;
-- drop table dictionary.english_dictionary_master2;

select * from dictionary.english_dictionary_master;
select count(*) from dictionary.english_dictionary_master; -- 176,026

-- 10. Queries
-- how many distinct common/uncommon words are in the table?
select is_common, count(distinct word) cnt_distinct_words, count(*) cnt_all_words
from dictionary.english_dictionary_master
group by is_common;

-- how many distinct word_types are in the table?
select word_type, count(distinct word) cnt_distinct_words, count(*) cnt_all_words
from dictionary.english_dictionary_master
group by word_type
order by count(*) desc;

-- find all english words for different colors (e.g. bronze, ruby, white, pink, red, azure, blue, etc.)
select word, word_type, word_def
from dictionary.english_dictionary_master 
where word_def like '%color%' and word_type = 'a';

-- randomly select 4 nouns and ajectives
select  -- select count(*) 
word, word_type, word_def -- , RAND(word) as word_rand  -- select *
from dictionary.english_dictionary_master -- where word_def like '%color%' and word_type = 'a'
where is_common = 'yes' and word_type in ('n', 'a')
order by rand()
limit 4;

-- randomly create verbs and nouns
-- randomly select 4 nouns 
select a.*, 
rank() over (order by rownum asc)  as `rank`
from
(
select  -- select count(*) 
word, 
row_number() over() as rownum, word_type, word_def -- , 
from dictionary.english_dictionary_master 
where is_common = 'yes' and word_type in ('n')
order by rand()
limit 4
)a
union
-- randomly select 4 verbs
select a.*, 
rank() over (order by rownum asc)  as `rank`
from
(
select  -- select count(*) 
word, 
row_number() over() as rownum, word_type, word_def -- , 
from dictionary.english_dictionary_master 
where is_common = 'yes' and word_type in ('v')
order by rand()
limit 4
)a
order by `rank` asc, word_type desc;


-- create separtate columns for each letter in the word
select  -- select count(*) 
word, substr(word,1,1) as letter1, substr(word,2,1) letter2, 
substr(word,3,1) letter3, substr(word,4,1) letter4,
substr(word,5,1) letter5, substr(word,6,1) letter6, substr(word,7,1) letter7
-- , word_type, word_def -- , RAND(word) as word_rand  -- select *
from dictionary.english_dictionary_master -- where word_def like '%color%' and word_type = 'a'
where is_common = 'yes' and length(word) = 7 -- word_type in ('n', 'a') and substr(word,1,1)=substr(word,3,1)
order by rand();
