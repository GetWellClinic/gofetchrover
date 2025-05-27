#!/bin/bash

# Variables
REPO_URL="git@github.com:GetWellClinic/hl7_file_management.git"
CLONE_DIR="./Docker/mule"

# Clone the repo into ./Docker/mule
if [ -d "$CLONE_DIR/.git" ]; then
    echo "Repo already cloned in $CLONE_DIR. Pulling latest changes..."
    git -C "$CLONE_DIR" pull
else
    echo "Cloning repo into $CLONE_DIR..."
    git clone "$REPO_URL" "$CLONE_DIR"
fi

# Path to the properties file
properties_file="./volumes/LabProperties.properties"

# Destination directory for the copied properties file
destination_path="./Docker/mule/src/main/resources/LabProperties.properties"

# Copy the properties file to the target location and replace any existing file
cp -f "$properties_file" "$destination_path"

./bin/jdk-download.sh

docker compose -f docker-compose.build.yml build builder

docker compose -f docker-compose.build.yml run --rm builder ./bin/build-mule.sh