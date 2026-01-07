/*
PART 2 — Funnel Conversion Analysis (MercadoLibre)
Date range: 2025-01-01 to 2025-08-31
Goal:
1) Build funnel stage counts using CTEs + LEFT JOIN chain
2) Calculate conversion rates from first_visit to each stage
3) Segment funnel conversions by country
*/

/* -------------------------------------------------------
2.1 Funnel counts (overall)
------------------------------------------------------- */
WITH first_visit AS (
    SELECT DISTINCT user_id
    FROM mercadolibre_funnel
    WHERE event_name = 'first_visit'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
select_item AS (
    SELECT DISTINCT user_id
    FROM mercadolibre_funnel
    WHERE event_name IN ('select_item', 'select_promotion')
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_to_cart AS (
    SELECT DISTINCT user_id
    FROM mercadolibre_funnel
    WHERE event_name = 'add_to_cart'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
begin_checkout AS (
    SELECT DISTINCT user_id
    FROM mercadolibre_funnel
    WHERE event_name = 'begin_checkout'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_shipping_info AS (
    SELECT DISTINCT user_id
    FROM mercadolibre_funnel
    WHERE event_name = 'add_shipping_info'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_payment_info AS (
    SELECT DISTINCT user_id
    FROM mercadolibre_funnel
    WHERE event_name = 'add_payment_info'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
purchase AS (
    SELECT DISTINCT user_id
    FROM mercadolibre_funnel
    WHERE event_name = 'purchase'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
funnel_counts AS (
    SELECT
        COUNT(DISTINCT fv.user_id)  AS usuarios_first_visit,
        COUNT(DISTINCT si.user_id)  AS usuarios_select_item,
        COUNT(DISTINCT atc.user_id) AS usuarios_add_to_cart,
        COUNT(DISTINCT bc.user_id)  AS usuarios_begin_checkout,
        COUNT(DISTINCT asi.user_id) AS usuarios_add_shipping_info,
        COUNT(DISTINCT api.user_id) AS usuarios_add_payment_info,
        COUNT(DISTINCT p.user_id)   AS usuarios_purchase
    FROM first_visit fv
    LEFT JOIN select_item si        ON fv.user_id = si.user_id
    LEFT JOIN add_to_cart atc       ON fv.user_id = atc.user_id
    LEFT JOIN begin_checkout bc     ON fv.user_id = bc.user_id
    LEFT JOIN add_shipping_info asi ON fv.user_id = asi.user_id
    LEFT JOIN add_payment_info api  ON fv.user_id = api.user_id
    LEFT JOIN purchase p            ON fv.user_id = p.user_id
)

/* -------------------------------------------------------
2.2 Conversion rates from first_visit (%)
------------------------------------------------------- */
SELECT
    usuarios_first_visit,
    usuarios_select_item,
    usuarios_add_to_cart,
    usuarios_begin_checkout,
    usuarios_add_shipping_info,
    usuarios_add_payment_info,
    usuarios_purchase,

    ROUND(usuarios_select_item      * 100.0 / NULLIF(usuarios_first_visit, 0), 2) AS conversion_select_item,
    ROUND(usuarios_add_to_cart      * 100.0 / NULLIF(usuarios_first_visit, 0), 2) AS conversion_add_to_cart,
    ROUND(usuarios_begin_checkout   * 100.0 / NULLIF(usuarios_first_visit, 0), 2) AS conversion_begin_checkout,
    ROUND(usuarios_add_shipping_info* 100.0 / NULLIF(usuarios_first_visit, 0), 2) AS conversion_add_shipping_info,
    ROUND(usuarios_add_payment_info * 100.0 / NULLIF(usuarios_first_visit, 0), 2) AS conversion_add_payment_info,
    ROUND(usuarios_purchase         * 100.0 / NULLIF(usuarios_first_visit, 0), 2) AS conversion_purchase
FROM funnel_counts;


/* -------------------------------------------------------
2.3 Funnel conversion by country
------------------------------------------------------- */
WITH first_visits AS (
    SELECT DISTINCT user_id, country
    FROM mercadolibre_funnel
    WHERE event_name = 'first_visit'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
select_item AS (
    SELECT DISTINCT user_id, country
    FROM mercadolibre_funnel
    WHERE event_name IN ('select_item', 'select_promotion')
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_to_cart AS (
    SELECT DISTINCT user_id, country
    FROM mercadolibre_funnel
    WHERE event_name = 'add_to_cart'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
begin_checkout AS (
    SELECT DISTINCT user_id, country
    FROM mercadolibre_funnel
    WHERE event_name = 'begin_checkout'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_shipping_info AS (
    SELECT DISTINCT user_id, country
    FROM mercadolibre_funnel
    WHERE event_name = 'add_shipping_info'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
add_payment_info AS (
    SELECT DISTINCT user_id, country
    FROM mercadolibre_funnel
    WHERE event_name = 'add_payment_info'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
purchase AS (
    SELECT DISTINCT user_id, country
    FROM mercadolibre_funnel
    WHERE event_name = 'purchase'
      AND event_date BETWEEN '2025-01-01' AND '2025-08-31'
),
funnel_counts_country AS (
    SELECT
        fv.country,
        COUNT(DISTINCT fv.user_id)  AS usuarios_first_visit,
        COUNT(DISTINCT si.user_id)  AS usuarios_select_item,
        COUNT(DISTINCT atc.user_id) AS usuarios_add_to_cart,
        COUNT(DISTINCT bc.user_id)  AS usuarios_begin_checkout,
        COUNT(DISTINCT asi.user_id) AS usuarios_add_shipping_info,
        COUNT(DISTINCT api.user_id) AS usuarios_add_payment_info,
        COUNT(DISTINCT p.user_id)   AS usuarios_purchase
    FROM first_visits fv
    LEFT JOIN select_item si        ON fv.user_id = si.user_id AND fv.country = si.country
    LEFT JOIN add_to_cart atc       ON fv.user_id = atc.user_id AND fv.country = atc.country
    LEFT JOIN begin_checkout bc     ON fv.user_id = bc.user_id AND fv.country = bc.country
    LEFT JOIN add_shipping_info asi ON fv.user_id = asi.user_id AND fv.country = asi.country
    LEFT JOIN add_payment_info api  ON fv.user_id = api.user_id AND fv.country = api.country
    LEFT JOIN purchase p            ON fv.user_id = p.user_id AND fv.country = p.country
    GROUP BY fv.country
)
SELECT
    country,
    ROUND(usuarios_select_item       * 100.0 / NULLIF(usuarios_first_visit, 0), 2) AS conversion_select_item,
    ROUND(usuarios_add_to_cart       * 100.0 / NULLIF(usuarios_first_visit, 0), 2) AS conversion_add_to_cart,
    ROUND(usuarios_begin_checkout    * 100.0 / NULLIF(usuarios_first_visit, 0), 2) AS conversion_begin_checkout,
    ROUND(usuarios_add_shipping_info * 100.0 / NULLIF(usuarios_first_visit, 0), 2) AS conversion_add_shipping_info,
    ROUND(usuarios_add_payment_info  * 100.0 / NULLIF(usuarios_first_visit, 0), 2) AS conversion_add_payment_info,
    ROUND(usuarios_purchase          * 100.0 / NULLIF(usuarios_first_visit, 0), 2) AS conversion_purchase
FROM funnel_counts_country
ORDER BY conversion_purchase DESC;
