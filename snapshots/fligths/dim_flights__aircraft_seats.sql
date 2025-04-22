{% snapshot dim_flights__aircraft_seats %}

{{
   config(
        target_schema='snapshot',
        unique_key=['aircraft_code', 'seat_no'],

        strategy='check',
        check_cols = ['aircraft_code', 'seat_no', 'fare_conditions'],
        dbt_valid_to_current="'5000-01-01'::date",
        hard_deletes='ignore'
   )
}}

select
     aircraft_code
   , seat_no
   , fare_conditions
from {{ ref('stg_flights__seats') }} as seets

{% endsnapshot %}