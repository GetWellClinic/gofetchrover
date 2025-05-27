#!/bin/bash
./bin/jre-download.sh

# Backup directory
BACKUP_DIR="./Docker/muled/backup"

# Create the directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Install directory
INSTALL_DIR="./Docker/muled/install"
MULE_INSTALL_DIR="./Docker/mule/mule-1.3.3/lib/user/"

# Create the directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Expand the wildcard
JARFILE=$(echo "$INSTALL_DIR"/*.jar)

# Check if file exists
if [[ ! -f "$JARFILE" ]]; then
  echo "No JAR file found in $INSTALL_DIR"
fi

BASENAME=$(basename "$JARFILE" .jar)
NEW_NAME="${BASENAME}_${TIMESTAMP}.jar"

mv "$JARFILE" "$BACKUP_DIR/$NEW_NAME"

echo "Moved: $JARFILE -> $BACKUP_DIR/$NEW_NAME"

SOURCE_JAR="./Docker/mule/target/IncomingHL7Management-1.0-SNAPSHOT.jar"

if [[ -f "$SOURCE_JAR" ]]; then
    cp "$SOURCE_JAR" "$INSTALL_DIR/"
    cp -f "$SOURCE_JAR" "$MULE_INSTALL_DIR/"
    echo "Copied $SOURCE_JAR to $INSTALL_DIR/"
else
    echo "Source JAR file $SOURCE_JAR does not exist."
    exit 1
fi

docker compose up -d --build muled
