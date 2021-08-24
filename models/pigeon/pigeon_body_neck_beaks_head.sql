{{ config(materialized='new_layer') }}
select x,y,case    
    when {{ is_in_circle([495,680],20) }} then '#000000'
    when {{ is_in_circle([470,680],45) }} then '#ffffff'
    when {{ is_in_circle([470,680],100) }} then '#B4D3D5'
    else colour
end as colour
from {{ ref('pigeon_body_neck_beaks') }}
