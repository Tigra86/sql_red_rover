-- Homework #8
-- Part1 world database answers
/* world.sql
-- download 'world database' here: https://dev.mysql.com/doc/index-other.html
-- create EER diagram and write sql where you join all tables together
*/
select * from world.city; 
select * from world.country where row_number = select max() from world.country; 
select * from world.countrylanguage; 

select count(*) from world.city; -- 4079
select count(*) from world.country; -- 239
select count(*) from world.countrylanguage; -- 984

 
-- 1 show distinct continent, region, country
select distinct continent, region, `name` from world.country;

-- 2 what languages are spoken in Sydney?
select city.name as name_city, lang.language 
from  world.city city  
join world.countrylanguage lang on city.CountryCode = lang.CountryCode
 where city.name = 'Sydney';

-- 3 show governmentForm and number of countries (desc order)
select governmentForm, count(*) as country_cnt 
from world.country
group by governmentForm
order by country_cnt desc;

-- 4 rank country by population (desc order)
select name, Population, 
RANK() OVER (ORDER BY Population DESC) as `rank`  
from world.country;

-- 5 which country has the bigest number of languages?
 select cntr.name as country_name, count(distinct language) language_cnt 
 from world.country cntr
join world.countrylanguage lang on cntr.Code = lang.CountryCode
group by cntr.name
order by language_cnt desc
limit 10;

-- 6 which country has the lowest LifeExpectancy
select continent, `name` , LifeExpectancy
from world.country
where LifeExpectancy is not null
order by LifeExpectancy
limit 1;

-- 7 if a country has English as one of the languages, it is an 'English Speaking' country, if not 'Non English Speaking'
-- Therefore create 'English_Language' field using CASE statement. You can also show Percentage of the language spoken 
 select b.Name as Country,
 case when max(a.English_or_not) = 1 then 'English Speaking' else 'Non English Speaking' end as English,
 max(a.English_percentage)English_percentage
 from (
 select l.*, 
 case when Language = 'English' then 1 else 0 end English_or_not,
 case when Language = 'English' then Percentage else 0 end as English_percentage
 from world.countrylanguage l)a
 join world.country b on a.countryCode = b.Code
 group by b.Name;

 
  -- 8 what is the average life expectancy for countries with population < 1 million and > 1 million?
 select pop_mil, count(*) country_cnt,  sum(population) pop_sum, 
 avg(lifeexpectancy) as lifeexp_avg,
 format(avg(lifeexpectancy),2) as lifeexp_avg_formated
 from
 (select name, Continent, Population, LifeExpectancy,
 case when Population <1000000 then '<1mil' else  '>1mil' end pop_mil
 from world.country) as a
 group by pop_mil;

-- join all tables
-- 4079
select count(*)
from world.country as cntr 
join world.city as city on cntr.Code = city.CountryCode
join (select countrycode, count(language) language_cnt
from world.countrylanguage group by countrycode) as lang 
on cntr.Code = lang.CountryCode;
-- where cntr.code = 'AFG';

 -- Part2 jeopardy database
/*create database jeopardy;
 right click of database jeopardy and download jason or csv file (both have issues) from 
 https://www.reddit.com/r/datasets/comments/1uyd0t/200000_jeopardy_questions_in_a_json_file/
*/
select * from jeopardy.jeopardy_questions; 
desc jeopardy.jeopardy_questions;
select count(*)from jeopardy.jeopardy_questions; -- 216,930

-- find top 5 categories
 select category, count(*) 
 from jeopardy.jeopardy_questions
 group by category
 order by count(*) desc
 limit 5;

-- find a question about Shakespere
select * from jeopardy.jeopardy_questions
where question like '%Shakespere%';

-- how many distinct show numbers?
select count(distinct show_number) from jeopardy.jeopardy_questions;

-- what are the 3 most common answers?
select answer, count(answer) as answer_cnt
from jeopardy.jeopardy_questions 
group by answer
order by count(answer) desc
limit 3;

-- how many questions per each value?
select value, count(question)
from jeopardy.jeopardy_questions
group by value
order by count(question) desc;

-- which category has the most quesions?
select category,  count(question)
from jeopardy.jeopardy_questions
group by category
order by count(question) desc
limit 1;

-- how many questions each year?
select air_year, count(*)
from
(select case when year(air_date) is null then 'no data' else year(air_date) end as air_year
from jeopardy.jeopardy_questions)a
group by  air_year
order by   air_year;

-- show number of questions for each value in each round
select value, round, count(*)
from jeopardy.jeopardy_questions
group by value, round
order by value desc;

-- how many questions are missing?
select count(*)
from jeopardy.jeopardy_questions
where question  ='';

-- how many questions have no answers?
select count(*)
from jeopardy.jeopardy_questions
where answer ='';

-- how many distinct rounds in each show?
select show_number, count(distinct round)
from jeopardy.jeopardy_questions
group by show_number;
-- --------------------- End of Homework  -------------