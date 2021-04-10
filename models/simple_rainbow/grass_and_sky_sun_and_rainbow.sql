{{ config(materialized='new_layer') }}

select x,y, case
    when {{ circle_filled([180,180],20) }} then {{ colour_code("yellow") }} -- yellow sun
    {{ rainbow(center=[100,100], height=75,stripe_height=5) }}              -- rainbow
    else colour
    end as colour
from {{ ref('grass_and_sky') }}
