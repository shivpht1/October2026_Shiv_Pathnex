#!/bin/bash

SOURCE_DIR="/tmp/pathnex-logs"
BACKUP_DIR="/tmp/pathnex-backups"

DATE=$(date +%Y%m%d_%H%M%S)

echo "======================================"
echo "       PathNex Log Backup Script"
echo "======================================"

echo "Source directory : $SOURCE_DIR"
echo "Backup directory : $BACKUP_DIR"

# Create directories if they do not exist
mkdir -p "$SOURCE_DIR"
mkdir -p "$BACKUP_DIR"

# Create sample log files for practice
echo "Application started successfully" > "$SOURCE_DIR/application.log"
echo "INFO: Database connection successful" > "$SOURCE_DIR/database.log"
echo "WARNING: High memory usage detected" > "$SOURCE_DIR/system.log"

BACKUP_FILE="$BACKUP_DIR/pathnex_logs_$DATE.tar.gz"

echo "Creating backup..."

tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .

if [ $? -eq 0 ]; then
    echo "Backup completed successfully."
    echo "Backup file: $BACKUP_FILE"
else
    echo "Backup failed."
    exit 1
fi

echo "======================================"