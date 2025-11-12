
--Database Exploration



--2. What is the datatype for women employees?
--data_type_code: 10

/*
SELECT *
FROM LaborStatisticsDB.dbo.datatype
WHERE data_type_text LIKE '%women%'
*/

--3. What is the series id for women employees in the commercial banking industry in the financial activities supersector?
/*
SELECT * 
FROM LaborStatisticsDB.dbo.industry
WHERE industry_name LIKE '%banking%'
--commercial banking industry code: 55522110

SELECT * 
FROM LaborStatisticsDB.dbo.supersector
WHERE supersector_name LIKE '%financial%'
--financial activities supersector code: 55

SELECT *
FROM LaborStatisticsDB.dbo.series
WHERE supersector_code = 55
AND industry_code = 55522110
AND data_type_code = 10
*/

--Aggregate Your Friends and Code some SQL

--1. How many employees were reported in 2016 in all industries? Round to the nearest whole number.
/*
SELECT *
FROM LaborStatisticsDB.dbo.datatype
WHERE data_type_text LIKE '%all%'
--1, 25, 26, 
*/
/*
SELECT annual_2016.series_id, annual_2016.value, series.series_title
FROM LaborStatisticsDB.dbo.annual_2016 AS annual_2016
INNER JOIN LaborStatisticsDB.dbo.series AS series 
ON annual_2016.series_id = series.series_id
WHERE annual_2016.series_id LIKE '%01'

SELECT ROUND(SUM(annual_2016.value),0) AS total_employees_2016
FROM LaborStatisticsDB.dbo.annual_2016 AS annual_2016
WHERE annual_2016.series_id LIKE '%01'
*/

--2. How many women employees were reported in 2016 in all industries? Round to the nearest whole number.
/*
SELECT annual_2016.series_id, annual_2016.value, series.series_title
FROM LaborStatisticsDB.dbo.annual_2016 AS annual_2016
INNER JOIN LaborStatisticsDB.dbo.series AS series 
ON annual_2016.series_id = series.series_id
WHERE annual_2016.series_id LIKE '%10'

SELECT ROUND(SUM(annual_2016.value),0) AS total_women_employees_2016
FROM LaborStatisticsDB.dbo.annual_2016 AS annual_2016
WHERE annual_2016.series_id LIKE '%10'
*/

--3. How many production/nonsupervisory employees were reported in 2016? Round to the nearest whole number.
/*
SELECT * 
FROM LaborStatisticsDB.dbo.series 
WHERE series_title LIKE '%production%'
--data type code 6: "production and nonsupervisory employees"

SELECT annual_2016.series_id, annual_2016.value, series.series_title
FROM LaborStatisticsDB.dbo.annual_2016 AS annual_2016
INNER JOIN LaborStatisticsDB.dbo.series AS series 
ON annual_2016.series_id = series.series_id
WHERE annual_2016.series_id LIKE '%06'
--confirming that the value in annual_2016 matches the series_title "production and nonsupervisory employees"

SELECT ROUND(SUM(annual_2016.value),0) AS total_prod_nonsup_employees_2016
FROM LaborStatisticsDB.dbo.annual_2016 AS annual_2016
WHERE annual_2016.series_id LIKE '%06'
*/

--4. In January 2017, what is the average weekly hours worked by production and nonsupervisory employees across all industries?
/*
SELECT * 
FROM LaborStatisticsDB.dbo.series 
WHERE series_title LIKE '%production%'
--data_type_code 7: "Average weekly hours of production and nonsupervisory employees"

SELECT jan_2017.series_id, jan_2017.value, series.series_title
FROM LaborStatisticsDB.dbo.january_2017 AS jan_2017
INNER JOIN LaborStatisticsDB.dbo.series AS series 
ON jan_2017.series_id = series.series_id
WHERE jan_2017.series_id LIKE '%07'
--confirming that the value in january_2017 matches the series_title "Average weekly hours of production and nonsupervisory employees"

SELECT ROUND(AVG(jan_2017.value),0) AS avg_hours_prod_nonsup_jan_2017
FROM LaborStatisticsDB.dbo.january_2017 AS jan_2017
WHERE jan_2017.series_id LIKE '%07'
--averaging the hours for "Average weekly hours of production and nonsupervisory employees"
*/

