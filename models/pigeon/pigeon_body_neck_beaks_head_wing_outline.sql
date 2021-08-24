{{ config(materialized='new_layer') }}
select x,y,
  case 
    -- when colour changes 1-3 pixels up or right, choose black
    when (LEAD(colour) OVER ( ORDER BY x,y) !=colour or 
         LEAD(colour,2) OVER ( ORDER BY x,y) !=colour or
         LEAD(colour) OVER ( ORDER BY y,x) !=colour or
         LEAD(colour,2) OVER ( ORDER BY y,x) !=colour or
         (LEAD(colour,3) OVER ( ORDER BY x,y) !=colour or
         LEAD(colour,3) OVER ( ORDER BY y,x) !=colour)
    -- when colour changes 4 pixels up or right, choose black 90% of the time to give a blurred edge
         or (x-x+random()<0.9 and
         LEAD(colour,4) OVER ( ORDER BY x,y) !=colour or
         LEAD(colour,4) OVER ( ORDER BY y,x) !=colour))
         then '#000000'
    else colour
  end as colour
from {{ ref('pigeon_body_neck_beaks_head_wing') }}
