{{ config(materialized='new_layer') }}
with parent as(
    select * from {{ ref('pigeon_body_neck_beak') }}
),
upper_beak_curve as (
    select x,y 
    from parent
    where {{ is_on_bezier_curve(control_points=[[300,650],[420,625],[410,720],[300,650]],interval=0.001) }}
),
upper_beak_curve_vertical_range as (
    select x,min(y) as y_min,max(y) as y_max
    from upper_beak_curve 
    group by x
)
select parent.x,parent.y,'#E8D485' as colour
from parent,upper_beak_curve_vertical_range vr
where parent.x = vr.x and (parent.y between vr.y_min and vr.y_max)

