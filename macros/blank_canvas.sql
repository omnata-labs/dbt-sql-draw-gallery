{% macro blank_canvas(width=200, height=200) %}
with x_gen as (select * from generate_series(0, {{ width }}) as x),
     y_gen as (select * from generate_series(0, {{ height }}) as y)
select x_gen.x,y_gen.y,{{ colour_code("white") }} as colour from x_gen,y_gen
{% endmacro %}
