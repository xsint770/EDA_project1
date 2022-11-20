/*
 * question 4
 */

-- creating an auxiliary table price
CREATE OR REPLACE TABLE t_tereza_sindelarova_task4_price AS    
SELECT 
	A.`year` AS A_price_year,
	A.average_price_year AS A_average_price_year_all,
	B.`year` AS B_price_year,
	B.average_price_year AS B_average_price_year_all,
	A.average_price_year - B.average_price_year AS price_diff,
	round(((( A.average_price_year - B.average_price_year) / B.average_price_year) * 100),2) AS pct_diff
FROM (
	SELECT
        year(t1.price_date_from) AS `year`,
        round(avg(t1.price_value),2) AS average_price_year
    FROM t_tereza_sindelarova_projekt_sql_primary_final AS t1
    GROUP BY  year(t1.price_date_from)
    ORDER BY  year(t1.price_date_from)
	) AS A
JOIN (
	SELECT
        year(t2.price_date_from) AS `year`,
        round(avg(t2.price_value),2) AS average_price_year
    FROM t_tereza_sindelarova_projekt_sql_primary_final AS t2
    GROUP BY year(t2.price_date_from)
    ORDER BY year(t2.price_date_from)
	) AS B
ON  A.`year` =  B.`year` + 1
;

-- creating an auxiliary table payroll
CREATE OR REPLACE TABLE t_tereza_sindelarova_task4_pay AS 
SELECT 
	A.`year` AS A_payroll_year,
	A.average_wages AS A_average_wages_year,
	B.`year` AS B_payroll_year,
	B.average_wages AS B_average_wages_year,
	A.average_wages - B.average_wages AS wages_diff,
round(((( A.average_wages- B.average_wages) / B.average_wages) * 100),2) AS pct_diff
FROM (
	SELECT 
		t1.payroll_year AS `year`,
		t1.industry_branch_code AS industry_branch,
		round(avg(t1.payroll_average_wages),2)  AS average_wages
	FROM t_tereza_sindelarova_projekt_sql_primary_final AS t1
	WHERE t1.industry_branch_code IS NULL 
	GROUP BY t1.payroll_year
	) AS A
JOIN (
	SELECT 
		t2.payroll_year AS `year`,
		t2.industry_branch_code AS industry_branch,
		round(avg(t2.payroll_average_wages),2)  AS average_wages
	FROM t_tereza_sindelarova_projekt_sql_primary_final AS t2
	WHERE t2.industry_branch_code IS NULL 
	GROUP BY t2.payroll_year
	) AS B
ON  A.`year` = B.`year` + 1
;

-- comparing year-to-year price change and year-to-year payroll change 
SELECT 
	tprice.A_price_year AS `year`,
	tprice.B_price_year AS year_prev,
	tprice.pct_diff AS price_pct_diff,
	tpay.pct_diff AS payroll_pct_diff,
	tpay.pct_diff  - tprice.pct_diff AS diff_payroll_price_pct
FROM t_tereza_sindelarova_task4_price AS tprice
JOIN 
	t_tereza_sindelarova_task4_pay AS tpay
ON tprice.A_price_year = tpay.A_payroll_year
;

-- comparing year-to-year price change and year-to-year payroll change, only price increase selected (positive year-to-year price change)
SELECT 
	tprice.A_price_year AS `year`,
	tprice.B_price_year AS year_prev,
	tprice.pct_diff AS price_pct_diff,
	tpay.pct_diff AS payroll_pct_diff,
	tpay.pct_diff  - tprice.pct_diff AS diff_payroll_price_pct_increase
FROM t_tereza_sindelarova_task4_price AS tprice
JOIN 
	t_tereza_sindelarova_task4_pay AS tpay
ON tprice.A_price_year = tpay.A_payroll_year
WHERE tprice.pct_diff > 0
;




