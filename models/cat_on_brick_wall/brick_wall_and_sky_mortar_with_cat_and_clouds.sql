{{ config(materialized='new_layer') }}

select x,y, 
    case
        when {{ is_in_circle_filled([150,160],15) }} then '#ffffff'
        when {{ is_in_circle_filled([130,165],15) }} then '#ffffff'
        when {{ is_in_circle_filled([160,155],15) }} then '#ffffff'
        when {{ is_in_circle_filled([160,175],15) }} then '#ffffff'
    else colour
    end as colour
from {{ ref('brick_wall_and_sky_mortar_with_cat') }}
