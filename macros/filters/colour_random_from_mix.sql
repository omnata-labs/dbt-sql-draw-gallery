{% macro colour_random_from_mix(colour_mix=[['red',0.2],['green',0.2],['blue',0.6]]) %}
{% set current_point = namespace(value=0) %}
(select coalesce(max(column3),'{{ colour_mix[0][0] }}') from (values
  {% for colour in colour_mix %}
  ({{ current_point.value }}, {{ current_point.value + colour[1]}}, '{{ colour[0]}}')
  {% if not loop.last %}, {% endif %}
  {% set current_point.value = current_point.value + colour[1] %}
  {% endfor %}
  ) v
where x-x + random() between column1 and column2)
{% endmacro %}


