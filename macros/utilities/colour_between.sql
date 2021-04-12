{% macro colour_between(first_value_column='colour1',second_value_column='colour2') %}
{#-- split out red, green, blue with ints in 0-255 range
  -- we want to pick the integer value between the two. E.g. (0,0,0) and (100,200,255) becomes (50,100,128) #}
'#' ||
lpad(to_hex(({{hex_to_rgb(second_value_column,1)}} + {{hex_to_rgb(first_value_column,1)}}) / 2),2,'0') ||
lpad(to_hex(({{hex_to_rgb(second_value_column,2)}} + {{hex_to_rgb(first_value_column,2)}}) / 2),2,'0') ||
lpad(to_hex(({{hex_to_rgb(second_value_column,3)}} + {{hex_to_rgb(first_value_column,3)}}) / 2),2,'0')
{% endmacro %}
