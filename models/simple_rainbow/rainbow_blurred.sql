{{ config(materialized='new_layer') }}

select x,y, case {{ blur() }} else colour end as colour
from {{ ref('grass_and_sky_sun_and_rainbow') }}