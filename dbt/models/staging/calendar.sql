{{
    config(
        materialized='view'
    )
}}

WITH de AS
(SELECT date_add(CAST('1924-01-01' AS DATE), interval n day) AS d,
date_add(CAST('2024-01-01' AS DATE), interval n+2 day) AS e
FROM UNNEST(GENERATE_ARRAY(1, 40000)) AS n), 
src AS (
  SELECT
    CAST(d AS DATE) AS Date,
    EXTRACT(day FROM  d) AS Day,
    FORMAT_DATE('%A', d) AS dow, 
    FORMAT_DATE('%V', d) AS EpiWeekM, 
	FORMAT_DATE('%V', e) AS EpiWeekS, 
	FORMAT_DATE('%u', d) AS DayOfWeek,
    FORMAT_DATE('%m', d) AS Month,
    FORMAT_DATE('%B', d) AS MonthName,
    FORMAT_DATE('%Q', d) AS Quarter,
    EXTRACT(year FROM d) AS Year,
    FORMAT_DATE('%j', d) AS DayOfYear
   FROM de
)
SELECT *
FROM src
ORDER BY Date

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}