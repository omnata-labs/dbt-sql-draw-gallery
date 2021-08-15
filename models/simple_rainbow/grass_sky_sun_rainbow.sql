{{ config(materialized='new_layer') }}

select x,y, 
    case
        when {{ is_in_circle_filled([180,180],20) }} then {{ colour_code("yellow") }} -- yellow sun
        else {{ colour_rainbow(center=[100,100], height=75,stripe_height=5) }}  -- rainbow
    end as colour
from {{ ref('grass_sky') }}
