with customers as (

    select * from {{ ref('stg_jaffle_shop__customers') }}

),

orders as (

    select
        customer_id,
        min(ordered_at) as first_order_at,
        max(ordered_at) as most_recent_order_at,
        count(order_id) as number_of_orders,
        sum(order_total_amount) as lifetime_value
    from {{ ref('stg_jaffle_shop__orders') }}
    group by 1

),

final as (

    select
        c.customer_id,
        c.customer_name,
        o.first_order_at,
        o.most_recent_order_at,
        coalesce(o.number_of_orders, 0) as number_of_orders,
        coalesce(o.lifetime_value, 0) as lifetime_value

    from customers as c
    left join orders as o on c.customer_id = o.customer_id

)

select * from final
