{% macro blur() %}
when LEAD(colour) OVER ( PARTITION BY x ORDER BY x,y) is not null then {{ colour_between(first_value_column='colour',second_value_column='LEAD(colour) OVER ( PARTITION BY x ORDER BY x,y)') }}
{% endmacro %}