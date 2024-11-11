/*
 * 	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)? 	*4
 */

-- 1. zjistíme meziroční nárůst pruměrné mzdy ze všech odvětví dohromady v danémm roce 



CREATE OR REPLACE VIEW year_avg_wage AS
SELECT
	industry,
	payroll_year,
	ROUND(avg(average_wages), 2) AS avg_wage
FROM avg_wages aw -- můžeme použít jíž vytvřenou tabulku z předchozího úkolu
GROUP BY payroll_year;
;

CREATE OR REPLACE VIEW avg_wage_year_increase AS 
SELECT
	yaw.payroll_year AS year_before,
	yaw.avg_wage AS wage_before,
	yaw2.payroll_year AS year_current,
	yaw2.avg_wage AS wage_current,
	ROUND((yaw2.avg_wage - yaw.avg_wage) / yaw.avg_wage * 100, 2) AS wage_difference 
FROM year_avg_wage yaw
JOIN year_avg_wage yaw2 
	ON yaw.industry = yaw2.industry 
	AND yaw2.payroll_year = yaw.payroll_year + 1;


-- 2. zjistíme meziroční nárůst pruměrné ceny potravin ze všech kategorií dohromady v danémm roce



CREATE OR REPLACE VIEW year_avg_price AS
SELECT
	category,
	year_pay,
	ROUND(avg(avg_price), 2) AS avg_food_price
FROM food_price_increase fpi -- můžeme použít jíž vytvřenou tabulku z předchozího úkolu
GROUP BY year_pay;

CREATE OR REPLACE VIEW year_avg_price_increase AS
SELECT 
	yap.year_pay AS f_year_before,
	yap.avg_food_price AS f_price_before,
	yap2.year_pay AS f_year_current,
	yap2.avg_food_price AS f_price_current,
	ROUND((yap2.avg_food_price - yap.avg_food_price) / yap.avg_food_price * 100, 2) AS price_difference 
FROM year_avg_price yap
JOIN year_avg_price yap2 
	ON yap.category = yap2.category
		AND yap2.year_pay = yap.year_pay +1;
	
	
-- 3. spojíme tabulky pro porovnání meziročního růstu cen a mezd

	
SELECT 
	yapi.f_year_current,
	yapi.price_difference,
	awyi.year_current,
	awyi.wage_difference, 
	yapi.price_difference - awyi.wage_difference AS percent_difference
FROM year_avg_price_increase yapi
JOIN avg_wage_year_increase awyi 
	ON yapi.f_year_before = awyi.year_before 
;

/*
 *	Z porovnání růstu průměrných cen a mezd jsme zjistili, že v žádném roce nebyl růst ceny potravin vyšší než růst mezd. Nejětší rozdíl jsme zaznamenali v roce 2013 a to 7,15%.
 */
