/*
 *  question 2
 */

-- only records selected from czechia_price to the primary project table where region_code IS NULL -> average prices for Czechia
-- czechia_payroll industry_branch_code IS NULL -> average wages for all branches

-- units of milk and bread
SELECT 
	*
FROM czechia_price_category 
WHERE name LIKE '%chleb%' OR name LIKE '%chléb%' OR name LIKE '%mléko%';
-- bread 1 kg, milk 1 litr

-- do the payroll and price years match?
SELECT 
	payroll_year AS payroll_year,
	price_date_from AS price_date_from  
FROM t_tereza_sindelarova_projekt_sql_primary_final
WHERE payroll_year != year(price_date_from);
-- empty table -> years match

-- first time period 
SELECT 
	payroll_year AS year_first_time_period,
	price_date_from  
FROM t_tereza_sindelarova_projekt_sql_primary_final
ORDER BY payroll_year ASC
LIMIT 1; 
-- year 2006 
-- last time period
SELECT 
	payroll_year AS year_last_time_period,
	price_date_from  
FROM t_tereza_sindelarova_projekt_sql_primary_final
ORDER BY payroll_year DESC,payroll_quarter DESC 
LIMIT 1; 
-- year 2018 

-- bread in 2006
SELECT 
	tpay.payroll_year AS `year`,
	tpr.price_category,
	tpr.price_amount,
	tpr.price_unit,
	tpr.average_price,
	tpay.average_wages,
	round(tpay.average_wages / tpr.average_price, 2) AS units_per_wage
FROM (
SELECT 
	payroll_year,
	round(avg(payroll_average_wages),2) AS average_wages
FROM t_tereza_sindelarova_projekt_sql_primary_final
WHERE industry_branch_code IS NULL 
GROUP BY payroll_year
) AS tpay
JOIN (
	SELECT 
		year(price_date_from) AS price_year,
		price_category,
		price_amount,
		price_unit,
		round(avg(price_value),2) AS average_price
	FROM t_tereza_sindelarova_projekt_sql_primary_final
	WHERE price_category_code = 111301
	GROUP BY year(price_date_from)
) AS tpr
ON tpay.payroll_year = tpr.price_year
ORDER BY tpay.payroll_year ASC 
LIMIT 1;

-- bread in 2018
SELECT 
	tpay.payroll_year AS `year`,
	tpr.price_category,
	tpr.price_amount,
	tpr.price_unit,
	tpr.average_price,
	tpay.average_wages,
	round(tpay.average_wages / tpr.average_price, 2) AS units_per_wage
FROM (
SELECT 
	payroll_year,
	round(avg(payroll_average_wages),2) AS average_wages
FROM t_tereza_sindelarova_projekt_sql_primary_final
WHERE industry_branch_code IS NULL 
GROUP BY payroll_year
) AS tpay
JOIN (
	SELECT 
		year(price_date_from) AS price_year,
		price_category,
		price_amount,
		price_unit,
		round(avg(price_value),2) AS average_price
	FROM t_tereza_sindelarova_projekt_sql_primary_final
	WHERE price_category_code = 111301
	GROUP BY year(price_date_from)
) AS tpr
ON tpay.payroll_year = tpr.price_year
ORDER BY tpay.payroll_year DESC  
LIMIT 1;

-- milk in 2006
SELECT 
	tpay.payroll_year AS `year`,
	tpr.price_category,
	tpr.price_amount,
	tpr.price_unit,
	tpr.average_price,
	tpay.average_wages,
	round(tpay.average_wages / tpr.average_price, 2) AS units_per_wage
FROM (
SELECT 
	payroll_year,
	round(avg(payroll_average_wages),2) AS average_wages
FROM t_tereza_sindelarova_projekt_sql_primary_final
WHERE industry_branch_code IS NULL 
GROUP BY payroll_year
) AS tpay
JOIN (
	SELECT 
		year(price_date_from) AS price_year,
		price_category,
		price_amount,
		price_unit,
		round(avg(price_value),2) AS average_price
	FROM t_tereza_sindelarova_projekt_sql_primary_final
	WHERE price_category_code = 114201
	GROUP BY year(price_date_from)
) AS tpr
ON tpay.payroll_year = tpr.price_year
ORDER BY tpay.payroll_year ASC 
LIMIT 1;

-- milk in 2018
SELECT 
	tpay.payroll_year AS `year`,
	tpr.price_category,
	tpr.price_amount,
	tpr.price_unit,
	tpr.average_price,
	tpay.average_wages,
	round(tpay.average_wages / tpr.average_price, 2) AS units_per_wage
FROM (
SELECT 
	payroll_year,
	round(avg(payroll_average_wages),2) AS average_wages
FROM t_tereza_sindelarova_projekt_sql_primary_final
WHERE industry_branch_code IS NULL 
GROUP BY payroll_year
) AS tpay
JOIN (
	SELECT 
		year(price_date_from) AS price_year,
		price_category,
		price_amount,
		price_unit,
		round(avg(price_value),2) AS average_price
	FROM t_tereza_sindelarova_projekt_sql_primary_final
	WHERE price_category_code = 114201
	GROUP BY year(price_date_from)
) AS tpr
ON tpay.payroll_year = tpr.price_year
ORDER BY tpay.payroll_year DESC  
LIMIT 1;
