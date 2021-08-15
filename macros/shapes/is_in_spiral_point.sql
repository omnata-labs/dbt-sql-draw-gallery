{% macro is_in_spiral_point(center=[100,100],starting_point=0, step_size=0.1, total_length=100, outward_movement=2.71828, rotation=0, point_size=2.0) %}
ARRAY[x,y] in (
  with spiral_steps as (
    select * from generate_series({{ starting_point }}, {{ total_length }},{{ step_size }}) as step
  ), 
  polar_spiral as (
    select 
    step,
    power({{ outward_movement }},step) as r0
    from spiral_steps
    where power({{ outward_movement }},step) < 2147483647 -- don't exceed max integer   circle(point, double precision)
  ),
  spiral_cartesian as (
   select 
  	(r0 * cos(step + {{ rotation }}))::int as x2,
    (r0 * sin(step + {{ rotation }}))::int as y2
   from polar_spiral 
  )
  select ARRAY[x2+{{center[0]}},y2+{{center[1]}}] from spiral_cartesian 
)
{% endmacro %}
