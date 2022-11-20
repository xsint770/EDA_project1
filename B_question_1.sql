/*
 *  question 1
 */

-- creating an auxiliary table
CREATE OR REPLACE TABLE t_tereza_sindelarova_task1 AS 
SELECT 
	A.payroll_industry_branch AS payroll_industry_branch1,
	A.payroll_year AS payroll_year1,
	A.year_average_wage1 AS year_average_wage1,
	B.payroll_industry_branch AS payroll_industry_branch2,
	B.payroll_year AS payroll_year2,
	B.year_average_wage2 AS year_average_wage2,
	A.year_average_wage1 - B.year_average_wage2 AS diff_wages
FROM (
	SELECT
		t1.payroll_industry_branch,
		t1.payroll_year,
		round(avg(t1.payroll_average_wages),2) AS year_average_wage1
		FROM t_tereza_sindelarova_projekt_sql_primary_final AS t1
		GROUP BY t1.payroll_industry_branch, t1.payroll_year 
		ORDER BY t1.payroll_industry_branch, t1.payroll_year 
) AS A
JOIN (
	SELECT
		t2.payroll_industry_branch,
		t2.payroll_year,
		round(avg(t2.payroll_average_wages),2) AS year_average_wage2
		FROM t_tereza_sindelarova_projekt_sql_primary_final AS t2
		GROUP BY t2.payroll_industry_branch, t2.payroll_year 
		ORDER BY t2.payroll_industry_branch, t2.payroll_year
) AS B
ON A.payroll_industry_branch = B.payroll_industry_branch AND A.payroll_year = B.payroll_year + 1
;

-- search for negative year-to-year wage differences
-- branches
SELECT 
	DISTINCT payroll_industry_branch1 AS negative_wage_increase
FROM t_tereza_sindelarova_task1
WHERE diff_wages < 0
ORDER BY payroll_industry_branch1,payroll_year1;
-- branches and detailes
SELECT 
	payroll_industry_branch1 AS payroll_industry_branch,
	payroll_year1,
	payroll_year2,
	year_average_wage1 AS first_year_average_wage,
	year_average_wage2 AS second_year_average_wage,
	diff_wages AS wages_YY_difference
FROM t_tereza_sindelarova_task1
WHERE diff_wages < 0
ORDER BY payroll_industry_branch1,payroll_year1;

-- all branches
SELECT 
	DISTINCT payroll_industry_branch1 AS list_of_branches
FROM t_tereza_sindelarova_task1
ORDER BY payroll_industry_branch1;



