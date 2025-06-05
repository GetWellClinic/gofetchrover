#!/bin/bash
# Setup script for fixing permissions in GoFetchRover after a git pull update
# Version 2025.06.06

# Note: This script should be run in ../bin directory for autodetect base directory to be correct


# Autodetect base directory for GoFetchRover
cd ..
GOFETCHROVER=$(pwd)
/bin/echo ""
/bin/echo "Confirm that GoFetchRover is in the correct specified based directory..."
/bin/echo "		BASE DIRECTORY: "$(pwd)
/bin/echo ""
/bin/echo "...if this is not the correct directory for GoFetchRover, please press Ctrl-C to cancel installation now!"
read -p "	(Press any key to continue)"
/bin/echo ""

# Initialize Permissions
/bin/echo "Fixing permissions..."
/bin/sleep 1s
/bin/chown rover:rover "$GOFETCHROVER" -R
/bin/chmod g+rwx $GOFETCHROVER/volumes/secrets
/bin/chmod g+rx $GOFETCHROVER/volumes/secrets/extract-pfx.sh
# Protect files and directory from Others
# /bin/chmod o-rwx "$GOFETCHROVER/volumes/secrets"
# /bin/chmod o-rwx "$GOFETCHROVER/volumes/rover/xml"
# /bin/chmod o-rwx "$GOFETCHROVER/volumes/rover/incomingHL7"
# sudo sh -c "/bin/chmod o-rwx $GOFETCHROVER/volumes/rover/*.json" 
# sudo sh -c "/bin/chmod o-rwx $GOFETCHROVER/volumes/dcare/*.json"
/bin/echo