--5. What is the total weekly payroll for production and nonsupervisory employees across all industries in January 2017? Round to the nearest penny.
/*
SELECT * 
FROM LaborStatisticsDB.dbo.series 
WHERE series_title LIKE '%weekly%'
--data_type_code 82: "Aggregate weekly payrolls of production and nonsupervisory employees"

SELECT DISTINCT jan_2017.series_id, jan_2017.value, series.series_title
FROM LaborStatisticsDB.dbo.january_2017 AS jan_2017
INNER JOIN LaborStatisticsDB.dbo.series AS series 
ON jan_2017.series_id = series.series_id
WHERE jan_2017.series_id LIKE '%82'
--confirming that the value in january_2017 matches the series_title "Aggregate weekly payrolls of production and nonsupervisory employees" with no duplicates. 

SELECT ROUND(sum(DISTINCT jan_2017.value),2,0) AS agg_payroll_prod_nonsup_jan_2017
FROM LaborStatisticsDB.dbo.january_2017 AS jan_2017
WHERE jan_2017.series_id LIKE '%82'
--Summing the values for distinct series_id with data_type_code '82' for "Aggregate weekly payrolls of production and nonsupervisory employees". 
*/

--6. In January 2017, for which industry was the average weekly hours worked by production and nonsupervisory employees the highest? Which industry was the lowest?
/*
SELECT MAX(jan_2017.value) AS top_avg_hours_prod_nonsup, indus.industry_name
FROM LaborStatisticsDB.dbo.january_2017 AS jan_2017
INNER JOIN LaborStatisticsDB.dbo.series AS series 
ON jan_2017.series_id = series.series_id
    INNER JOIN LaborStatisticsDB.dbo.industry AS indus
    ON series.industry_code = indus.industry_code
WHERE jan_2017.series_id LIKE '%07'
GROUP BY jan_2017.value, indus.industry_name
ORDER BY top_avg_hours_prod_nonsup DESC  
--Finding the max average weekly hours using data_type_code 7, getting the industry name information by joining the series and industry tables. 

SELECT MAX(jan_2017.value) AS top_avg_hours_prod_nonsup
FROM LaborStatisticsDB.dbo.january_2017 AS jan_2017
WHERE jan_2017.series_id LIKE '%07'
--confirming that 49.8 is the max value


SELECT MIN(jan_2017.value) AS least_avg_hours_prod_nonsup, indus.industry_name
FROM LaborStatisticsDB.dbo.january_2017 AS jan_2017
INNER JOIN LaborStatisticsDB.dbo.series AS series 
ON jan_2017.series_id = series.series_id
    INNER JOIN LaborStatisticsDB.dbo.industry AS indus
    ON series.industry_code = indus.industry_code
WHERE jan_2017.series_id LIKE '%07'
GROUP BY jan_2017.value, indus.industry_name
ORDER BY top_avg_hours_prod_nonsup ASC
--Finding the min average weekly hours using data_type_code 7, getting the industry name information by joining the series and industry tables. 

SELECT MIN(jan_2017.value) AS least_avg_hours_prod_nonsup
FROM LaborStatisticsDB.dbo.january_2017 AS jan_2017
WHERE jan_2017.series_id LIKE '%07'
--confirming that 16.7 is the min value
*/

