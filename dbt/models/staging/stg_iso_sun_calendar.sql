with 

source as (

    select * from {{ source('staging', 'iso_sun_calendar') }}

),

renamed as (

    select
        cast(date as date) as date,
        extract(day from  date) as day,
        format_date('%A', date) as dow, 
        cast(iso_sun_week as int) as epi_week_sun,
        cast(iso_sun_year as int) as epi_year_sun,
        cast(format_date('%V', date) as integer) as epi_week_mon,  
        cast(format_date('%m', date) as integer) as month,
        FORMAT_DATE('%B', date) as month_name,
        cast(format_date('%Q', date) as integer) as quarter,
        cast(extract(year from date) as integer) AS year,
        cast(format_date('%j', date) as integer) AS day_of_year

    from source

)

select * 
from renamed
order by date

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 1000

{% endif %}