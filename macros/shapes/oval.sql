{% macro oval_filled(center=[100,100], diameter=15, ratio_x=0.5,ratio_y=1, rotation=0) %}
POWER(cast( (x-{{ center[0] }})*cos({{ rotation }})-(y-{{ center[1] }})*sin({{ rotation }}) as int)*{{ratio_y}},2) + POWER(cast((x-{{ center[0] }})*sin({{ rotation }})+(y-{{ center[1] }})*cos({{ rotation }}) as int)*{{ ratio_x }},2) < {{ diameter }}

{% endmacro %}
