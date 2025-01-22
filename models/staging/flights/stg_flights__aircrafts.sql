select *
from {{ source('demo_src', 'aircrafts') }}
