{% materialization new_layer, default %}


  {%- set identifier = model['alias'] -%}
  {%- set tmp_identifier = model['name'] + '__dbt_tmp' -%}
  {%- set backup_identifier = model['name'] + '__dbt_backup' -%}
  {%- set source_name = model['name'] -%}

{% set sources_list = [] -%}
{% for node in graph.nodes.values() | selectattr("name", "equalto", identifier) -%}
  {% if node.refs | length > 1 %}
    {% set error_message %}
      When using the 'new_layer' materialization, there should be a single reference to the parent canvas.
    {% endset %}
    {%- do exceptions.raise_compiler_error(error_message) -%}
  {% endif %}
  {% for ref in node.refs -%}
    {%- do sources_list.append(ref[0]) -%}
  {%- endfor %}
{%- endfor %}


  {%- set old_relation = adapter.get_relation(database=database, schema=schema, identifier=identifier) -%}
  {%- set target_relation = api.Relation.create(identifier=identifier,
                                                schema=schema,
                                                database=database,
                                                type='table') -%}
  {%- set intermediate_relation = api.Relation.create(identifier=tmp_identifier,
                                                      schema=schema,
                                                      database=database,
                                                      type='table') -%}

  /*
      See ../view/view.sql for more information about this relation.
  */
  {%- set backup_relation_type = 'table' if old_relation is none else old_relation.type -%}
  {%- set backup_relation = api.Relation.create(identifier=backup_identifier,
                                                schema=schema,
                                                database=database,
                                                type=backup_relation_type) -%}

  {%- set exists_as_table = (old_relation is not none and old_relation.is_table) -%}
  {%- set exists_as_view = (old_relation is not none and old_relation.is_view) -%}


  -- drop the temp relations if they exists for some reason
  {{ adapter.drop_relation(intermediate_relation) }}
  {{ adapter.drop_relation(backup_relation) }}

  {{ run_hooks(pre_hooks, inside_transaction=False) }}

  -- `BEGIN` happens here:
  {{ run_hooks(pre_hooks, inside_transaction=True) }}

  {%- set clone_sql -%}
      {%- for source in sources_list %}
      -------- AAAA
        select * from {{ ref(source) }}
        ------ AAAAA
      {% endfor %}
  {%- endset -%}

  {% call statement('main') -%}
    {{ create_table_as(False, intermediate_relation, clone_sql) }}
  {%- endcall %}


  -- build model
  {% call statement('main') -%}
  with new_layer as(
    {{ sql }}
  )
  update {{ intermediate_relation }} intermediate_relation
  set colour = new_layer.colour
  from new_layer where new_layer.x=intermediate_relation.x and new_layer.y=intermediate_relation.y

  {%- endcall %}

  -- cleanup
  {% if old_relation is not none %}
      {{ adapter.rename_relation(target_relation, backup_relation) }}
  {% endif %}

  {{ adapter.rename_relation(intermediate_relation, target_relation) }}

  {{ run_hooks(post_hooks, inside_transaction=True) }}

  -- `COMMIT` happens here
  {{ adapter.commit() }}

  -- finally, drop the existing/backup relation after the commit
  {{ drop_relation_if_exists(backup_relation) }}

  {{ run_hooks(post_hooks, inside_transaction=False) }}

  {{ return({'relations': [target_relation]}) }}

{% endmaterialization %}