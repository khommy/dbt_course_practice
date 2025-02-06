--ДЗ_4 
--Часть1 - Создание таблиц фактов
create  table "dwh_flights"."intermediate"."fct_bookings__dbt_tmp"  
as (
  select
      book_ref
      , book_date
      , total_amount
  from "dwh_flights"."intermediate"."stg_flights__bookings"
);
  
create  table "dwh_flights"."intermediate"."fct_flights_scheduled__dbt_tmp"
as ( 
  select
      flight_id
    , flight_no
    , scheduled_departure
    , scheduled_arrival
    , departure_airport
    , arrival_airport
    , status
    , aircraft_code
    , actual_departure
    , actual_arrival
  from "dwh_flights"."intermediate"."stg_flights__flights"
);

create  table "dwh_flights"."intermediate"."fct_ticket_flights__dbt_tmp"  
as (
  select
    ticket_no
    , flight_id
    , fare_conditions
    , amount
  from "dwh_flights"."intermediate"."stg_flights__ticket_flights"
);

create  table "dwh_flights"."intermediate"."fct_tickets__dbt_tmp"
as (
  select
    ticket_no, 
    book_ref, 
    passenger_id, 
    passenger_name, 
    contact_data
  from "dwh_flights"."intermediate"."stg_flights__tickets"
);

-- Часть2 
--Материализуйте способами, перечисленными ниже, модели fct_ticket_flights и stg_flights__ticket_flights:
-- - stg_flights__ticket_flights - ephemeral, fct_ticket_flights - table;
 

  create  table "dwh_flights"."intermediate"."fct_ticket_flights__dbt_tmp"
  
  
    as
  
  (
    

with __dbt__cte__stg_flights__ticket_flights as (



select 
    ticket_no
    , flight_id
    , fare_conditions
    , amount
from "dwh_flights"."demo_src"."ticket_flights"
) 

select
    ticket_no
    , flight_id
    , fare_conditions
    , amount
from __dbt__cte__stg_flights__ticket_flights
  );
[0m10:27:14.248770 [debug] [Thread-1 (]: SQL status: SELECT 593433 in 22.488 seconds
[0m10:27:14.252239 [debug] [Thread-1 (]: Using postgres connection "model.dbt_course_practice.stg_flights__bookings"


-- - stg_flights__ticket_flights - table, fct_ticket_flights - view;
 create view "dwh_flights"."intermediate"."fct_ticket_flights__dbt_tmp"
    
    
  as (
    

select
    ticket_no
    , flight_id
    , fare_conditions
    , amount
from "dwh_flights"."intermediate"."stg_flights__ticket_flights"
  );
[0m10:30:56.431257 [debug] [Thread-3 (]: SQL status: CREATE VIEW in 0.054 seconds
[0m10:30:56.433700 [debug] [Thread-3 (]: Using postgres connection "model.dbt_course_practice.fct_ticket_flights"

-- - stg_flights__ticket_flights - table, fct_ticket_flights - table.
create  table "dwh_flights"."intermediate"."fct_ticket_flights__dbt_tmp"
  
  
    as
  
  (
    

select
    ticket_no
    , flight_id
    , fare_conditions
    , amount
from "dwh_flights"."intermediate"."stg_flights__ticket_flights"
  );
  
[0m10:41:43.693686 [debug] [Thread-3 (]: SQL status: SELECT 2360335 in 17.217 seconds
[0m10:41:43.696687 [debug] [Thread-3 (]: Using postgres connection "model.dbt_course_practice.fct_ticket_flights"
[0m10:41:43.697085 [debug] [Thread-3 (]: On model.dbt_course_practice.fct_ticket_flights: /* {"app": "dbt", "dbt_version": "1.9.1", "profile_name": "dbt_course_practice", "target_name": "dev", "node_id": "model.dbt_course_practice.fct_ticket_flights"} */
alter table "dwh_flights"."intermediate"."fct_ticket_flights__dbt_tmp" rename to "fct_ticket_flights"