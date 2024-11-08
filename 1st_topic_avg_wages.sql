/*
 * 	Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?		*1
 */


-- zjistíme průměrné mzdy pro jednotlivé odvětví za sledovaná období

CREATE OR REPLACE VIEW avg_wages AS
SELECT
	industry,
	payroll_year,
	average_wages 
FROM t_sebastian_urbis_project_sql_primary_final tsupspf
GROUP BY industry, payroll_year
ORDER BY industry;


 -- vytvoříme tabulku s procentuálním přehledem růstu/poklesu průměrných mezd
CREATE OR REPLACE VIEW avg_wages_growth AS
SELECT
	aw.industry, 
	aw.payroll_year,
	aw2.payroll_year  AS year_previous,
	ROUND ((aw.average_wages - aw2.average_wages) / aw2.average_wages * 100, 2) AS wage_growth
FROM avg_wages aw 
JOIN avg_wages aw2 
	ON aw.industry = aw2.industry 
	AND aw.payroll_year = aw2.payroll_year + 1;



SELECT *
FROM avg_wages_growth awg
WHERE wage_growth < -5;

/*
 *  Mzdy ve všech odvětvích rostou avšak různým tempem. V každém odvětví jsme během sledovaného období v letech 2006-2018 zaznamenali pokles průměrné mzdy.
 *  Nejmarkantnější pokles mzdy jsme zaznameli v sektoru "Peněžnictví a pojišťovnictví" v roce 2013 a "Zemědělství, lesnictví, rybářství" v roce 2018.
 * 
 */
