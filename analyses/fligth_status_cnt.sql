{% set fligts_status %}
select distinct status
from {{ ref('stg_flights__flights') }}
{% endset%}

{% set fligts_status_result = run_query(fligts_status) %}

{% if execute %}
    {% set fligts_status_seg = fligts_status_result.columns[0].values() %}
{% else %}
     {% set fligts_status_seg = [] %}
{% endif %}

select
{% for stat in fligts_status_seg %}
    sum(case when status = '{{stat}}' then 1 else 0 end) as 
    {%- if stat == 'On Time' %} status_On_Time {% else %} status_{{stat}}{%endif%}
    {%- if not loop.last%}, {% endif %}
{% endfor %}
from {{ ref('stg_flights__flights') }}


