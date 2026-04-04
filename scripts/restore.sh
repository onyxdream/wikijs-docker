#!/bin/sh

file="$1"

if [ -z "$file" ]; then
    echo "Usage: $0 <backup_file>"
    exit 1
fi

if [ ! -f "$file" ]; then
    echo "Backup file does not exist: $file"
    exit 1
fi

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."

set -a
source $PROJECT_ROOT/.env
set +a

# stop wikijs to avoid conflicts
docker compose stop wikijs
docker compose stop postgres-exporter

echo "Restoring backup from file: $file"
docker compose exec -T psql env PGPASSWORD="$DB_PASS" pg_restore -U "$DB_USER" -d "$DB_NAME" --clean --if-exists < "$file"

# start wikijs
docker compose start wikijs
docker compose start postgres-exporter

echo "Restore completed successfully from file: $file"