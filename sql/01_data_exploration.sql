/*
====================================================
Project: MercadoLibre Funnel & Retention Analysis
Section: Data Exploration
Author: Steven Ojeda
Context: TripleTen Data Analyst Bootcamp (Academic Project)
====================================================
*/

/*
----------------------------------------------------
1. Explore funnel table structure
Objective:
- Understand the schema of mercadolibre_funnel
- Identify relevant columns for funnel analysis
----------------------------------------------------
*/

SELECT
    *
FROM mercadolibre_funnel
LIMIT 5;


/*
----------------------------------------------------
2. Explore retention table structure
Objective:
- Understand the schema of mercadolibre_retention
- Identify relevant columns for cohort analysis
----------------------------------------------------
*/

SELECT
    *
FROM mercadolibre_retention
LIMIT 5;


/*
----------------------------------------------------
3. Identify funnel events
Objective:
- Confirm event sequence used in the funnel
----------------------------------------------------
*/

SELECT
    DISTINCT event_name
FROM mercadolibre_funnel
ORDER BY event_name;
