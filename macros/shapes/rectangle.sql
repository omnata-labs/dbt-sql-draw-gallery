{% macro rectangle(bottom_left=[100,100], top_right=[200,200]) %}

x between {{ bottom_left[0] }} and {{ top_right[0] }} and y between {{ bottom_left[1] }} and {{ top_right[1] }}

{% endmacro %}
