with source_2023 as (
    select * from {{ source('jaffle_shop', 'raw_orders_2023') }}
),

source_2024 as (
    select * from {{ source('jaffle_shop', 'raw_orders_2024') }}
),

unioned as (
    select * from source_2023
    union all
    select * from source_2024
),

deduplicated as (
    select
        *,
        row_number() over (partition by id order by ordered_at desc) as duplicate_check
    from unioned
)

select *
from deduplicated
where duplicate_check = 1
