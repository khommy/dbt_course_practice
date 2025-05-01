{% set aircraft_query %}
select distinct
    aircraft_code
from 
    {{ ref('fct_flights_scheduled') }}
{% endset%}

{% set aircraft_query_result = run_query(aircraft_query) %}

{% if execute %}
    {% set important_aircrafts = aircraft_query_result.columns[0].values() %}
{% else %}
     {% set important_aircrafts = [] %}
{% endif %}

SELECT 

    {% for aircraft in important_aircrafts -%}
    SUM(CASE WHEN aircraft_code = '{{ aircraft }}' THEN 1 ELSE 0 END) as fligths_{{ aircraft|title}} 
        {%- if not loop.last %},{% endif %}
    -- {{ "Hello " ~ "ttt"}}
    {% endfor %}

FROM
    {{ ref('fct_flights_scheduled') }}