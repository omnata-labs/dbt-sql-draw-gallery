{{ config(materialized='new_layer') }}
select x,y, 
case
    -- 1% chance of a pixel becoming a distant star
    when x-x+random() < 0.01 then '#ffffff'
    else '#000000'
end as colour
from {{ ref('blank_canvas_1000_1000') }}

