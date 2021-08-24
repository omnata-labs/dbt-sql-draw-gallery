{{ config(materialized='new_layer') }}
with parent as(
    select * from {{ ref('pigeon_legs') }}
),
curve as (
    select x,y 
    from parent
    where {{ is_on_bezier_curve(control_points=[[400,400],[300,0],[800,200],[850,400]],interval=0.0001) }}
)
select parent.x,parent.y,'#B4D3D5' as colour
from parent,curve
where parent.y < 400 and (parent.x=curve.x and parent.y > curve.y)