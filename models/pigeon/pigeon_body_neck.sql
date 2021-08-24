{{ config(materialized='new_layer') }}
with parent as(
    select * from {{ ref('pigeon_body') }}
),
neck_curve_1 as (
    select x,y 
    from parent 
    where {{ is_on_bezier_curve(control_points=[[390,400],[390,500],[425,600]],interval=0.001) }}
),
neck_curve_2 as (
    select x,y 
    from parent
    where {{ is_on_bezier_curve(control_points=[[460,400],[460,500],[500,700]],interval=0.001) }}
)
select parent.x,parent.y, 
    case 
        when parent.y between 500 and 550 then '#ffffff' -- white band on neck
        else '#B4D3D5' 
    end as colour
from parent,neck_curve_1,neck_curve_2
where parent.y between 400 and 700 and (parent.y = neck_curve_1.y and parent.y = neck_curve_2.y and parent.x between neck_curve_1.x and neck_curve_2.x)
