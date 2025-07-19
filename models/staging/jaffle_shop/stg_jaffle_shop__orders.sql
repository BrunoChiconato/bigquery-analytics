with source as (

    select * from {{ ref('base_jaffle_shop__orders') }}

),

renamed_and_casted as (

    select
        id as order_id,
        customer as customer_id,
        store_id,

        cast(ordered_at as timestamp) as ordered_at,

        subtotal / 100.0 as subtotal_amount,
        tax_paid / 100.0 as tax_paid_amount,
        order_total / 100.0 as order_total_amount

    from source

)

select * from renamed_and_casted
