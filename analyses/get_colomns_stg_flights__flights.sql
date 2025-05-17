{% set relation = adapter.Relation.create(
    database='dwh_flights',
    schema='intermediate',
    identifier='stg_flights__flights_v'
) %}

{%- for column in adapter.get_columns_in_relation(relation) -%}
  {{ 'Column: ' ~ column.name }}
{% endfor %}