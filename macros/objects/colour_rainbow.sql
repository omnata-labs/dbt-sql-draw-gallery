{% macro colour_rainbow(center=[100,100], height=150,stripe_height=10) %}
case
    when y >= {{ center[1] }} and POWER(x-{{ center[0] }},2) + POWER(y-{{ center[1] }},2) between POWER({{ (height)-(stripe_height) }},2)   and POWER({{ (height) }},2)                   then '#F60000' -- red
    when y >= {{ center[1] }} and POWER(x-{{ center[0] }},2) + POWER(y-{{ center[1] }},2) between POWER({{ (height)-(2*stripe_height) }},2) and POWER({{ (height)-(stripe_height) }},2)   then '#FF8C00' -- orange
    when y >= {{ center[1] }} and POWER(x-{{ center[0] }},2) + POWER(y-{{ center[1] }},2) between POWER({{ (height)-(3*stripe_height) }},2) and POWER({{ (height)-(2*stripe_height) }},2) then '#FFEE00' -- yellow
    when y >= {{ center[1] }} and POWER(x-{{ center[0] }},2) + POWER(y-{{ center[1] }},2) between POWER({{ (height)-(4*stripe_height) }},2) and POWER({{ (height)-(3*stripe_height) }},2) then '#4DE94C' -- green
    when y >= {{ center[1] }} and POWER(x-{{ center[0] }},2) + POWER(y-{{ center[1] }},2) between POWER({{ (height)-(5*stripe_height) }},2) and POWER({{ (height)-(4*stripe_height) }},2) then '#3783FF' -- blue
    when y >= {{ center[1] }} and POWER(x-{{ center[0] }},2) + POWER(y-{{ center[1] }},2) between POWER({{ (height)-(6*stripe_height) }},2) and POWER({{ (height)-(5*stripe_height) }},2) then '#4815AA' -- purple
end
{% endmacro %}