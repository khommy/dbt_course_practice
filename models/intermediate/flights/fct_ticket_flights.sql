{{
    config(
        materialized = 'table'
        )
}}
-- Из модели fct_ticket_flights убраны все записи по passenger_id, которые хранятся в таблице passenger_out
select 
    ftf.ticket_no 
    , ftf.flight_id
    , ftf.fare_conditions
    , ftf.amount
from {{ ref('stg_flights__ticket_flights') }} as ftf
inner join {{ ref('fct_tickets') }} as ft on ftf.ticket_no = ft.ticket_no
where not exists (
    select 1
    FROM intermediate.passenger_out po
    WHERE ft.passenger_id = po.passenger_id
)