/*
Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name).
If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.
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

/*Draw Triangle*/


DECLARE @Counter INT 
SET @Counter=20
WHILE ( @Counter >= 1)
BEGIN
    select replicate('*',@Counter)
    SET @Counter  = @Counter  - 1
END


DECLARE @Counter INT 
SET @Counter=1
WHILE ( @Counter <= 20)
BEGIN
    select replicate('* ',@Counter)
    SET @Counter  = @Counter  + 1
END

/*You are given two tables: Students and Grades. Students contains three columns ID, Name and Marks.



Grades contains the following data:



Ketty gives Eve a task to generate a report containing three columns: Name, Grade and Mark. Ketty doesn't want the NAMES of those students who received a grade lower than 8. The report must be in descending order by grade -- i.e. higher grades are entered first. If there is more than one student with the same grade (8-10) assigned to them, order those particular students by their name alphabetically. Finally, if the grade is lower than 8, use "NULL" as their name and list them by their grades in descending order. If there is more than one student with the same grade (1-7) assigned to them, order those particular students by their marks in ascending order.

Write a query to help Eve.

Sample Input



Sample Output

Maria 10 99
Jane 9 81
Julia 9 88 
Scarlet 8 78
NULL 7 63
NULL 7 68

Note

Print "NULL"  as the name if the grade is less than 8.

Explanation

Consider the following table with the grades assigned to the students:



So, the following students got 8, 9 or 10 grades:

Maria (grade 10)
Jane (grade 9)
Julia (grade 9)
Scarlet (grade 8)*/

;WITH Result as (select *, CASE when marks between 0 and 9 then 1
when marks between 10 and 19 then 2
when marks between 20 and 29 then 3
when marks between 30 and 39 then 4
when marks between 40 and 49 then 5
when marks between 50 and 59 then 6
when marks between 60 and 69 then 7
when marks between 70 and 79 then 8
when marks between 80 and 89 then 9
when marks between 90 and 100 then 10 end as Grade
from students )Select Name, Grade, Marks from Result
where Grade>=8
union 
Select NULL as Name, Grade, Marks from Result
where Grade<8
order by 2 desc, 1 asc,3 asc

/*Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. 
Output one of the following statements for each record in the table:
Equilateral: It's a triangle with  sides of equal length.
Isosceles: It's a triangle with  sides of equal length.
Scalene: It's a triangle with  sides of differing lengths.
Not A Triangle: The given values of A, B, and C don't form a triangle.*/

select 
case  
when A+B<=C or A+C<=B or B+C<=A then  'Not A Triangle'
when A=B and B=C and C=A then 'Equilateral'
when A=B or B=C or C=A  then 'Isosceles'
when A<>B and B<>C and C<>A then 'Scalene'
else 'Not A Triangle' 
End 
from triangles;

/*Query the difference between the maximum and minimum populations in CITY.*/

SELECT MAX(Population)-MIN(Population)as diff_population FROM CITY

/*Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, but did not realize her keyboard's  
key was broken until after completing the calculation. She wants your help finding the difference between her miscalculation 
(using salaries with any zeros removed), and the actual average salary.

Write a query calculating the amount of error (i.e.:  average monthly salaries), and round it up to the next integer.*/

select  CEILING(AVG(cast(salary as decimal(12,7)))-AVG(cast(REPLACE(Salary, 0, '') as decimal(12,7))))  from employees;