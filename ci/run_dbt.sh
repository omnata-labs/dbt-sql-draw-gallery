#!/bin/bash
set -e

VENV="venv/bin/activate"

if [[ ! -f $VENV ]]; then
    python3 -m venv venv
    . $VENV

    pip install --upgrade pip setuptools
    pip install --pre "dbt<0.20.0"
fi

. $VENV

if [[ ! -e ~/.dbt/profiles.yml ]]; then
    mkdir -p ~/.dbt
    cp ci/sample.profiles.yml ~/.dbt/profiles.yml
fi

dbt deps --target postgres
dbt seed --target postgres
dbt run --target postgres --full refresh
dbt docs generate --target postgres
