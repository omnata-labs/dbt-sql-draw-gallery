{{ config(materialized='new_layer') }}

select x,y, 
    case

    
    {% for n in range(14) %}
        
        {%- set wave_center_y = 120 -%}

        {%- set n_float = n | float -%}
        {%- set bottom_half_center_x = 10*n -%}
        {%- set bottom_half_center_y = wave_center_y -%}

        {%- set top_half_center_x = 5 + (15*n) -%}
        {%- set top_half_center_y = (wave_center_y - (2*n if n < 9 else 2*n+(n-9))) | int -%}
        {%- set top_half_total_length = 4.8 - (n_float/20) -%}
        {%- set top_half_outward_movement = 1.9 + (n_float/10) -%}

        when {{ is_in_spiral_point(center=[bottom_half_center_x,   bottom_half_center_y],   step_size=0.1, outward_movement=1.9,                       starting_point=5, total_length=6,                    rotation=-1) }} then '#00395E' -- bottom half of wave
        when {{ is_in_spiral_point(center=[bottom_half_center_x,   bottom_half_center_y+1], step_size=0.1, outward_movement=1.9,                       starting_point=5, total_length=6,                    rotation=-1) }} then '#00395E' -- bottom half of wave
        when {{ is_in_spiral_point(center=[bottom_half_center_x+1, bottom_half_center_y],   step_size=0.1, outward_movement=1.9,                       starting_point=5, total_length=6,                    rotation=-1) }} then '#00395E' -- bottom half of wave
        when {{ is_in_spiral_point(center=[bottom_half_center_x+1, bottom_half_center_y+1], step_size=0.1, outward_movement=1.9,                       starting_point=5, total_length=6,                    rotation=-1) }} then '#00395E' -- bottom half of wave

        when {{ is_in_spiral_point(center=[top_half_center_x,      top_half_center_y],      step_size=0.1, outward_movement=top_half_outward_movement, starting_point=0, total_length=top_half_total_length,rotation=-1) }} then '#00395E' -- top half of wave
        when {{ is_in_spiral_point(center=[top_half_center_x,      top_half_center_y+1],    step_size=0.1, outward_movement=top_half_outward_movement, starting_point=0, total_length=top_half_total_length,rotation=-1) }} then '#00395E' -- top half of wave
        when {{ is_in_spiral_point(center=[top_half_center_x+1,    top_half_center_y],      step_size=0.1, outward_movement=top_half_outward_movement, starting_point=0, total_length=top_half_total_length,rotation=-1) }} then '#00395E' -- top half of wave
        when {{ is_in_spiral_point(center=[top_half_center_x+1,    top_half_center_y+1],    step_size=0.1, outward_movement=top_half_outward_movement, starting_point=0, total_length=top_half_total_length,rotation=-1) }} then '#00395E' -- top half of wave

    {% endfor %}

    when point (x,y) <-> lseg '((0,100),(400,100))' < 25 and x-x+random() < 0.9 then '#00B5DC'

    else colour
    end as colour
from {{ ref('sand_sky') }}

