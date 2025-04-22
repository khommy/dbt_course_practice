{% snapshot dim_flights__aircrafts %}

{{
   config(
        target_schema='snapshot',
        unique_key='aircraft_code',

        strategy='check',
        check_cols = ['model', 'range'],
        dbt_valid_to_current="'5000-01-01'::date",
        
        snapshot_meta_column_names={
            "dbt_valid_from": "dbt_effective_date_from",
            "dbt_valid_to": "dbt_effective_date_to"
        },

        hard_deletes = 'new_record'
   )
}}

select
    aircrafts.aircraft_code
    ,aircrafts.model
    ,aircrafts."range"
from {{ ref('stg_flights__aircrafts') }} as aircrafts

{% endsnapshot %}