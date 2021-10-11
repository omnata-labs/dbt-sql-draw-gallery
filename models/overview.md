{% docs __overview__ %}
# 🎨 SQL Draw Gallery 🎨

This gallery is a `dbt docs` rendering of [this Github repository](https://github.com/omnata-labs/dbt-sql-draw-gallery).

It contains...

## macros

The macros folder contains macros that can be used *both* in Slack, and in the models of this repository. Any macro in the main branch of the repository is automatically available to use in the context of Slack queries.

Drill down to the docs for each macro to see usage instructions.

If you've created a handy macro in Slack, feel free to open a pull request so that others can use it it. Please include documentation, and ideally an example model for people to visually see what it does.

## models

In Slack, artworks are "edited" directly using `update` statements.

In contrast, the models folder contains artworks that have been built incrementally using the `new_layer` custom materialization.

You can read more about how this works [here](https://omnata.com/sql-draw/gallery).

Pull requests for models are welcome, provided they do not vandalize other people's artworks.



{% enddocs %}