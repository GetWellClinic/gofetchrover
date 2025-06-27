#!/bin/bash

# Move up one directory
cd ..

# Set and export GOFETCHROVER to the current working directory
export GOFETCHROVER="$(pwd)"
echo "GOFETCHROVER is set to: $GOFETCHROVER"

# Find all .sh files in GOFETCHROVER and set permissions to 750
echo "Setting permissions to 750 for all .sh files in $GOFETCHROVER..."
sudo find "$GOFETCHROVER" -type f -name "*.sh" -exec chmod 750 {} \;
sudo chmod 750 mule
sudo chmod 750 gofetch
sudo chmod 750 fetchnow

echo "Permission update complete."
