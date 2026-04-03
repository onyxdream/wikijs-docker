#!/bin/bash

backup_path="/home/cursor/backups"
timestamp=$(date +"%Y%m%d%H%M%S")
backup_file="$backup_path/wikijs_backup_$timestamp.dump"
rotation_limit=5

set -a
source ../.env
set +a

if [ -f "$backup_file" ]; then
    echo "Backup file already exists: $backup_file"
    exit 1
fi


if [ ! -d "$backup_path" ]; then
    echo "Backup path does not exist. Creating: $backup_path"
    mkdir -p "$backup_path" >/dev/null
fi

if [ $? -ne 0 ]; then
    echo "Failed to create backup directory: $backup_path"
    exit 1
fi

if [ ! -w "$backup_path" ]; then
    echo "Backup path is not writable: $backup_path"
    exit 1
fi
    

docker compose exec -T psql env PGPASSWORD="$DB_PASS" pg_dump -Fc -U "$DB_USER" "$DB_NAME" > "$backup_file"

if [[ $? -eq 0 ]]; then
    # backup successful
    echo "Backup created successfully: $backup_file"
    
    count=$(ls -tr "$backup_path" | grep '^wikijs_backup_' | wc -l)

    if [ $count -gt $rotation_limit ]; then
        # delete oldest backup
        oldest_backup=$(ls -tr "$backup_path" | grep '^wikijs_backup_' | head -n 1)
        rm "$backup_path/$oldest_backup"
        echo "Deleted oldest backup: $oldest_backup"
    fi

    exit 0
else 
    # backup failed
    echo "Backup failed: $backup_file"
    exit 1
fi