/*
 * question 3
 */

-- creating an auxiliary table
CREATE OR REPLACE TABLE t_tereza_sindelarova_task3 AS 
SELECT 
	A.price_category AS A_price_category,
	A.`year` AS A_year,
	A.average_price_year AS A_average_price_year,
	B.price_category AS B_price_category,
	B.`year` AS B_year,
	B.average_price_year AS B_average_price_year,
	A.average_price_year - B.average_price_year AS price_diff,
	round(((( A.average_price_year - B.average_price_year) / B.average_price_year) * 100),2) AS pct_diff
FROM (
	SELECT
		t1.price_category AS price_category,
        year(t1.price_date_from) AS `year`,
        round(avg(t1.price_value),2) AS average_price_year
    FROM t_tereza_sindelarova_projekt_sql_primary_final AS t1
    GROUP BY t1.price_category_code, year(t1.price_date_from)
	) AS A
JOIN (
	SELECT
		t2.price_category AS price_category,
        year(t2.price_date_from) AS `year`,
        round(avg(t2.price_value),2) AS average_price_year
    FROM t_tereza_sindelarova_projekt_sql_primary_final AS t2
    GROUP BY t2.price_category_code, year(t2.price_date_from)
	) AS B
ON A.price_category = B.price_category AND A.`year`	= B.`year` + 1
ORDER BY A.price_category, A.`year`;

-- the lowest price increase in the time period, incl. negative values
SELECT  
	A_price_category AS price_category,
	A_year AS `year`,
	B_year AS prev_year,
	pct_diff AS average_pct_diff_incl_negat
FROM t_tereza_sindelarova_task3 
WHERE pct_diff IN(
	SELECT 
		min(pct_diff)
	FROM t_tereza_sindelarova_task3 	
);

-- the lowest price increase in the time period, only positive values
SELECT  
	A_price_category AS price_category,
	A_year AS `year`,
	B_year AS prev_year,
	pct_diff AS average_pct_diff_only_posit
FROM t_tereza_sindelarova_task3 
WHERE pct_diff IN(
	SELECT 
		min(pct_diff)
	FROM t_tereza_sindelarova_task3 
	WHERE pct_diff > 0
);

-- the first year of the time period
 SELECT 
		min(B_year) AS first_year 
FROM t_tereza_sindelarova_task3;
-- 2006
-- the last year of the time period
 SELECT 
		max(A_year) AS last_year 
FROM t_tereza_sindelarova_task3;
-- 2018

-- price difference 2006 vs. 2018 incl. negative
SELECT 
  T18.A_price_category,
  T18.A_average_price_year AS price_2018,
  T06.B_average_price_year AS price_2006,
  T18.A_average_price_year - T06.B_average_price_year AS price_diff_2006_2018_incl_neg,
  round(((T18.A_average_price_year - T06.B_average_price_year) / T06.B_average_price_year) * 100, 2) AS pct_price_diff_2006_2018_incl_neg
FROM (
	SELECT 
		A_price_category,
		A_average_price_year 
	FROM t_tereza_sindelarova_task3
	WHERE A_year = 2018
	) AS T18
JOIN ( 
	SELECT 
		B_price_category,
		B_average_price_year 
	FROM t_tereza_sindelarova_task3
	WHERE B_year = 2006
	) AS T06
ON A_price_category = B_price_category
ORDER BY round(((T18.A_average_price_year - T06.B_average_price_year) / T06.B_average_price_year) * 100, 2)
;

-- price difference 2006 vs. 2018 only positive
SELECT 
  T18.A_price_category,
  T18.A_average_price_year AS price_2018,
  T06.B_average_price_year AS price_2006,
  T18.A_average_price_year - T06.B_average_price_year AS price_diff_2006_2018_posit,
  round(((T18.A_average_price_year - T06.B_average_price_year) / T06.B_average_price_year) * 100, 2) AS pct_price_diff_2006_2018_posit
FROM (
	SELECT 
		A_price_category,
		A_average_price_year 
	FROM t_tereza_sindelarova_task3
	WHERE A_year = 2018
	) AS T18
JOIN ( 
	SELECT 
		B_price_category,
		B_average_price_year 
	FROM t_tereza_sindelarova_task3
	WHERE B_year = 2006
	) AS T06
ON A_price_category = B_price_category
HAVING round(((T18.A_average_price_year - T06.B_average_price_year) / T06.B_average_price_year) * 100, 2) > 0
ORDER BY round(((T18.A_average_price_year - T06.B_average_price_year) / T06.B_average_price_year) * 100, 2)
; 







