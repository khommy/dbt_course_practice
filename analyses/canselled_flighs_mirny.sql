select 
    scheduled_departure::date as scheduled_departure, count(*)
from 
    {{ ref('fct_flights_scheduled') }}
where true
    and departure_airport = 'MJZ'
    and status ='Cancelled'
group by scheduled_departure::date
