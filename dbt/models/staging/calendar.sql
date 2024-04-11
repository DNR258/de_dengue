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
    cast(FORMAT_DATE('%V', d) as integer) AS EpiWeekM, 
	cast(FORMAT_DATE('%V', e) as integer) AS EpiWeekS, 
	cast(FORMAT_DATE('%u', d) as integer) AS DayOfWeek,
    cast(FORMAT_DATE('%m', d) as integer) AS Month,
    FORMAT_DATE('%B', d) AS MonthName,
    cast(FORMAT_DATE('%Q', d) as integer) AS Quarter,
    cast(EXTRACT(year FROM d) as integer) AS Year,
    cast(FORMAT_DATE('%j', d) as integer) AS DayOfYear
   FROM de
)
SELECT *
FROM src
ORDER BY Date

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}