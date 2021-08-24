{% macro is_in_oval(center=[100,100], diameter=15, ratio_x=0.5,ratio_y=1, rotation=0) %}
{% set min_ratio = [ratio_x, ratio_y] | min %}
{% set min_ratio_inverted = 1 / min_ratio %}
-- Use the general equation for an ellipse, which uses sin and cos to rotate.
-- Multiply x or y axis by their ratios to squash it into an oval
power(cast((x-{{ center[0] }})*cos({{ rotation }})-(y-{{ center[1] }})*sin({{ rotation }}) as int)*{{ ratio_y }},2) + 
power(cast((x-{{ center[0] }})*sin({{ rotation }})+(y-{{ center[1] }})*cos({{ rotation }}) as int)*{{ ratio_x }},2) 
< power({{ diameter / min_ratio_inverted / 2 }},2)

{% endmacro %}
