{% macro is_near_edge(distance=1,density_at_distance=[1]) %}
    {% set density_distances = density_at_distance | length %}
    {% for i in range(1,distance+1) %}
    (
        {% if i <= density_distances and density_at_distance[i-1] < 1 %}
            x-x+random()< {{ density_at_distance[i-1] }} and
        {% endif %}
        (
            LEAD(colour,{{i}}) OVER ( ORDER BY y,x) !=colour or
            LEAD(colour,{{i}}) OVER ( ORDER BY x,y) !=colour
        )
    )
    {% if not loop.last %}or{% endif %}
    {% endfor %}
{% endmacro %}