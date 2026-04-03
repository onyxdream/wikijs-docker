#!/bin/bash

# this script copies the nginx templates on nignx/template/ and copies it to nginx/conf.d with the correct domain information, from the .env

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."

set +a
source "$PROJECT_ROOT/.env"
set -a

if [ ! -d "$PROJECT_ROOT/nginx/conf.d" ]; then
    mkdir -p "$PROJECT_ROOT/nginx/conf.d"
fi

# copy the nginx templates to the nginx conf.d directory with the correct domain information
sed "s/\$DOMAIN/$DOMAIN/g" "$PROJECT_ROOT/nginx/template/wiki.conf" > "$PROJECT_ROOT/nginx/conf.d/wiki.conf"
sed "s/\$DOMAIN/$DOMAIN/g" "$PROJECT_ROOT/nginx/template/grafana.conf" > "$PROJECT_ROOT/nginx/conf.d/grafana.conf"
sed "s/\$DOMAIN/$DOMAIN/g" "$PROJECT_ROOT/nginx/template/default.conf" > "$PROJECT_ROOT/nginx/conf.d/default.conf"