#!/bin/bash

LOG_DIR="/volumes/rover/"              
STAGING_DIR="/tmp/logs_staging"      
BACKUP_DIR="/volumes/rover/logs/backup"       
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/logs_backup_$TIMESTAMP.tar.gz"

mkdir -p "$STAGING_DIR"
mkdir -p "$BACKUP_DIR"

# Check if log directory exists
if [ ! -d "$LOG_DIR" ]; then
  echo "Log directory $LOG_DIR does not exist, skipping backup."
  exit 0
fi

# Check if there are any .log files
if ! find "$LOG_DIR" -maxdepth 1 -type f -name "*.log" | grep -q .; then
  echo "No .log files found in $LOG_DIR, nothing to back up."
  exit 0
fi

echo "Moving .log files from $LOG_DIR to $STAGING_DIR"
find "$LOG_DIR" -maxdepth 1 -type f -name "*.log" -exec mv {} "$STAGING_DIR" \;

echo "Creating backup archive at $BACKUP_FILE"
tar -czf "$BACKUP_FILE" -C "$STAGING_DIR" .

echo "Deleting staged .log files"
rm -f "$STAGING_DIR"/*.log

echo "Backup complete and original log files removed."
