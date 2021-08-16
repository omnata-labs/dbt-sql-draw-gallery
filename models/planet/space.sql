{{ config(materialized='new_layer') }}

select x,y, '#000000' as colour
from {{ ref('blank_canvas_1000_1000') }}

