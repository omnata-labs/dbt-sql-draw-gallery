{% macro hex_to_rgb(hex_code_column='colour',which_part=1) %}
('x'||lpad(substring(REPLACE({{hex_code_column}}, '#', '') from {{ (which_part*2)-1 }} for 2),16,'0'))::bit(64)::bigint
{% endmacro %}
