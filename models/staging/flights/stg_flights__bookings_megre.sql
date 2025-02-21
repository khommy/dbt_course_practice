{{
  config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key = ['book_ref'],
    tags = ['bookings'],
    merge_update_columns = ['total_amount']
    )
}}

select 
    book_ref
    , book_date
    , total_amount
from 
  {{ source('demo_src', 'bookings') }}
{% if is_incremental() %}
where 
  --book_date >= current_day - interval '7 day'
  book_date >= (select max(book_date) from  {{ source('demo_src', 'bookings') }} ) - interval '97 day'
{% endif %}