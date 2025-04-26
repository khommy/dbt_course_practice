select 
   aircraft_code
   , count(seat_no) as cnt_seats
from 
    {{ ref('stg_flights__seats') }}

group by aircraft_code
