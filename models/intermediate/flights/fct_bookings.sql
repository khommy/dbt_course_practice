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
from {{ ref('stg_flights__bookings') }}