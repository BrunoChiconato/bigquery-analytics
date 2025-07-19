with source as (

    select * from {{ source('jaffle_shop', 'raw_stores') }}

),

renamed as (

    select
        id as store_id,
        name as store_name,
        cast(opened_at as timestamp) as opened_at,
        tax_rate
    from source

)

select * from renamed
