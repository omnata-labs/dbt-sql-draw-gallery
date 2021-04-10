{% macro tessellating_rectangle(width=10,height=20,odd_colour='#ffffff',even_colour='#000000') %}
when mod(x/{{ width }},2) != mod(y/{{ height }},2) then '{{ odd_colour }}'
when mod(x/{{ width }},2) = mod(y/{{ height }},2) then '{{ even_colour }}'
{% endmacro %}