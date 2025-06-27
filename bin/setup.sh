#!/bin/bash
# Setup script for GoFetchRover
# Version 2025.06.21

# Note: This script should be run in ../bin directory for autodetect base directory to be correct


# Autodetect base directory for GoFetchRover

cd ..
export GOFETCHROVER=$(pwd)

echo ""
echo "GOFETCHROVER is set to: $GOFETCHROVER"
echo ""


# Start directory creation
echo "Creating directories..."
echo ""
sleep 1s

# Create directory structure
mkdir -p "$GOFETCHROVER/volumes/secrets"
mkdir -p "$GOFETCHROVER/volumes/keys"
mkdir -p "$GOFETCHROVER/volumes/incoming"
mkdir -p "$GOFETCHROVER/volumes/completedHL7dir"
mkdir -p "$GOFETCHROVER/volumes/errorHL7dir"
mkdir -p "$GOFETCHROVER/volumes/dcare/files"
mkdir -p "$GOFETCHROVER/volumes/alphalab/files"
mkdir -p "$GOFETCHROVER/volumes/medhealth/files"

echo "Created directories."
echo ""

# Update timezoneMore actions
echo "Update your correct timezone to synchronize logs..."
echo ""

read -p "Do you want to configure your timezone now? (y/n): " answer
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

if [[ "$answer" == "y" || "$answer" == "yes" ]]; then
    /usr/bin/tzselect
fi

# Backup with datestamp previous JSON config
echo "Backing up existing JSON config files..."
sleep 1s
cp "$GOFETCHROVER/volumes/rover/rover_config.json" "$GOFETCHROVER/volumes/rover/rover_config.json.$(date +'%Y-%m-%d')"
cp "$GOFETCHROVER/volumes/dcare/dynacare_config.json" "$GOFETCHROVER/volumes/dcare/dynacare_config.json.$(date +'%Y-%m-%d')"
cp "$GOFETCHROVER/volumes/alphalab/alphalab_config.json" "$GOFETCHROVER/volumes/alphalab/alphalab_config.json.$(date +'%Y-%m-%d')"
cp "$GOFETCHROVER/volumes/medhealth/medhealth_config.json" "$GOFETCHROVER/volumes/medhealth/medhealth_config.json.$(date +'%Y-%m-%d')"

# Create JSON from templateMore actions
echo "Creating new JSON configuration files from templates..."
sleep 1s
cp "$GOFETCHROVER/volumes/rover/rover_config.json.example" "$GOFETCHROVER/volumes/rover/rover_config.json"
cp "$GOFETCHROVER/volumes/dcare/dynacare_config.json.example" "$GOFETCHROVER/volumes/dcare/dynacare_config.json"
cp "$GOFETCHROVER/volumes/alphalab/alphalab_config.json.example" "$GOFETCHROVER/volumes/alphalab/alphalab_config.json"
cp "$GOFETCHROVER/volumes/medhealth/medhealth_config.json.example" "$GOFETCHROVER/volumes/medhealth/medhealth_config.json"
echo ""

read -p "Do you want to extract the PFX file? (y/n): " answer
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

if [[ "$answer" == "y" || "$answer" == "yes" ]]; then
  cd bin/
  ./extract-pfx.sh
fi
