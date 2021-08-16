{{ config(materialized='new_layer') }}

select x,y,
case
  -- y=mx+b formula, if above then render the circle first
  when y > -0.25*x+600 and point (x,y) <@ circle '((500,500),150)' then '#CDAF6F'
  when {{ is_in_oval(center=[500,500], diameter=400, ratio_x=1,ratio_y=0.3,rotation=0.25) }} then colour
  when {{ is_in_oval(center=[500,500], diameter=430, ratio_x=1,ratio_y=0.3,rotation=0.25) }} then '#555038'
  when {{ is_in_oval(center=[500,500], diameter=440, ratio_x=1,ratio_y=0.3,rotation=0.25) }} then colour
  when {{ is_in_oval(center=[500,500], diameter=480, ratio_x=1,ratio_y=0.3,rotation=0.25) }} then '#F5C97E'
  when {{ is_in_oval(center=[500,500], diameter=500, ratio_x=1,ratio_y=0.3,rotation=0.25) }} then colour
  when {{ is_in_oval(center=[500,500], diameter=550, ratio_x=1,ratio_y=0.3,rotation=0.25) }} then '#C9A167'
  when {{ is_in_oval(center=[500,500], diameter=590, ratio_x=1,ratio_y=0.3,rotation=0.25) }} then colour
  when {{ is_in_oval(center=[500,500], diameter=660, ratio_x=1,ratio_y=0.3,rotation=0.25) }} then '#806144'
  else colour
end as colour
from {{ ref('space_planet') }}

