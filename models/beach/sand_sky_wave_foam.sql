{{ config(materialized='new_layer') }}

select x,y, 
    case
       when point (x,y) <-> lseg '((240,95),(400,95))' < 20 + round(random()*2) and x-x+random() < 0.4 then '#ffffff'
       when point (x,y) <-> polygon '((140,110),(220,110),(220,80),(140,110))' < 5 + round(random()*2) and x-x+random() < 0.4 then '#ffffff'
    else colour
    end as colour
from {{ ref('sand_sky_wave') }}
