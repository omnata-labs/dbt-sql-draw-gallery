{# -- This is a canned update statement, used in slack activities only #}
{# -- It draws a pig, where the x,y coordinates are at the bottom centre #}
{% macro draw_pig(x,y) %}
update bitmap_pixels set colour=case

-- tail
when {{ is_in_spiral_point(center=[x+45,y+50],step_size=0.1, outward_movement=1.2,starting_point=2, total_length=11,rotation=-1) }} then 'rgb(247,191,182)'


-- nose
when {{ is_in_oval(center=[x,y+50], diameter=25, ratio_x=1,ratio_y=0.6) }} and not ({{ is_in_oval(center=[x,y+50], diameter=23, ratio_x=1,ratio_y=0.6) }}) then '#000000' 

-- nostrils
when point (x,y) <@ circle '(({{x-5}},{{y+50}}),2)' or point (x,y) <@ circle '(({{x+5}},{{y+50}}),2)' then '#000000' 

-- eyes
when point (x,y) <@ circle '(({{x-12}},{{y+69}}),2)' then '#000000' -- pupil
when point (x,y) <@ circle '(({{x-13}},{{y+70}}),6)' then '#ffffff' -- whites
when point (x,y) <@ circle '(({{x+11}},{{y+69}}),2)' then '#000000' -- pupil
when point (x,y) <@ circle '(({{x+12}},{{y+70}}),6)' then '#ffffff' -- whites
when (point (x,y) <@ circle '(({{x-10}},{{y}}),10)' or point (x,y) <@ circle '(({{x+10}},{{y}}),10)') and y > {{y}} then '#3E2323'

-- head
when point (x,y) <@ circle '(({{x}},{{y+60}}),30)' then 'rgb(247,198,198)' 

-- body
when point (x,y) <@ circle '(({{x}},{{y+40}}),40)' then 'rgb(247,191,181)' 

-- ears
when {{ is_in_oval(center=[x-13,y+85], diameter=25, ratio_x=1,ratio_y=0.6, rotation=0.7) }} then 'rgb(247,191,181)'
when {{ is_in_oval(center=[x+13,y+85], diameter=25, ratio_x=1,ratio_y=0.6, rotation=-0.7) }} then 'rgb(247,191,181)' 

else colour end;
{% endmacro %}