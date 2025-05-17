{{
  config(
    materialized = 'table'
    )
}}


select 
    aircraft_code
    , model
    , "range"
from {{ source('demo_src', 'aircrafts_data') }}


{{
    config(
        materialized = 'table',
        post_hook = '
            {% set backup_relation = api.Relation.create(
                    database = this.database,
                    schema = this.schema,
                    identifier = this.identifier ~ "_dbt_backup_new",
                    type = "table"
                ) 
            %}
            {% do adapter.drop_relation(backup_relation) %}
            {% do adapter.rename_relation(this, backup_relation) %}
        '
    )
}}
SELECT
    airport_code,
    airport_name,
    city,
    coordinates,
    timezone
FROM
    {{ source('demo_src', 'airports') }}