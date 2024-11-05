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

