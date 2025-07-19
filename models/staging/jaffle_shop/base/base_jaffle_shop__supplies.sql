with source as (

    select * from {{ source('jaffle_shop', 'raw_supplies') }}

),

deduplicated as (

    select
        *,
        row_number() over (partition by id order by id) as duplicate_check
    from source

)

select *
from deduplicated
where duplicate_check = 1
