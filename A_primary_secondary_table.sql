/*
 * Primary and secondary project tables
 */

/*
 * survey of source tables from the database before creating the primary table 
 */

/*
 * all wages in CZK? 
 */
SELECT 
	count(1) AS count_cpayroll_wages
FROM czechia_payroll 
WHERE value_type_code = 5958;
-- count = 3440
SELECT 
	count(1) AS count_cpayroll_wages_CZK
FROM czechia_payroll 
WHERE value_type_code = 5958 AND unit_code =200;
-- count = 3440
-- conclusion: all wages in CZK

/*
 * calculation code for wages
 */
-- how many records in the czechia_payroll where calculation_code = 100 for wages?
SELECT 
	count(1) AS cpayroll_calculation_code_100
FROM czechia_payroll 
WHERE value_type_code = 5958 AND calculation_code = 100;
-- count = 1720 (= 3440 / 2)
-- how many records in the czechia_payroll where calculation_code = 200 for wages?
SELECT 
	count(1) AS cpayroll_calculation_code_200
FROM czechia_payroll 
WHERE value_type_code = 5958 AND calculation_code = 200;
-- count = 1720 (= 3440 / 2)
-- conclusion: no records lost if only calculation_code = 100 selected, for details see README

/*
 * missing data in JOIN columns? 
 */
-- missing payroll_year in czechia_payroll?
SELECT 
count(1) AS missing_cpayroll_year
FROM czechia_payroll
WHERE payroll_year IS NULL;
-- count = 0
-- missing payroll_quarter in czechia_payroll?
SELECT 
count(1) AS missing_cpayroll_quarter
FROM czechia_payroll 
WHERE payroll_quarter IS NULL;
-- count = 0
-- missing date_from in czechia_price?
SELECT 
count(1) AS missing_cprice_date_from
FROM czechia_price
WHERE date_from IS NULL;
-- count = 0
-- conclusion: no records lost when czechia_price and czechia_payroll joined as  
-- JOIN... ON cpay.payroll_year = year(cp.date_from) AND cpay.payroll_quarter = quarter(cp.date_from)

/*
 * missing data in other columns?
 */
-- missing data czechia_payroll value
SELECT 
	count(1) AS missing_cpayroll_value
FROM czechia_payroll 
WHERE value_type_code = 5958 AND value IS NULL;
-- count = 0
-- missing data industry_branch_code
SELECT 
	count(1) AS missing_cpayroll_industry_branch_code
FROM czechia_payroll  
WHERE value_type_code = 5958 AND industry_branch_code  IS NULL;
-- count = 172 
-- if not filled in, sum of all branches
-- missing data czechia_price value
SELECT 
	count(1) AS missing_cprice_value
FROM czechia_price
WHERE value IS NULL;
-- count = 0
-- missing data czechia_price region_code
SELECT 
	count(1) AS missing_cprice_region_code
FROM czechia_price 
WHERE region_code IS NULL;
-- count = 7217
-- if not filled in, record valid for Czechia

/*
 * creating the primary project table
 */
-- creating primary table
CREATE TABLE IF NOT EXISTS t_tereza_sindelarova_projekt_SQL_primary_final AS 
SELECT
	cpib.name AS payroll_industry_branch,
    cpay.value AS payroll_average_wages,
    cpu.name AS payroll_average_wages_unit,
    cpay.payroll_year AS payroll_year,
    cpay.payroll_quarter AS payroll_quarter,
    cpc.name AS price_category,
    cp.value AS price_value,
    cpc.price_value AS price_amount,
    cpc.price_unit AS price_unit, 
    cp.date_from AS price_date_from,
    cp.date_to AS price_date_to,
    cpay.industry_branch_code AS industry_branch_code,
    cp.category_code AS price_category_code 
FROM czechia_payroll AS cpay
JOIN czechia_price AS cp
	 ON cpay.payroll_year = year(cp.date_from)	AND cpay.payroll_quarter = quarter(cp.date_from)
LEFT JOIN czechia_payroll_industry_branch AS cpib 
	ON cpay.industry_branch_code = cpib.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code  = cpu.code 	
LEFT JOIN czechia_price_category AS cpc
	ON cp.category_code  = cpc.code 	
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code = 100 AND cp.region_code IS NULL
;

/*
 * survey of source tables from the database before creating the secondary table 
 */

/*
 * missing data in JOIN columns? 
 */
-- missing country in countries?
SELECT 
count(1) AS missing_countries_country
FROM countries 
WHERE country IS NULL;
-- count = 0
-- missing country in economies?
SELECT 
count(1) AS missing_economies_country
FROM economies
WHERE country IS NULL;
-- count = 0
-- conclusion: no records lost when countries and economies joined as  
-- JOIN... ON e.country = c.country

/*
 * missing data in other columns? 
 */
-- mising data countries continent
SELECT  
	count(1) AS missing_continents
FROM countries
WHERE continent IS NULL;
-- count = 4
SELECT  
	*
FROM countries
WHERE continent IS NULL;

-- missing data economies year
SELECT  
	count(1) AS missing_economies_year
FROM economies 
WHERE `year` IS NULL;
-- count = 0
-- missing data economies population
SELECT  
	count(1) AS missing_economies_population
FROM economies 
WHERE population IS NULL;
-- count = 103
SELECT  
	*
FROM economies 
WHERE population IS NULL;
-- includes Not classified countries and non-European countries
-- missing data economies GDP
SELECT  
	count(1) AS missing_economies_GDP
FROM economies 
WHERE GDP IS NULL;
-- count = 4074
-- conclusion: to be checked in the secondary project table
-- missing data economies gini
SELECT  
	count(1) AS missing_economies_gini
FROM economies 
WHERE gini IS NULL;
-- count = 14481
-- conclusion: to be checked in the secondary project table

-- creating secodary table
CREATE TABLE IF NOT EXISTS t_tereza_sindelarova_projekt_sql_secondary_final AS 
SELECT 
	e.country AS country,
	e.`year` AS `year`,
	e.population AS population,
	e.GDP AS GDP,
	e.gini AS gini		
FROM economies AS e
LEFT JOIN countries AS c 
	ON e.country = c.country
WHERE c.continent = 'Europe' AND e.`year` IN(
	SELECT 
		DISTINCT payroll_year
	FROM t_tereza_sindelarova_projekt_sql_primary_final
)
ORDER BY e.country, e.`year`
;

/*
 * missing GDP and gini in European countries
 */
-- missing data secondary table GDP
SELECT  
count(1) AS missing_GDP_secondary_table
FROM t_tereza_sindelarova_projekt_sql_secondary_final 
WHERE GDP IS NULL;
-- count = 37, see README.md
SELECT  
*
FROM t_tereza_sindelarova_projekt_sql_secondary_final 
WHERE GDP IS NULL;
-- missing data secondary table gini
SELECT  
count(1) AS missing_gini_secondary_table
FROM t_tereza_sindelarova_projekt_sql_secondary_final 
WHERE gini IS NULL;
-- count = 124, see README.md
SELECT  
*
FROM t_tereza_sindelarova_projekt_sql_secondary_final 
WHERE gini IS NULL;
