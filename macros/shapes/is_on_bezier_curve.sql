{% macro is_on_bezier_curve(control_points,interval=0.01) %}
{% set control_point_count = control_points | length %}
{% if control_point_count < 3 or control_point_count > 4 %}
    {% set error_message %}control_points must contain a list of either 3 or 4 coordinate pairs (e.g. [[0,0],[50,50],[100,0]] or [[0,20],[40,70],[50,10],[80,80]]){% endset %}
    --{{ None['[ERROR] ' ~ error_message ][0] }}
{%- endif -%}
exists (
with 
t_series as (select * from generate_series(0,1,{{ interval }}) as t),
x_values as (select distinct x from bitmap_pixels),
y_values as (select distinct y from bitmap_pixels),
t_for_x as (
  select t,x as x_match
  from t_series,x_values
  where
  {% if control_point_count == 3 %}  
   ( ((1-t)^2*{{ control_points[0][0] }})     + 
     (2*(1-t)*t*{{ control_points[1][0] }})   + 
     (t^2*{{ control_points[2][0] }})          )::int = x
  {% else %}
   ( ((1-t)^3*{{ control_points[0][0] }})     + 
     (3*(1-t)^2*t*{{ control_points[1][0] }}) + 
     (3*(1-t)*t^2*{{ control_points[2][0] }}) + 
     (t^3*{{ control_points[3][0] }})          )::int = x
  {% endif %}
),
t_for_y as (
  select t,y as y_match
  from t_series,y_values
  where 
  {% if control_point_count == 3 %}  
   ( ((1-t)^2*{{ control_points[0][1] }})     + 
     (2*(1-t)*t*{{ control_points[1][1] }})   + 
     (t^2*{{ control_points[2][1] }})          )::int = y
  {% else %}
   ( ((1-t)^3*{{ control_points[0][1] }})     + 
     (3*(1-t)^2*t*{{ control_points[1][1] }}) + 
     (3*(1-t)*t^2*{{ control_points[2][1] }}) + 
     (t^3*{{ control_points[3][1] }})          )::int = y
  {% endif %}
),
points_in_common as(
  select x_match,y_match
  from t_for_x
  join t_for_y on t_for_x.t = t_for_y.t
)
select 1
from points_in_common 
where x = points_in_common.x_match and y = points_in_common.y_match
)
{% endmacro %}