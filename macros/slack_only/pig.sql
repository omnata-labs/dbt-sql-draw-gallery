{# -- This is a canned update statement, used in slack activities only #}
{# -- It draws a pig, where the x,y coordinates are at the bottom centre #}
{% macro pig(x,y,width=80) %}
case
  -- tail
  when {{ is_in_spiral_point(center=[x+(width*0.5625)|int,y+(width*0.625)|int],step_size=0.1, outward_movement=1.2,starting_point=2, total_length=(width*0.1375),rotation=-1) }} then 'rgb(247,191,182)'
  -- nose
  when {{ is_in_oval(center=[x,y+(width*0.625)], diameter=(width*0.3125), ratio_x=1,ratio_y=0.6) }} 
      and not ({{ is_in_oval(center=[x,y+(width*0.625)], diameter=(width*0.25), ratio_x=1,ratio_y=0.6) }}) then '#000000' 
  -- nostrils
  when point (x,y) <@ circle '(({{x-(width*0.0625)}},{{y+(width*0.625)}}),{{width*0.025}})' 
      or point (x,y) <@ circle '(({{x+(width*0.0625)}},{{y+(width*0.625)}}),{{width*0.025}})' then '#000000' 
  -- eyes
  when point (x,y) <@ circle '(({{x-(width*0.15)}},{{y+(width*0.8625)}}),{{width*0.0375}})' then '#000000' -- pupil
  when point (x,y) <@ circle '(({{x-(width*0.1625)}},{{y+(width*0.875)}}),{{width*0.075}})' then '#ffffff' -- whites
  when point (x,y) <@ circle '(({{x+(width*0.15)}},{{y+(width*0.8625)}}),{{width*0.0375}})' then '#000000' -- pupil
  when point (x,y) <@ circle '(({{x+(width*0.1625)}},{{y+(width*0.875)}}),{{width*0.075}})' then '#ffffff' -- whites
  when (point (x,y) <@ circle '(({{x-(width*0.125)}},{{y}}),{{width*0.125}})' 
         or point (x,y) <@ circle '(({{x+(width*0.125)}},{{y}}),{{width*0.125}})') 
         and y > {{y}} then '#3E2323'
  -- head
  when point (x,y) <@ circle '(({{x}},{{y+(width*0.75)}}),{{width*0.375}})' then 'rgb(247,198,198)' 
  when point (x,y) <@ circle '(({{x}},{{y+(width*0.75)}}),{{width*0.375+1}})' then '#000000'  
  -- body
  when point (x,y) <@ circle '(({{x}},{{y+(width/2)}}),{{width/2}})' then 'rgb(247,191,181)' 
  when point (x,y) <@ circle '(({{x}},{{y+(width/2)}}),{{width/2+1}})' then '#000000'
  -- ears
  when {{ is_in_oval(center=[x-(width*0.1625),y+(width*1.0625)], diameter=(width*0.3125), ratio_x=1,ratio_y=0.6, rotation=0.7) }} then 'rgb(247,191,181)'
  when {{ is_in_oval(center=[x-(width*0.1625),y+(width*1.0625)], diameter=(width*0.3125+2), ratio_x=1,ratio_y=0.6, rotation=0.7) }} then '#000000'

  when {{ is_in_oval(center=[x+(width*0.1625),y+(width*1.0625)], diameter=(width*0.3125), ratio_x=1,ratio_y=0.6, rotation=-0.7) }} then 'rgb(247,191,181)' 
  when {{ is_in_oval(center=[x+(width*0.1625),y+(width*1.0625)], diameter=(width*0.3125+2), ratio_x=1,ratio_y=0.6, rotation=-0.7) }} then '#000000'
else colour end
{% endmacro %}