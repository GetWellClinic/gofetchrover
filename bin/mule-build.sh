#!/bin/bash

# Path to the properties file
properties_file="./volumes/LabProperties.properties"

# Destination directory for the copied properties file
destination_path="./Docker/mule/src/main/resources/LabProperties.properties"

# Copy the properties file to the target location and replace any existing file
cp -f "$properties_file" "$destination_path"

./bin/jdk-download.sh

docker compose -f docker-compose.build.yml build builder

docker compose -f docker-compose.build.yml run --rm builder ./bin/build-mule.sh