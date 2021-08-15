# dbt-sql-draw-gallery

This dbt project holds macros and models for drawing bitmaps via SQL.

## Macro types
There are three categories of SQL draw macro.

### Pixel assertion
Returns an expression that evaluates to true or false to indicate the coordinate has been selected. Can be used anywhere in the query.
These should start with is_ or has_.
Examples:
 - Shapes, e.g. is_in_circle, is_oval

## Colour selection
Returns an expression that evaluates to a (varchar) colour value to nominate a colour.
These should start with colour_of_

Examples:
- Objects, e.g. colour_of_rainbow
- Filters, e.g. colour_blurred

## Utility
Performs some specific task, like format conversion, encoding, or a dictionary of values.
Examples:
- colour_code
- hex_to_rgb

## Shapes (circle, square, oval, etc)
These are intended to define a boundary of pixels, without an opinion on colour or size.
They return a conditional express, which will be true when the coordinate falls within the boundary of the shape. The user chooses the colour
Use like: 
`update bitmap_pixels set colour = 'red' where {{ the_macro() }}`
or
`update bitmap_pixels set colour = case when {{ the_macro() }} then 'red' else 'green' end`

## Objects (rainbow, brick wall, dog, tree, etc)
These are intended to draw something specific, with defined colours. Ideally, they will also be scale-agnostic.
They return a when..then statement which includes the colour.

Use like:
`update bitmap_pixels set colour = case {{ rainbow() }} else colour end`

## Filters (blur,anti-alias,invert)
These are intended to output colours based on the existing colour at each pixel, possibly also using neighbouring colours.
Like objects, they return a when..then statement which includes the colour.

# Local development

## Prerequisites
- python 3
- dbt
- docker (for running postgres)

## Creating a database

Spin up a local postgres container in docker:
```
docker run --name postgres-dbt-local -e POSTGRES_PASSWORD=my_password -p 5432:5432 -d postgres:13.2-alpine
```

Configure your `~/.dbt/profiles.yml` to contain:

```
dbt_sql_draw:
  target: localpostgres
  outputs:
    localpostgres:
      type: postgres
      host: localhost
      user: postgres
      pass: my_password
      port: 5432
      dbname: postgres
      schema: sql_draw
```

## Build the models
Install dbt, then:
```
dbt run --target localpostgres
```
## Generate images

```
pip3 install -r requirements.txt
export POSTGRES_DB_NAME=postgres
export POSTGRES_USERNAME=postgres
export POSTGRES_PASSWORD=my_password
export POSTGRES_HOSTNAME=localhost
export POSTGRES_SCHEMA_NAME='sql_draw'

python3 ci/render_images_from_db.py
```

Now check the images/ directory

## When finished
Remove local postgres container:
```
docker rm postgres-dbt-local
```



