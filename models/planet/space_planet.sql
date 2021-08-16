{{ config(materialized='new_layer') }}

select x,y,
case
  when point (x,y) <@ circle '((500,500),150)' then '#CDAF6F'
  else colour
end as colour
from {{ ref('space') }}