--7. In January 2021, for which industry was the total weekly payroll for production and nonsupervisory employees the highest? Which industry was the lowest?
/*
SELECT MAX(jan_2017.value) AS top_payroll_prod_nonsup, indus.industry_name
FROM LaborStatisticsDB.dbo.january_2017 AS jan_2017
INNER JOIN LaborStatisticsDB.dbo.series AS series 
ON jan_2017.series_id = series.series_id
    INNER JOIN LaborStatisticsDB.dbo.industry AS indus
    ON series.industry_code = indus.industry_code
WHERE jan_2017.series_id LIKE '%82' AND 
      indus.industry_name NOT LIKE '%total%'
GROUP BY jan_2017.value, indus.industry_name
ORDER BY top_payroll_prod_nonsup DESC  
--Finding the max total weekly payroll using data_type_code 82, getting the industry name information by joining the series and industry tables. 


SELECT MIN(jan_2017.value) AS least_payroll_prod_nonsup, indus.industry_name
FROM LaborStatisticsDB.dbo.january_2017 AS jan_2017
INNER JOIN LaborStatisticsDB.dbo.series AS series 
ON jan_2017.series_id = series.series_id
    INNER JOIN LaborStatisticsDB.dbo.industry AS indus
    ON series.industry_code = indus.industry_code
WHERE jan_2017.series_id LIKE '%82'AND 
      indus.industry_name NOT LIKE '%total%'
GROUP BY jan_2017.value, indus.industry_name
ORDER BY least_payroll_prod_nonsup ASC
--Finding the min total weekly payroll using data_type_code 82 getting the industry name information by joining the series and industry tables. 
*/


--Join in on the Fun
--Time to start joining! You can choose the type of join you use, just make sure to make a note!

--1. Join annual_2016 with series on series_id. We only want the data in the annual_2016 table to be included in the result.
-- Limiting rows returned from query, uncomment the line below to start on your query!
-- SELECT TOP 50 *
/*
SELECT TOP 50 * 
FROM LaborStatisticsDB.dbo.annual_2016 AS annual_2016
LEFT JOIN LaborStatisticsDB.dbo.series AS series ON annual_2016.series_id = series.series_id

-- Uncomment the line below when you are ready to run the query, leaving it as your last!
-- ORDER BY id


SELECT TOP 50 * 
FROM LaborStatisticsDB.dbo.annual_2016 AS annual_2016
LEFT OUTER JOIN LaborStatisticsDB.dbo.series AS series ON annual_2016.series_id = series.series_id
ORDER BY annual_2016.id
*/


--2. Join series and datatype on data_type_code.
-- Limiting rows returned from query, uncomment the line below to start on your query!
-- SELECT TOP 50 *
/*
SELECT TOP 50 * 
FROM LaborStatisticsDB.dbo.series AS series
LEFT JOIN LaborStatisticsDB.dbo.datatype AS datatype ON series.data_type_code = datatype.data_type_code


-- Uncomment the line below when you are ready to run the query, leaving it as your last!
-- ORDER BY id
SELECT TOP 50 * 
FROM LaborStatisticsDB.dbo.series AS series
LEFT JOIN LaborStatisticsDB.dbo.datatype AS datatype ON series.data_type_code = datatype.data_type_code
ORDER BY series.series_id
*/


--3. Join series and industry on industry_code.
/*
-- Limiting rows returned from query, uncomment the line below to start on your query!
-- SELECT TOP 50 *
SELECT TOP 50 *
FROM LaborStatisticsDB.dbo.series AS series
LEFT JOIN LaborStatisticsDB.dbo.industry AS indus ON series.industry_code = indus.industry_code

-- Uncomment the line below when you are ready to run the query, leaving it as your last!
-- ORDER BY id
SELECT TOP 50 *
FROM LaborStatisticsDB.dbo.series AS series
LEFT JOIN LaborStatisticsDB.dbo.industry AS indus ON series.industry_code = indus.industry_code
ORDER BY indus.id
*/


--Subqueries, Unions, Derived Tables, Oh My!

