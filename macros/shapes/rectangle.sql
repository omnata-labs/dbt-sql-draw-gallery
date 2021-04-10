{% macro rectangle(top_left=[100,100], bottom_right=[200,200]) %}

x between {{ top_left[0] }} and {{ bottom_right[0] }} and y between {{ top_left[1] }} and {{ bottom_right[1] }}

{% endmacro %}
