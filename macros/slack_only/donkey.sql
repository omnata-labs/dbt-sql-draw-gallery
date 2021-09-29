{% macro donkey(x,y,width=100) %} 
case
    -- nostrils
    when point (x,y) <@ circle '(({{(x-(width*0.20))}},{{y+(width*0.65)}}),{{width*0.05}})' 
    or point (x,y) <@ circle '(({{(x+(width*0.20))}},{{y+(width*0.65)}}),{{width*0.05}})' then '#8F8F8F'
    -- nose outline
    when point(x,y) <-> path'(({{(x-(width*0.30))}},{{y+(width*0.45)}}),({{(x+(width*0.30))}},{{y+(width*0.45)}}),({{(x+(width*0.30))}},{{y+(width*0.75)}}),({{(x-(width*0.30))}},{{y+(width*0.75)}}))' <= 1 then '#30200B'
    -- nose
    when point(x,y) <@ path'(({{(x-(width*0.30))}},{{y+(width*0.45)}}),({{(x+(width*0.30))}},{{y+(width*0.45)}}),({{(x+(width*0.30))}},{{y+(width*0.75)}}),({{(x-(width*0.30))}},{{y+(width*0.75)}}))' then '#E4E3E1'
    -- pupils
    when (point (x,y) <@ circle '(({{(x-(width*0.25))}},{{y+(width*1.15)}}),{{width*0.09}})' 
    or point (x,y) <@ circle '(({{(x+(width*0.25))}},{{y+(width*1.15)}}),{{width*0.09}})') then '#525252'
    -- pupil outline
    when ((point (x,y) <@ circle '(({{(x-(width*0.25))}},{{y+(width*1.15)}}),{{width*0.1}})') or
        (point (x,y) <@ circle '(({{(x+(width*0.25))}},{{y+(width*1.15)}}),{{width*0.1}})')) then '#30200B'
    -- eye whites
    when x between {{(x-(width*0.50))}} and {{(x+(width*0.50))}} and 
        (point (x,y) <@ circle '(({{(x-(width*0.30))}},{{y+(width*1.15)}}),{{(width*0.24)}})' 
    or point (x,y) <@ circle '(({{(x+(width*0.30))}},{{y+(width*1.15)}}),{{width*0.24}})') then '#ffffff'
    -- eye outline
    when x between {{(x-(width*0.50))}} and {{(x+(width*0.50))}} and
        ((point (x,y) <@ circle '(({{(x-(width*0.30))}},{{y+(width*1.15)}}),{{width*0.25}})') or
        (point (x,y) <@ circle '(({{(x+(width*0.30))}},{{y+(width*1.15)}}),{{width*0.25}})')) then '#30200B'
    -- right ear
    when point(x,y) <@ path '(({{(x+(width*0.50))}},{{y+(width*1.5)}}),({{(x+(width*0.60))}},{{y+(width*1.8)}}),({{(x+(width*0.65))}},{{y+(width*1.6)}}),({{(x+(width*0.62))}},{{y+(width*1.5)}}),({{(x+(width*0.50))}},{{y+(width*1.4)}}))' then '#989898'
    when point(x,y) <-> path '(({{(x+(width*0.50))}},{{y+(width*1.5)}}),({{(x+(width*0.60))}},{{y+(width*1.8)}}),({{(x+(width*0.65))}},{{y+(width*1.6)}}),({{(x+(width*0.62))}},{{y+(width*1.5)}}),({{(x+(width*0.50))}},{{y+(width*1.4)}}))' <= 1 then '#30200B'
    -- left ear
    when point(x,y) <@ path '(({{(x-(width*0.50))}},{{y+(width*1.5)}}),({{(x-(width*0.60))}},{{y+(width*1.8)}}),({{(x-(width*0.65))}},{{y+(width*1.6)}}),({{(x-(width*0.62))}},{{y+(width*1.5)}}),({{(x-(width*0.50))}},{{y+(width*1.4)}}))' then '#989898'
    when point(x,y) <-> path '(({{(x-(width*0.50))}},{{y+(width*1.5)}}),({{(x-(width*0.60))}},{{y+(width*1.8)}}),({{(x-(width*0.65))}},{{y+(width*1.6)}}),({{(x-(width*0.62))}},{{y+(width*1.5)}}),({{(x-(width*0.50))}},{{y+(width*1.4)}}))' <= 1 then '#30200B'
    -- hair fill
    when point(x,y) <@ path '(({{(x+(width*0.30))}},{{y+(width*1.5)}}),({{(x+(width*0.30))}},{{y+(width*1.7)}}),({{(x+(width*0.10))}},{{y+(width*2)}}),({{(x+(width*0.10))}},{{y+(width*1.8)}}),({{(x-(width*0.10))}},{{y+(width*1.9)}}),({{(x-(width*0.10))}},{{y+(width*1.7)}}),({{(x-(width*0.30))}},{{y+(width*1.8)}}),({{(x-(width*0.25))}},{{y+(width*1.6)}}),({{(x-(width*0.30))}},{{y+(width*1.5)}}))' then '#525252'
    -- hair line
    when point(x,y) <-> path '(({{(x+(width*0.30))}},{{y+(width*1.5)}}),({{(x+(width*0.30))}},{{y+(width*1.7)}}),({{(x+(width*0.10))}},{{y+(width*2)}}),({{(x+(width*0.10))}},{{y+(width*1.8)}}),({{(x-(width*0.10))}},{{y+(width*1.9)}}),({{(x-(width*0.10))}},{{y+(width*1.7)}}),({{(x-(width*0.30))}},{{y+(width*1.8)}}),({{(x-(width*0.25))}},{{y+(width*1.6)}}),({{(x-(width*0.30))}},{{y+(width*1.5)}}))' <= 1 then '#30200B'
    -- feet
    when point(x,y) <-> path'[({{(x+(width*0.20))}},{{y}}),({{(x+(width*0.40))}},{{y}}),({{(x+(width*0.40))}},{{y+(width*0.3)}}),({{(x+(width*0.40))}},{{y+(width*0.15)}}),({{(x+(width*0.20))}},{{y+(width*0.15)}}),({{(x+(width*0.20))}},{{y+(width*0.3)}}),({{(x+(width*0.20))}},{{y}})]' <= 1 
    or point(x,y) <-> path'[({{(x-(width*0.40))}},{{y}}),({{(x-(width*0.20))}},{{y}}),({{(x-(width*0.20))}},{{y+(width*0.3)}}),({{(x-(width*0.20))}},{{y+(width*0.15)}}),({{(x-(width*0.40))}},{{y+(width*0.15)}}),({{(x-(width*0.40))}},{{y+(width*0.3)}}),({{(x-(width*0.40))}},{{y}})]' <= 1 then '#30200B'
    -- feet fill
    when point(x,y) <@ path'(({{(x+(width*0.20))}},{{y}}),({{(x+(width*0.40))}},{{y}}),({{(x+(width*0.40))}},{{y+(width*0.15)}}),({{(x+(width*0.20))}},{{y+(width*0.15)}}))' then '#525252'
    when point(x,y) <@ path'(({{(x-(width*0.40))}},{{y}}),({{(x-(width*0.20))}},{{y}}),({{(x-(width*0.20))}},{{y+(width*0.15)}}),({{(x-(width*0.40))}},{{y+(width*0.15)}}))' then '#525252'
    -- body outline
    when point(x,y) <-> path'(({{(x-(width*0.50))}},{{y+1}}),({{(x+(width*0.50))}},{{y+1}}),({{(x+(width*0.50))}},{{y+(width*1.5)}}),({{(x-(width*0.50))}},{{y+(width*1.5)}}))' <= 1 then '#30200B'
    -- body
    when point(x,y) <@ path'(({{(x-(width*0.50))}},{{y}}),({{(x+(width*0.50))}},{{y}}),({{(x+(width*0.50))}},{{y+(width*1.5)}}),({{(x-(width*0.50))}},{{y+(width*1.5)}}))' then '#989898'
    else colour end
{% endmacro %}

