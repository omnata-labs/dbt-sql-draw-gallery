{{ config(materialized='new_layer') }}
select x,y, '#000000' as colour
from {{ ref('pigeon_body_neck_beaks_head') }}
where {{ is_on_bezier_curve(control_points=[[440,360],[580,220],[730,300],[640,385]],interval=0.0001) }}

