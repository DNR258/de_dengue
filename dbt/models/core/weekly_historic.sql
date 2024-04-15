{{
    config(
        materialized='table'
    )
}}

with  

epi_hist_s as (
    select hist.rec_id, 
           hist.country_full, 
           hist.country_short,
           hist.state,
           cale.day, 
           cale.dow as week_day,
           cale.epi_week_sun,
           cale.month, 
           cale.month_name, 
           cale.quarter,
           cale.year,
           hist.dengue_cases 
    from {{ ref('stg_hist_world_weekly_dengue_data') }} as hist
    inner join {{ ref('stg_iso_sun_calendar') }} as cale
    on hist.start_week = cale.date
    where cale.dow = 'Sunday'
), 
epi_hist_m as (
    select hist.rec_id, 
           hist.country_full, 
           hist.country_short,
           hist.state,
           cale.day, 
           cale.dow as week_day,
           cale.epi_week_mon,
           cale.month, 
           cale.month_name, 
           cale.quarter,
           cale.year,
           hist.dengue_cases 
           
    from {{ ref('stg_hist_world_weekly_dengue_data') }} as hist
    inner join {{ ref('stg_iso_sun_calendar') }} as cale
    on hist.start_week = cale.date
    where cale.dow = 'Monday'
), 
arg_y2023 as (
    select rec_id,
        'ARGENTINA' as country_full,
        'ARG' as country_short, 
        state,
        year,
        epi_S as epi_week_sun,
        dengue_cases
    from {{ ref('stg_y2023_arg_weekly_dengue_data') }}
), 
cale_grouped as (
    select  
        min(date) as min_date,
        epi_year_sun, 
        epi_week_sun, 
        day,
        dow,
        month, 
        month_name,
        quarter, 
        year
    from {{ ref('stg_iso_sun_calendar') }}
    where epi_year_sun > 2022
    group by 
        year, 
        epi_week_sun, 
        epi_year_sun,
        day,
        dow,
        month, 
        month_name,
        quarter
),
del_dupl as (
    select 
        *, 
        row_number() over(partition by epi_year_sun, epi_week_sun ORDER BY min_date ASC) as rn
    from cale_grouped
), 
clean_cal as (
    select 
        *
    from del_dupl
    where rn = 1                            -- creo puede obviarse y pasarse el where a la siguiente query
    order by min_date
),
arg_y2023_cal as (
    select arg_y2023.rec_id, 
           arg_y2023.country_full, 
           arg_y2023.country_short,
           arg_y2023.state,
           clean_cal.day, 
           clean_cal.dow as week_day,
           arg_y2023.epi_week_sun,
           clean_cal.month, 
           clean_cal.month_name, 
           clean_cal.quarter,
           clean_cal.year,
           arg_y2023.dengue_cases
    from arg_y2023
    left join clean_cal                          -- evaluar un inner
    on arg_y2023.epi_week_sun = clean_cal.epi_week_sun
    and arg_y2023.year = clean_cal.epi_year_sun  -- no creo sea necesario
), 
full_unioned as (
    select * from epi_hist_s
    union all
    select * from epi_hist_m
    union all
    select * from arg_y2023_cal
)

select * 
from full_unioned
