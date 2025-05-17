{#
Код согласно комментариям из задания, если я правильно поняла
Не понимаю зачем приводить к строке потом обрезать и все это к формату date, тем более в блоке where
Может не правильно поняла задание

WITH date_str AS (
    SELECT '{{ run_started_at | string | truncate(10, True, "") }}' AS today_str
)
SELECT
    COUNT(*) AS total_future_flights
FROM {{ ref('fct_flights_scheduled') }}, date_str
WHERE
    scheduled_departure::date >= date_str.today_str::date;
#}

{# Сделала по своему 1 вариант сгруппировав на каждый день #}
SELECT 
   TO_CHAR(scheduled_departure::timestamp, 'DD-MM-YYYY') AS formatted_date,
  COUNT(*)
FROM {{ ref('fct_flights_scheduled') }}
WHERE 
  scheduled_departure >= '{{ run_started_at }}'::timestamp - interval '8 year' + interval '4 month'
GROUP BY TO_CHAR(scheduled_departure::timestamp, 'DD-MM-YYYY')
ORDER by  TO_CHAR(scheduled_departure::timestamp, 'DD-MM-YYYY')

