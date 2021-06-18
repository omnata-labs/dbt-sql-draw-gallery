{{ config(materialized='new_layer') }}

{%- set bl_x = 66 -%}
{%- set bl_y = 90 -%}

select x,y, case

    when point (x,y) <-> path '[({{ bl_x+4 }},{{bl_y+19}}),({{ bl_x+7 }},{{bl_y+19}})]' < 2 then '#64573D' -- hair
    when circle '(({{ bl_x+4 }},{{bl_y+17}}),3)' @> point (x,y) then '#F8E9CC' -- head
    when point (x,y) <-> path '[({{ bl_x+0 }},{{bl_y+0}}),({{ bl_x+4 }},{{bl_y+9}}),({{ bl_x+8 }},{{bl_y+3}})]' < 1 then '#131F29' -- legs
    when point (x,y) <-> path '[({{ bl_x+4 }},{{bl_y+9}}),({{ bl_x+4 }},{{bl_y+14}})]' < 2 then '#131F29' -- torso
    when point (x,y) <-> path '[({{ bl_x-1 }},{{bl_y+12}}),({{ bl_x+4 }},{{bl_y+14}}),({{ bl_x+9 }},{{bl_y+16}})]' < 1 then '#131F29' -- arms
    when point (x,y) <-> path '[({{ bl_x+0 }},{{bl_y+0}}),({{ bl_x-2 }},{{bl_y+0}})]' < 1 then '#F8E9CC' -- foot
    when point (x,y) <-> path '[({{ bl_x+8 }},{{bl_y+3}}),({{ bl_x+6 }},{{bl_y+3}})]' < 1 then '#F8E9CC' -- foot
    when point (x,y) <-> path '[({{ bl_x-1 }},{{bl_y+12}}),({{ bl_x-3 }},{{bl_y+12}})]' < 1 then '#F8E9CC' -- hand
    when point (x,y) <-> path '[({{ bl_x+9 }},{{bl_y+16}}),({{ bl_x+11 }},{{bl_y+16}})]' < 1 then '#F8E9CC' -- hand

    when {{ oval_filled(center=[70,90], diameter=20, ratio_x=1,ratio_y=0.25, rotation=2.6) }} then '#D2691E' -- surfboard
else colour end as colour
from {{ ref('sand_sky_wave_foam') }}
