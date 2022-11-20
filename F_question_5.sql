/*
 *  question 5
 */
-- tables from question 4 utilized (_task4_price, _task4_pay)

-- creating an auxiliary table GDP
CREATE TABLE IF NOT EXISTS t_tereza_sindelarova_task5_gdp
SELECT 
	`year` AS year,
	 GDP AS GDP,
	 lag(GDP) OVER (ORDER BY `year`) AS GDP_prev_year,
	 GDP - lag(GDP) OVER (ORDER BY `year`) AS GDP_diff,
	 round(((GDP - lag(GDP) OVER (ORDER BY `year`)) / (lag(GDP) OVER (ORDER BY `year`))) * 100,2) AS GDP_diff_pct
FROM t_tereza_sindelarova_projekt_sql_secondary_final
WHERE country LIKE 'Czech%';

-- find high GDP year-to-year increase
SELECT 
	`year`,
	 GDP_diff_pct
FROM t_tereza_sindelarova_task5_gdp
ORDER BY GDP_diff_pct DESC;
-- increase > 5 % is considered high year-to-year increase

-- GDP increase > 5 % influence on same year's prices and wages
WITH  high_GDP_incr AS(
	SELECT 
	`year` AS GDP_year,
	 GDP_diff_pct AS GDP_diff_pct 
FROM t_tereza_sindelarova_task5_gdp
WHERE GDP_diff_pct > 5
) 
SELECT 
	hgdp.GDP_year AS GDP_year,
	hgdp.GDP_diff_pct AS GDP_diff_pct,
	price.A_price_year AS price_year,
	price.pct_diff AS price_pct_diff,
	pay.A_payroll_year AS payroll_year,
	pay.pct_diff AS wages_pct_diff
FROM high_GDP_incr AS hgdp
JOIN t_tereza_sindelarova_task4_price AS price
	ON hgdp.GDP_year = price.A_price_year
JOIN t_tereza_sindelarova_task4_pay AS pay
	ON hgdp.GDP_year = pay.A_payroll_year	
;

-- GDP increase > 5 % influence on next year's prices and wages
WITH  high_GDP_incr AS(
	SELECT 
	`year` AS GDP_year,
	 GDP_diff_pct AS GDP_diff_pct 
FROM t_tereza_sindelarova_task5_gdp
WHERE GDP_diff_pct > 5
) 
SELECT 
	hgdp.GDP_year AS GDP_year,
	hgdp.GDP_diff_pct AS GDP_diff_pct,
	price.A_price_year AS price_year,
	price.pct_diff AS price_pct_diff,
	pay.A_payroll_year AS payroll_year,
	pay.pct_diff AS wages_pct_diff
FROM high_GDP_incr AS hgdp
JOIN t_tereza_sindelarova_task4_price AS price
	ON hgdp.GDP_year = price.A_price_year - 1
JOIN t_tereza_sindelarova_task4_pay AS pay
	ON hgdp.GDP_year = pay.A_payroll_year  - 1	
;

-- years where GDP increase < 5 % as reference values 
WITH  high_GDP_incr AS(
	SELECT 
		`year` AS same_GDP_year
	FROM t_tereza_sindelarova_task5_gdp
	WHERE GDP_diff_pct > 5
	UNION 
	SELECT 
		`year` + 1 AS next_GDP_year
	FROM t_tereza_sindelarova_task5_gdp
	WHERE GDP_diff_pct > 5
) 
SELECT 
*
FROM(
	SELECT 
		price.A_price_year AS reference_price_year,
		price.pct_diff AS price_pct_diff
	FROM t_tereza_sindelarova_task4_price AS price
	WHERE price.A_price_year NOT IN(
	SELECT *
	FROM high_GDP_incr
	)
) AS tprice
JOIN
(
	SELECT 
		pay.A_payroll_year AS reference_payroll_year,
		pay.pct_diff AS payroll_pct_diff
	FROM t_tereza_sindelarova_task4_pay AS pay
	WHERE pay.A_payroll_year NOT IN(
	SELECT *
	FROM high_GDP_incr
	)
) AS tpay
ON tprice.reference_price_year = tpay.reference_payroll_year
;




