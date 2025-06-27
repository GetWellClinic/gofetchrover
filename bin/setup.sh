#!/bin/bash
# Setup script for GoFetchRover
# Version 2025.06.21

# Note: This script should be run in ../bin directory for autodetect base directory to be correct


# Autodetect base directory for GoFetchRover

cd ..
export GOFETCHROVER=$(pwd)

echo "GOFETCHROVER is set to: $GOFETCHROVER"


# Start directory creation
echo "Creating directories..."
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


read -p "Do you want to extract the PFX file? (y/n): " answer
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

if [[ "$answer" == "y" || "$answer" == "yes" ]]; then
  cd bin/
  ./extract-pfx.sh
fi
