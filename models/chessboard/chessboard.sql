{{ config(materialized='new_layer') }}
select x,y, 
    {{ colour_chessboard(width=10) }} as colour
from {{ ref('blank_canvas_200_200') }}
