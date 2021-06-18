{{ config(materialized='new_layer') }}

select x,y, 
    case
        {% for bird_coord in [[120,160],[160,180]] -%}
             -- bird wing 1
            when point (x,y) <-> point ({{bird_coord[0]}},{{bird_coord[1]}}) between 6 and 8 and y > {{bird_coord[1]+2}} then '#ffffff'
            -- bird wing 2
            when point (x,y) <-> point ({{bird_coord[0]+12}},{{bird_coord[1]}}) between 6 and 8 and y > {{bird_coord[1]+2}} then '#ffffff' 
            
        {%- endfor %}

        when {{ circle_filled([320,170],20) }} then {{ colour_code("yellow") }} -- yellow sun
        when y>=80 then '#58F8FD' -- blue sky
        when y>=40 then '#00B5DC' -- ocean
        when y>=30 and random() < (y-30)/cast(20 as float) then '#00B5DC' -- between 50 and 40, random choice between sand and sky that starts sky-biased and ends sand-biased 
    else '#F8E9CC'  -- sand
    end as colour
from {{ ref('blank_canvas_400_200') }}

