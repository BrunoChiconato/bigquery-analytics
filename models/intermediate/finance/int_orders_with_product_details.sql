select

    ord.order_id,
    ord.customer_id,
    ord.store_id,
    prd.product_id,
    ord.ordered_at,
    prd.product_name,
    prd.product_type,
    ord.order_total_amount,
    prd.price_amount

from {{ ref('stg_jaffle_shop__orders') }} as ord
left join {{ ref('stg_jaffle_shop__products') }} as prd
    on 1=1
