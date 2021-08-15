{{ config(materialized='new_layer') }}

select x,y, 
    case
        -- Make some mortar lines.
        when mod(y,10) = 0 -- horizontal lines every 10
            or (mod(x/15,2) = mod(y/10,2) and mod(x,15)=0) -- vertical lines offset every second one
        then '#BDBBBC'
    else colour
    end as colour
from {{ ref('brick_wall_sky') }}
where y<100
