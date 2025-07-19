with source as (

    select * from {{ ref('base_jaffle_shop__supplies') }}

),

renamed as (

    select
        id as supply_id,
        name as supply_name,
        cost as supply_cost,
        perishable as is_perishable,
        sku as product_id
    from source

)

select * from renamed
