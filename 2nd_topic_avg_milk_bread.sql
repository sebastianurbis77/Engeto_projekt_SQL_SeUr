/* 
 * Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?		*2
 */


-- nejdříve vybereme potřebná data k sledování

CREATE OR REPLACE VIEW avg_milk_bread AS
SELECT 
	food_category,
	price,
	rounding_value,
	rounding_unit,
	payroll_year,
	average_wages 
FROM t_sebastian_urbis_project_sql_primary_final tsupspf
WHERE payroll_year IN(2006, 2018)
	AND food_category IN('Mléko polotučné pasterované', 'Chléb konzumní kmínový');


-- následně zjistíme průměrnou cenu potravin a mezd ve sledovaném období 

SELECT
	food_category,
	rounding_value,
	rounding_unit,
	ROUND(AVG(price), 2) AS avg_price,
	ROUND(AVG(average_wages), 2) AS avg_wage_2,
	payroll_year 
FROM avg_milk_bread amb
GROUP BY 
	food_category,
	payroll_year;


/*
 *  V roce 2006 jsem si za průměrnou mzdu mohli pořídít 1287,46 Kg chleba za cenu 16,12/kg a 1437,24 L mléka za cenu 14,44/l.
 * 	V roce 2018 jsem si za průměrnou mzdu mohli pořídit 1342,24 Kg chleba za cenu 24,24/kg a 1641,57 L mléka za cenu 19,82/l.
 * 
 */
