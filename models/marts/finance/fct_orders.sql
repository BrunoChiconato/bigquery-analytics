with orders as (

    select * from {{ ref('stg_jaffle_shop__orders') }}

),

final as (

    select

        order_id,
        customer_id,
        store_id,
        ordered_at,
        order_total_amount,
        subtotal_amount,
        tax_paid_amount

    from orders
)

select * from final
