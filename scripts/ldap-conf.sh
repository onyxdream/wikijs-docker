#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."

set -a
source $PROJECT_ROOT/.env
set +a

if [ "$LDAP_TEST" != "true" ]; then
    echo "LDAP integration is not enabled. Exiting."
    exit 0
fi

LDAP_DIR="$PROJECT_ROOT/ldap"

if [ -f $LDAP_DIR/template.ldif ]; then
    sed -e "s/\$DOMAIN/$DOMAIN/g" -e "s/\$BASE_DN/$LDAP_BASE_DN/g" $LDAP_DIR/template.ldif > $LDAP_DIR/bootstrap.ldif
    echo "bootstrap.ldif file created from template.ldif file."
fi