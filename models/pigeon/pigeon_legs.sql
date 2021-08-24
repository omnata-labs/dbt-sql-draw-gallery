{{ config(materialized='new_layer') }}
select x,y,

case 
    -- left leg
    when point (x,y) <-> lseg '((500,50),(500,200))' <= 1 then '#000000'
    when point (x,y) <-> lseg '((450,50),(500,100))' <= 1 then '#000000'
    when point (x,y) <-> lseg '((550,50),(500,100))' <= 1 then '#000000'
    -- right leg
    when point (x,y) <-> lseg '((625,50),(625,250))' <= 1 then '#000000'
    when point (x,y) <-> lseg '((575,50),(625,100))' <= 1 then '#000000'
    when point (x,y) <-> lseg '((675,50),(625,100))' <= 1 then '#000000'
    else '#E9C8A7' 
    end as colour
from {{ ref('blank_canvas_1000_1000') }}