{% macro oval_filled(center=[100,100], diameter=15, ratio_x=0.5,ratio_y=1) %}
POWER((x-{{ center[0] }})*{{ratio_y}},2) + POWER((y-{{ center[1] }})*{{ ratio_x }},2) < {{ diameter }}
{% endmacro %}
