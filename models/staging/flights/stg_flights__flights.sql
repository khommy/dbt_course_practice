
{{
  config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    on_schema_change = 'append_new_columns',
    tags = ['flights']
    )
}}

WITH max_download AS (
    SELECT MAX(download_dt) as max_download_dt
    FROM {{ this }}  -- Используем текущую модель
)

SELECT 
   flight_id,
   flight_no,
   scheduled_departure,
   scheduled_arrival,
   departure_airport,
   arrival_airport,
   status,
   aircraft_code,
   actual_departure,
   actual_arrival,
   flights_uptdt,
   now() download_dt
   
FROM {{ source('demo_src', 'flights') }}
{% if is_incremental() %}
 where true
 -- Дата обновления строки больше или равна максимальной дете последней загрузки данных
 AND flights_uptdt >= (SELECT max_download_dt FROM max_download) - INTERVAL '7 day'
{% endif %}