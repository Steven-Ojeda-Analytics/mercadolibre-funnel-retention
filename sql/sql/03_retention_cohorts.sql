/* ============================================================
   MercadoLibre — Retention & Cohort Analysis (SQL)
   Dataset: mercadolibre_retention
   Date range: 2025-01-01 to 2025-08-31
   Goal: Measure user retention (D7, D14, D21, D28) by country
         and by signup cohort (YYYY-MM).
   ============================================================ */


/* ------------------------------------------------------------
   1) Cumulative active users by country (counts only)
   - Active users (active = 1)
   - Cumulative rule: day_after_signup >= {7,14,21,28}
   - Avoid duplicates with COUNT(DISTINCT ...)
   ------------------------------------------------------------ */

SELECT
    country,
    COUNT(DISTINCT CASE WHEN day_after_signup >= 7  AND active = 1 THEN user_id END) AS users_d7,
    COUNT(DISTINCT CASE WHEN day_after_signup >= 14 AND active = 1 THEN user_id END) AS users_d14,
    COUNT(DISTINCT CASE WHEN day_after_signup >= 21 AND active = 1 THEN user_id END) AS users_d21,
    COUNT(DISTINCT CASE WHEN day_after_signup >= 28 AND active = 1 THEN user_id END) AS users_d28
FROM mercadolibre_retention
WHERE activity_date BETWEEN '2025-01-01' AND '2025-08-31'
GROUP BY country
ORDER BY country;


/* ------------------------------------------------------------
   2) Retention % by country
   - Retention Dx = active users at Dx / total unique users
   - Rounded to 1 decimal
   - Avoid division by zero with NULLIF
   ------------------------------------------------------------ */

SELECT
  country,
  ROUND(
    COUNT(DISTINCT CASE WHEN day_after_signup >= 7  AND active = 1 THEN user_id END)
    * 100.0 / NULLIF(COUNT(DISTINCT user_id), 0), 1
  ) AS retention_d7_pct,
  ROUND(
    COUNT(DISTINCT CASE WHEN day_after_signup >= 14 AND active = 1 THEN user_id END)
    * 100.0 / NULLIF(COUNT(DISTINCT user_id), 0), 1
  ) AS retention_d14_pct,
  ROUND(
    COUNT(DISTINCT CASE WHEN day_after_signup >= 21 AND active = 1 THEN user_id END)
    * 100.0 / NULLIF(COUNT(DISTINCT user_id), 0), 1
  ) AS retention_d21_pct,
  ROUND(
    COUNT(DISTINCT CASE WHEN day_after_signup >= 28 AND active = 1 THEN user_id END)
    * 100.0 / NULLIF(COUNT(DISTINCT user_id), 0), 1
  ) AS retention_d28_pct
FROM mercadolibre_retention
WHERE activity_date BETWEEN '2025-01-01' AND '2025-08-31'
GROUP BY country
ORDER BY country;


/* ------------------------------------------------------------
   3) Define signup cohort per user (validation sample)
   - Cohort = YYYY-MM based on first signup_date per user
   - LIMIT 5 only to validate the logic
   ------------------------------------------------------------ */

SELECT
    user_id,
    MIN(signup_date) AS signup_date,
    TO_CHAR(DATE_TRUNC('month', MIN(signup_date)), 'YYYY-MM') AS cohort
FROM mercadolibre_retention
GROUP BY user_id
LIMIT 5;


/* ------------------------------------------------------------
   4) Retention % by cohort (YYYY-MM)
   Steps:
   - cohort CTE: cohort per user (first signup month)
   - activity CTE: join cohort back to activity rows
   - final: retention Dx by cohort (same logic as by country)
   ------------------------------------------------------------ */

WITH cohort AS (
  SELECT
    user_id,
    TO_CHAR(DATE_TRUNC('month', MIN(signup_date)), 'YYYY-MM') AS cohort
  FROM mercadolibre_retention
  GROUP BY user_id
),
activity AS (
  SELECT
      r.user_id,
      c.cohort,
      r.day_after_signup,
      r.active
  FROM mercadolibre_retention r
  LEFT JOIN cohort c ON r.user_id = c.user_id
  WHERE r.activity_date BETWEEN '2025-01-01' AND '2025-08-31'
)
SELECT
    cohort,
    ROUND(
      100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 7  AND active = 1 THEN user_id END)
      / NULLIF(COUNT(DISTINCT user_id), 0), 1
    ) AS retention_d7_pct,
    ROUND(
      100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 14 AND active = 1 THEN user_id END)
      / NULLIF(COUNT(DISTINCT user_id), 0), 1
    ) AS retention_d14_pct,
    ROUND(
      100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 21 AND active = 1 THEN user_id END)
      / NULLIF(COUNT(DISTINCT user_id), 0), 1
    ) AS retention_d21_pct,
    ROUND(
      100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 28 AND active = 1 THEN user_id END)
      / NULLIF(COUNT(DISTINCT user_id), 0), 1
    ) AS retention_d28_pct
FROM activity
GROUP BY cohort
ORDER BY cohort;
