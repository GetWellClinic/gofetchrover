#!/bin/bash
# Setup script for GoFetchRover
# Version 2025.06.06

# Note: This script should be run in ../bin directory for autodetect base directory to be correct


# Autodetect base directory for GoFetchRover
cd ..
GOFETCHROVER=$(pwd)
/bin/echo ""
/bin/echo "GoFetchRover will be setup/initialized with the following specified based directory..."
/bin/echo "	BASE DIRECTORY: "$(pwd)
/bin/echo ""
/bin/echo "...if this is not the desired or correct directory for GoFetchRover, please press Ctrl-C to cancel installation now!"
read -p "	(Press any key to continue)"
/bin/echo ""

# Backup with datestamp previous JSON config

# Create directories
/bin/echo "Creating directories..."
/bin/sleep 1s
/bin/mkdir -p "$GOFETCHROVER/logs"
/bin/mkdir -p "$GOFETCHROVER/volumes/secrets"
/bin/echo ""

# Create JSON from template
/bin/echo "Creating configuration JSON files from templates..."
/bin/sleep 1s
/usr/bin/cp "$GOFETCHROVER/volumes/rover/rover_config.json.example" "$GOFETCHROVER/volumes/rover/rover_config.json"
/usr/bin/cp "$GOFETCHROVER/volumes/dcare/dynacare_config.json.example" "$GOFETCHROVER/volumes/dcare/dynacare_config.json"
/bin/echo ""

# Copying extract-pfx.sh tool
/bin/echo "...copying extract-pfx.sh tool..."
/bin/sleep 1s
/bin/cp $GOFETCHROVER/bin/extract-pfx.sh.sample $GOFETCHROVER/volumes/secrets/extract-pfx.sh
/bin/echo ""

# Create group
/bin/echo "Creating group 'rover' and adding user to group..."
/bin/sleep 1s
/usr/sbin/useradd -m rover
/usr/sbin/usermod -a -G rover $USER
# /usr/sbin/usermod -a -G rover $USERNAME
/bin/echo ""

# Initialize Permissions
/bin/echo "Fixing permissions..."
/bin/sleep 1s
/bin/chown rover:rover "$GOFETCHROVER" -R
/bin/chmod g+rwx $GOFETCHROVER/volumes/secrets
/bin/chmod g+rx $GOFETCHROVER/volumes/secrets/extract-pfx.sh
# Protect files and directory from Others
/bin/chmod o-rwx "$GOFETCHROVER/volumes/secrets"
sudo sh -c "/bin/chmod o-rwx $GOFETCHROVER/volumes/rover/*.json" 
sudo sh -c "/bin/chmod o-rwx $GOFETCHROVER/volumes/dcare/*.json"
/bin/echo

# Post-installation messages
/bin/echo "Read ../docs/*.md for instructions on installing mule HL7-uploader, and lab connectors."
/bin/echo ""
