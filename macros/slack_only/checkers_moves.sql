{# -- Draws circles for checkers games #}
{% macro draw_checkers_piece(x,y,colour='red',square_width=60,piece_radius=50) %}
update bitmap_pixels set colour = {{ colour_code(colour) }}
where {{ is_in_circle([(square_width*2*x - square_width),(square_width * 2 * y - square_width)],piece_radius) }}
{% endmacro %}

{% macro remove_checkers_piece(x,y,square_width=60,piece_radius=50) %}
{{draw_checkers_piece(x,y,'black',square_width,piece_radius)}}
{% endmacro %}