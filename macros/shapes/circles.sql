{% macro circle_filled(center=[100,100], diameter=15, fill_density=1) %}
POWER(x-{{ center[0] }},2) + POWER(y-{{ center[1] }},2) < POWER({{ diameter }},2) and  x-x+random() < {{ fill_density }}
{% endmacro %}
