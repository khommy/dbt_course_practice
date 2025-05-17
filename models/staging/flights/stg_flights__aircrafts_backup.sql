{{ config(
    materialized='table',
    pre_hook="""
    {% set existing_relation = api.Relation.create(
        database=this.database,
        schema=this.schema,
        identifier=this.identifier
    ) %}

    {% if adapter.get_relation(existing_relation.database, existing_relation.schema, existing_relation.identifier) %}
        {% set backup_relation = api.Relation.create(
            database = this.database,
            schema = this.schema,
            identifier = this.identifier ~ '_' ~ run_started_at.strftime('%Y_%m_%d_%H%M%S'),
            type = 'table'
        ) %}
        {% do adapter.drop_relation(backup_relation) %}
        {% do adapter.rename_relation(existing_relation, backup_relation) %}
    {% endif %}
    """
) }}

select
    aircraft_code,
    model,
    "range"
from {{ source('demo_src', 'aircrafts') }}