--1. Write a query that returns the series_id, industry_code, industry_name, and value from the january_2017 table but only if that value 
--is greater than the average value for annual_2016 of data_type_code 82.
/*
SELECT series.series_id, series.industry_code, indus.industry_name, jan_2017.value AS jan_2017_value
FROM LaborStatisticsDB.dbo.series AS series
LEFT JOIN LaborStatisticsDB.dbo.january_2017 AS jan_2017 ON series.series_id = jan_2017.series_id
    INNER JOIN LaborStatisticsDB.dbo.industry AS indus ON series.industry_code = indus.industry_code
        INNER JOIN LaborStatisticsDB.dbo.annual_2016 AS annual_2016 ON series.series_id = annual_2016.series_id
WHERE annual_2016.series_id LIKE '%82'
GROUP BY series.series_id, jan_2017.value, annual_2016.value, series.industry_code, indus.industry_name
HAVING jan_2017.value > annual_2016.value 
*/

--Optional Bonus Question: Write the above query as a common table expression!



--2. Create a Union table comparing average weekly earnings of production and nonsupervisory employees between annual_2016 and january_2017 
--using the data type 30. Round to the nearest penny. You should have a column for the average earnings and a column for the year, and the period.
/*
SELECT ROUND(SUM(annual_2016.value),2,0) AS avg_wkly_earnings, annual_2016.year, annual_2016.period 
FROM LaborStatisticsDB.dbo.annual_2016 AS annual_2016
WHERE annual_2016.series_id LIKE '%30'
GROUP BY annual_2016.value, annual_2016.year, annual_2016.period
UNION 
SELECT ROUND(SUM(jan_2017.value),2,0) AS avg_wkly_earnings, jan_2017.year, jan_2017.PERIOD
FROM LaborStatisticsDB.dbo.january_2017 AS jan_2017 
WHERE jan_2017.series_id LIKE '%30'
GROUP BY jan_2017.value, jan_2017.year, jan_2017.period
ORDER BY annual_2016.period 


--Summarize Your Results
--Note that while this is subjective, you should include relevant data to back up your opinion.

--1. During which time period did production and nonsupervisory employees fare better?
--Production and nonsupervisory employees did better in M01 of 2017 that in M13 of 2016, based on the data that I selected in question 2 of the Subqueries section. The total value for M01 of 2017 was 1782000.96, while the total value for M13 2016 (the only period present with data type code 30) was 878510.28. I calculated these value using the code below. 

SELECT ROUND(SUM(annual_2016.value),2,0) AS avg_wkly_earnings
FROM LaborStatisticsDB.dbo.annual_2016 AS annual_2016
WHERE annual_2016.series_id LIKE '%30'

--878510.28

SELECT ROUND(SUM(jan_2017.value),2,0) AS avg_wkly_earnings
FROM LaborStatisticsDB.dbo.january_2017 AS jan_2017 
WHERE jan_2017.series_id LIKE '%30'
--1782000.96
*/
--2. In which industries did production and nonsupervisory employees fare better?
--Production and nonsupervisory employees did best in service and trade industries, based on the data I selected in question 6 of the Aggregate section. The top five industries for average weekly payroll for production and nonsupervisory employees were private-service providing, professional and business services, trade, education and health services, and goods-producing. I determined this based on the code from question 6, copied below. 

/*
SELECT MAX(jan_2017.value) AS top_payroll_prod_nonsup, indus.industry_name
FROM LaborStatisticsDB.dbo.january_2017 AS jan_2017
INNER JOIN LaborStatisticsDB.dbo.series AS series 
ON jan_2017.series_id = series.series_id
    INNER JOIN LaborStatisticsDB.dbo.industry AS indus
    ON series.industry_code = indus.industry_code
WHERE jan_2017.series_id LIKE '%82' AND 
      indus.industry_name NOT LIKE '%total%'
GROUP BY jan_2017.value, indus.industry_name
ORDER BY top_payroll_prod_nonsup DESC  

*/
--Finding the max total weekly payroll using data_type_code 82, getting the industry name information by joining the series and industry tables. 
--3. Now that you have explored the datasets, is there any data or information that you wish you had in this analysis?
--I wish there were more breakdown of differetn demographics of employees beyond just women and production and nonsupervisory employees. It would be interesting to learn about part-time versus full-time employees, employees who have more than one job, breakdowns based on age or other factors, etc. 