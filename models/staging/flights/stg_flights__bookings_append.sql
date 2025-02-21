{{
  config(
    materialized = 'incremental',
    incremental_strategy = 'append',
    tags = ['bookings']
    )
}}

select 
    book_ref
    , book_date
    , total_amount
from {{ source('demo_src', 'bookings') }}
{% if is_incremental() %}
WHERE
  ('0x' ||book_ref)::bigint > (select max( ('0x' ||book_ref)::bigint) from {{ this }})
{% endif %}