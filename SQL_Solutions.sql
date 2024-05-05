/*
Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.
The STATION table is described as follows:

Station.jpg

where LAT_N is the northern latitude and LONG_W is the western longitude.

Sample Input

For example, CITY has four entries: DEF, ABC, PQRS and WXY.

Sample Output

ABC 3
PQRS 4
Explanation

When ordered alphabetically, the CITY names are listed as ABC, DEF, PQRS, and WXY, with lengths  and . The longest name is PQRS, but there are  options for shortest named city. Choose ABC, because it comes first alphabetically.

Note
You can write two separate queries to get the desired output. It need not be a single query.*/

;with less_length as
(
select rank()over(order by len(city))as rk_a,*
from station
),
higher_length as 
(
select rank()over(order by len(city) desc)as rk_d,*
from station
)
,less_length_A as
( select city , row_number()over(order by city) as rk_a_a
 from less_length
 where rk_a=1
)
,higher_length_A as
( select city, row_number()over(order by city) as rk_a_d
 from higher_length
 where rk_d=1
)
select city, len(city) as city_len from less_length_A
where rk_a_a=1
union all
select city, len(city) as city_len from higher_length_A
where rk_a_d=1
/*Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.*/
SELECT DISTINCT city
FROM STATION
where (
LEFT(city,1)='a'
       or
LEFT(city,1)='e'
    or
LEFT(city,1)='i'
    or
LEFT(city,1)='o'
    or
LEFT(city,1)='u'
)
/*Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.*/
SELECT DISTINCT city
FROM STATION
where (
RIGHT(city,1)='a'
       or
RIGHT(city,1)='e'
    or
RIGHT(city,1)='i'
    or
RIGHT(city,1)='o'
    or
RIGHT(city,1)='u'
);
/*Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates.*/
SELECT DISTINCT city
FROM STATION
where ((LEFT(city,1) IN ('a','e','i','o','u') AND RIGHT(city,1) IN('a','e','i','o','u')));
/*Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.*/
SELECT DISTINCT city
FROM STATION
where LEFT(city,1) NOT IN ('a','e','i','o','u');
/*Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.*/
SELECT DISTINCT city
FROM STATION
where RIGHT(city,1) NOT IN ('a','e','i','o','u');
/*Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.*/
SELECT DISTINCT city
FROM STATION
where ((LEFT(city,1) NOT IN ('a','e','i','o','u') OR RIGHT(city,1) NOT IN('a','e','i','o','u')));
/*Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.*/
SELECT DISTINCT city
FROM STATION
where ((LEFT(city,1) NOT IN ('a','e','i','o','u') AND RIGHT(city,1) NOT IN('a','e','i','o','u')));
/*Query the Name of any student in STUDENTS who scored higher than  Marks. Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.*/
Select NAME From STUDENTS where Marks > 75 ORDER BY RIGHT(NAME, 3) ASC, ID ASC;
/*Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.*/
select Name from Employee
order by 1 asc

/*Amber's conglomerate corporation just acquired some new companies. Each of the companies follows this hierarchy: 

Given the table schemas below, write a query to print the company_code, founder name, total number of lead managers,
total number of senior managers, total number of managers, and total number of employees. Order your output by ascending company_code.*/

select C.company_code, C.Founder,Count(distinct LM.lead_manager_code) as lead_manager_code,
count(distinct SM.Senior_manager_code) as Senior_manager_code,
count(distinct M.manager_code) as manager_code,
count(distinct E.employee_code) as employee_Code
from company C
inner join Lead_Manager LM
    ON C.company_code=LM.company_code
inner join Senior_Manager SM
    ON SM.lead_manager_code=LM.lead_manager_code
    AND SM.company_code=C.company_code
inner join Manager M
    ON M.Senior_manager_code=SM.Senior_manager_code
    AND M.lead_manager_code=LM.lead_manager_code
    AND M.company_code=C.company_code
inner join Employee E
    ON E.manager_code=M.manager_code
    AND E.Senior_manager_code=SM.Senior_manager_code
    AND E.lead_manager_code=LM.lead_manager_code
    AND E.company_code=C.company_code
Group by C.company_code, C.Founder
order by 1;

/*A median is defined as a number separating the higher half of a data set from the lower half. Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to  decimal places.

Input Format

The STATION table is described as follows:*/

select  distinct cast(round(Median,4)as decimal(10,4)) from
(
select percentile_cont(0.5) within group(order by LAT_N)
over(partition by id1) as Median from
(select 1 as id1,* from station)r1
)r