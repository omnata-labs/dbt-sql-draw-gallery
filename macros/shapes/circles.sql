{% macro circle_filled(center=[100,100], diameter=15) %}
POWER(x-{{ center[0] }},2) + POWER(y-{{ center[1] }},2) < POWER({{ diameter }},2)
{% endmacro %}
