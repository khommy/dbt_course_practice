{{
    config(
        materialized = 'table',       
        tags = ['bookings'],
        meta = {
            'owner':'sql_file_owner@gmail.com'
        }
    )

}}

select
    book_ref::text
    , book_date
    , total_amount
from {{ ref('stg_flights__bookings') }}