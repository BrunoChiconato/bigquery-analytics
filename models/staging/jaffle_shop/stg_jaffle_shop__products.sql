with source as (

    select * from {{ source('jaffle_shop', 'raw_products') }}

),

renamed as (

    select
        sku as product_id,
        name as product_name,
        type as product_type,
        price / 100.0 as price_amount,
        description as product_description
    from source

)

select * from renamed
