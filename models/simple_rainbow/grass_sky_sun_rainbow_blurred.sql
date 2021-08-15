{{ config(materialized='new_layer') }}

select x,y, 
    {{ colour_blurred() }} as colour
from {{ ref('grass_sky_sun_rainbow') }}