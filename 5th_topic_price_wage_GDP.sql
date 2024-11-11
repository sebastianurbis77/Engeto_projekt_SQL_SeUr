/*
 * 	Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?	*5
 */

-- zjistíme meziroční růst HDP v České Republice a propojíme s výsledky měření z předchozího cvičení

CREATE OR REPLACE VIEW cz_gdp AS
SELECT
	country,
	`year`,
	GDP
FROM t_sebastian_urbis_project_sql_secondary_final tf2
WHERE country = 'Czech Republic'
;

CREATE OR REPLACE VIEW gdp_year AS
SELECT
	cg.`year` AS gdp_year_before,
	cg.GDP AS gdp_before,
	cg2.`year` AS gdp_year_current,
	cg2.GDP AS gdp_current,
	ROUND(avg(cg2.GDP - cg.GDP) / cg2.GDP * 100, 2) AS gdp_difference 
FROM cz_gdp cg
JOIN cz_gdp cg2 
	ON cg.country = cg2.country
	AND cg2.`year` = cg.`year` + 1
GROUP BY cg.`year`
;

CREATE OR REPLACE VIEW price_wage_gdp AS
SELECT
	yapw.f_year_current,
	yapw.price_difference,
	yapw.year_current,
	yapw.wage_difference,
	gy.gdp_year_current,
	gy.gdp_current,
	gdp_difference
FROM year_avg_price_wage yapw 
JOIN gdp_year gy
	ON yapw.f_year_current = gy.gdp_year_current;

SELECT *
FROM price_wage_gdp pwg
;

-- výrazný růst HDP jsme zaznamenali v letech 2007, 2015 a 2017
-- v roce 2007 vzrostlo HDP o 5,28% byl růst ceny potravin 6,74% a mezd 7,59% v následujícím roce pak ceny potravin 6,19% a mzdy 10,47%
-- v roce 2015 vzrostlo HDP o 5,11% jsme naopak zaznamenali pokles ceny potravin -0,54% a růst mezd 1,53%, a v následujícím ceny potravin klesly o -1,21% a mzdy vzrostly o 7,33%
-- na základě zjištěných dat nelze s jistotou potvrdit přímy vliv růstu HDP na ceny potravin a výšku mezd
