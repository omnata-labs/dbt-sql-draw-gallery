{% macro colour_chessboard(width=10) %}
{# --This is just a special type of tessellating rectangle, with equal width sides and black and white colours #}
{{ colour_tessellating_rectangle(width=width,height=width,odd_colour='#ffffff',even_colour='#000000')}}
{% endmacro %}