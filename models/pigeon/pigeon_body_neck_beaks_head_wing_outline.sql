{{ config(materialized='new_layer') }}
select x,y,
  case 
    when {{ is_near_edge(distance=4,density_at_distance=[1,1,0.9,0.8]) }} then '#000000'
    else colour
  end as colour
from {{ ref('pigeon_body_neck_beaks_head_wing') }}
