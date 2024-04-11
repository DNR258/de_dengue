{{
    config(
        materialized='view'
    )
}}

with source as (

    select *, 
        row_number() over(partition by provincia_residencia, anio_min, sepi_min) as rn
    from {{ source('staging', 'y2023_arg_dengue_data') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['provincia_residencia', 'anio_min', 'sepi_min'])}} as rec_id,
        provincia_residencia as state,
        anio_min as year,
        sepi_min as epi_S,
        total as dengue_cases

    from source
    where rn = 1
)

select * from renamed

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}