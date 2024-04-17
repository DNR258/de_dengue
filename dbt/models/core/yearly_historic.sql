{{
    config(
        materialized='table'
    )
}}

with

weekly_grouped as (
    select 
        year as w_year, 
        country_full as w_country_full, 
        country_short as w_country_short,
        sum(dengue_cases) as w_total_cases
    from 
        {{ ref('weekly_historic') }}
    group by 
        w_year, 
        w_country_full, 
        w_country_short
    order by 
        w_year, 
        w_country_full, 
        w_country_short
),
monthly_grouped as (
    select 
        extract(year from start_month) as m_year,
        country_full as m_country_full,
        country_short as m_country_short, 
        sum(dengue_cases) as m_total_cases
    from 
        {{ ref('stg_hist_world_monthly_dengue_data') }} 
    group by 
        extract(year from start_month),
        m_country_full,
        m_country_short
    order by 
        m_year,
        m_country_full,
        m_country_short
),
yearly_grouped as (
    select 
        extract(year from start_year) as y_year, 
        country_full as y_country_full, 
        country_short as y_country_short, 
        sum(dengue_cases) as y_total_cases
    from 
        {{ ref('stg_hist_world_yearly_dengue_data') }}
    group by 
        y_year, 
        y_country_full, 
        y_country_short
    order by 
        y_year, 
        y_country_full, 
        y_country_short
),
joining_year_month as (
    select 
        coalesce(y_year, m_year) as ym_year, 
        coalesce(y_country_full, m_country_full) as ym_country, 
        y_total_cases, 
        m_total_cases 
    from 
        monthly_grouped as mg
    full outer join 
        yearly_grouped as yg
    on 
        mg.m_year = yg.y_year 
    and 
        mg.m_country_full = yg.y_country_full
),
joining_y_m_week as (
    select 
        coalesce(ym_year, w_year) as year, 
        coalesce(ym_country, w_country_full) as country, 
        ym.y_total_cases, 
        ym.m_total_cases,
        wg.w_total_cases 
    from 
        joining_year_month as ym
    full outer join 
        weekly_grouped as wg
    on 
        ym.ym_year = wg.w_year 
    and 
        ym.ym_country = wg.w_country_full
),
preparing as (
    select 
        year, 
        country, 
        case 
            when y_total_cases is null then 0
            else y_total_cases
        end as y_total_cases, 
        case 
            when m_total_cases is null then 0
            else m_total_cases
        end as m_total_cases, 
        case 
            when w_total_cases is null then 0
            else w_total_cases
        end as w_total_cases,
from joining_y_m_week
)
select 
    year, 
    country, 
    case 
        when y_total_cases > m_total_cases 
        then 
            case 
                when y_total_cases > w_total_cases
                then y_total_cases
                else w_total_cases
            end
        else 
            case 
                when m_total_cases > w_total_cases
                then m_total_cases
                else w_total_cases
            end
    end as total_cases 
from 
    preparing
order by 
    year