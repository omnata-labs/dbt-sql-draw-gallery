{{ config(materialized='new_layer') }}

select x,y, 
    case
        when y>=100 then '#87ceeb' -- blue sky
        else '#228b22' -- green grass
    end as colour
from {{ ref('blank_canvas_200_200') }}

