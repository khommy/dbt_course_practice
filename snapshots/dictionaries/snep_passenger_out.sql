{% snapshot snep_passenger_out %}

{{
   config(       
       target_schema='snapshot',
       unique_key='passenger_id',

       strategy='timestamp',
       updated_at='updated_at',
       dbt_valid_to_current="'5000-01-01'::date"
   )
}}

select
    passenger_id
    ,passenger_name
    ,updated_at
from {{ ref('passenger_out') }}
{% endsnapshot %}