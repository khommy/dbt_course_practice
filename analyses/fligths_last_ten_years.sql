--делаю согласно описанию из задачи, хотя можно и проще
--Почитайте сколько всего полетов (количество строк в модели fct_fligths) было запланировано за предыдущие 10 лет, 
--начиная с текущей даты (scheduled_departure between [текущая дата] and [дата на 10 лет раньше текущей]).

--Тут поправочка scheduled_departure between [дата на 10 лет раньше текущей] and [текущая дата]

{% set curr_dt =  run_started_at | string | truncate(10, True, "") %}
{% set current_year = (curr_dt | truncate(4, True, "")) | int %}
{% set prev_year = (current_year - 10) | int %}
{% set prev_date = curr_dt | replace(current_year|string,prev_year|string)%}
{% set month_str = {
  '01': 'Январь',
  '02': 'Февраль',
  '03': 'Март',
  '04': 'Апрель',
  '05': 'Май',
  '06': 'Июнь',
  '07': 'Июль',
  '08': 'Август',
  '09': 'Сентябрь',
  '10': 'Октябрь',
  '11': 'Ноябрь',
  '12': 'Декабрь'
} %}

SELECT 
  TO_CHAR(scheduled_departure::timestamp, 'MM') AS month_number,
  TO_CHAR(scheduled_departure::timestamp, 'YYYY') AS year_number,
  CASE TO_CHAR(scheduled_departure::timestamp, 'MM')
    {% for key, value in month_str.items() -%}
        WHEN '{{ key }}' THEN '{{ value }}'
    {% endfor -%}
  END AS month_name,
  COUNT(*) AS total_flights
FROM {{ ref('fct_flights_scheduled') }}
WHERE 
  scheduled_departure BETWEEN '{{ prev_date }}'::timestamp AND '{{ curr_dt }}'::timestamp
GROUP BY month_number, year_number, month_name
ORDER BY year_number, month_number;

{% set fct_fligths = api.Relation.create(
        database = 'dwh_flights',
        schema = 'intermediate',
        identifier = 'fct_fligths',
        type = 'table'
    ) 
%}

{% set stg_flights__flights = api.Relation.create(
        database = 'dwh_flights',
        schema = 'intermediate',
        identifier = 'stg_flights__flights',
        type = 'table'
    ) 
%}

{% do adapter.expand_target_column_types(stg_flights__flights, fct_fligths) %}

{% for column in adapter.get_columns_in_relation(stg_flights__flights) %}
    {{ 'Column: ' ~ column }}
{%- endfor %} 

{% for column in adapter.get_columns_in_relation(fct_fligths) %}
    {{ 'Column: ' ~ column }}
{%- endfor %} 

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