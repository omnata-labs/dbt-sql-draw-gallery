{% macro is_on_bezier_curve(control_points,interval=0.01) %}
{% set bound = namespace(x_min=0,x_max=0,y_min=0,y_max=0) %}
{# -- Check that 3 or 4 control points were provided #}
{% set control_point_count = control_points | length %}
{% if control_point_count < 3 or control_point_count > 4 %}
    {% set error_message %}control_points must contain a list of either 3 or 4 coordinate pairs (e.g. [[0,0],[50,50],[100,0]] or [[0,20],[40,70],[50,10],[80,80]]){% endset %}
    --{{ None['[ERROR] ' ~ error_message ][0] }}
{%- endif -%}
{# -- Find the overall boundaries #}
{% for control_point in control_points %}
  {% if control_point[0] < bound.x_min %}
    {% set bound.x_min = control_point[0] %}
  {% endif %}
  {% if control_point[0] > bound.x_max %}
    {% set bound.x_max = control_point[0] %}
  {% endif %}
  {% if control_point[1] < bound.y_min %}
    {% set bound.y_min = control_point[1] %}
  {% endif %}
  {% if control_point[1] > bound.y_max %}
    {% set bound.y_max = control_point[1] %}
  {% endif %}
{% endfor %}

exists (
with 
-- generate all the t values
t_series as (select * from generate_series(0,1,{{ interval }}) as t),
-- collect all possible x values
x_values as (select * from generate_series({{bound.x_min}},{{bound.x_max}},1) as x),
-- collect all possible y values
y_values as (select * from generate_series({{bound.y_min}},{{bound.y_max}},1) as y),
-- for each t value, find the values of x that overlap
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
-- for each t value, find the values of y that overlap
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
-- join on t to get all combinations of x and y
points_in_common as(
  select x_match,y_match
  from t_for_x
  join t_for_y on t_for_x.t = t_for_y.t
)
-- match back to the outer query
select 1
from points_in_common 
where x = points_in_common.x_match and y = points_in_common.y_match
)
{% endmacro %}