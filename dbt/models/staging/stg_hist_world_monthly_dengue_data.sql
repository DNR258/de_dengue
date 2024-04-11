{{
    config(
        materialized='view'
    )
}}

with source as (

    select *, 
        row_number() over(partition by iso_a0, adm_1_name, calendar_start_date) as rn
    from {{ source('staging', 'hist_world_dengue_data') }}
    where t_res = 'Month'

),

renamed as (

    select
        --identifiers
        {{ dbt_utils.generate_surrogate_key(['iso_a0', 'adm_1_name', 'calendar_start_date'])}} as rec_id,
        adm_0_name as country_full,
        iso_a0 as country_short,
        adm_1_name as state,
        t_res as time_resolution,

        --timestamps
        calendar_start_date as start_month,
        calendar_end_date as end_month,

        --recorded cases
        dengue_total as dengue_cases

    from source
    where rn = 1

)

select * from renamed

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}
