/*	SQL Projekt 
 * 
 *	spojení primárních tabulek
 *
 */

 -- nejdřív musíme zjisit jaké je společné porovantelné období


SELECT 
	payroll_year 
FROM czechia_payroll cp
GROUP BY payroll_year;


SELECT 
	YEAR (date_from) 
FROM czechia_price cp
GROUP BY YEAR (date_from);

	-- z dostupných informací jsme zjistili, že společné porovnatelné období jsou roky 2006-2018

/*
 * Table t_sebastian_urbis_project_SQL_primary_final	*1
 */

CREATE OR REPLACE VIEW t_sebastian_urbis_project_SQL_primary_final AS
SELECT
    cpc.name AS food_category, 
    cp.value AS price,
    cpc.price_value AS rounding_value,
    cpc.price_unit AS rounding_unit,
    DATE_FORMAT(cp.date_from, '%d.%m.%Y') AS price_measured_from,
    DATE_FORMAT(cp.date_to, '%d.%m.%Y') AS price_measured_to,
    cpib.name AS industry,
    cpay.value AS average_wages,
    cpay.payroll_year
FROM czechia_price AS cp
JOIN czechia_payroll AS cpay
    ON YEAR(cp.date_from) = cpay.payroll_year AND
    cpay.value_type_code = 5958 AND
    cp.region_code IS NULL
JOIN czechia_price_category cpc
    ON cp.category_code = cpc.code
JOIN czechia_payroll_industry_branch cpib
    ON cpay.industry_branch_code = cpib.code;

 -- pojítko pro naše tabulky byl společný rok, díky tomu jsme si mohli vypsat všechna potřebná data pro anlýzu výzkumných otázek


/*
 * Table t_sebastian_urbis_project_SQL_secondary_final		*2
 */

CREATE OR REPLACE VIEW t_sebastian_urbis_project_SQL_secondary_final AS
SELECT
	c.country,
	c.capital_city,
	c.currency_code,
	c.population,
	c.region_in_world,
	e.`year`,
	e.GDP 
FROM countries c
JOIN economies e 
	ON c.country = e.country
		WHERE c.continent = 'Europe'
			AND e.`year` BETWEEN 2006 AND 2018; 

 -- na základě zadání jsme se soustředili na Evropské státy, kde je stěžejní údaj HDP
