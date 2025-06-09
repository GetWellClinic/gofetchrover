#!/bin/bash
# Setup script for fixing permissions in GoFetchRover after a git pull update
**Version 2025.06.07**

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

# Create rover group, and add user to group
/bin/echo "Adding users to groups..."
/bin/sleep 1s
# Add current user to rover group
/usr/sbin/usermod -a -G rover $USER
# Add default first administrator username to "rover" group
USERNAME=$(awk -F':' -v uid=1000 '$3 == uid { print $1 }' /etc/passwd)
/usr/sbin/usermod -a -G rover $USERNAME

# Add current user and rover to docker group
/usr/sbin/usermod -a -G docker rover
/usr/sbin/usermod -a -G docker %USER
/usr/sbin/usermod -a -G docker %USERNAME

# Checking groups
/bin/echo "Confirming current user belonging to the following groups (check for 'docker', and 'rover')..."
/usr/bin/groups $USER
/usr/bin/groups $USERNAME
/usr/bin/groups rover
/bin/echo ""

# Initialize Permissions
/bin/echo "Fixing permissions..."
/bin/sleep 1s
/bin/chown rover:rover "$GOFETCHROVER" -R
sudo sh -c "/bin/chmod g+rx $GOFETCHROVER/bin/*"
sudo sh -c "/bin/chmod g+rwx $GOFETCHROVER/volumes/*"
/bin/chmod g+rx $GOFETCHROVER/volumes/secrets/extract-pfx.sh
/bin/chmod ug+rx $GOFETCHROVER/gofetch
/bin/chmod ug+rx $GOFETCHROVER/fetchnow
/bin/chmod ug+rx $GOFETCHROVER/mule
# Protect files and directory from Others
# /bin/chmod o-rwx "$GOFETCHROVER/volumes/secrets"
# /bin/chmod o-rwx "$GOFETCHROVER/volumes/rover/xml"
# /bin/chmod o-rwx "$GOFETCHROVER/volumes/rover/incomingHL7"
# /bin/chmod o-rwx "$GOFETCHROVER/volumes/LabProperties.properties"
# /bin/chmod o-rwx "$GOFETCHROVER/volumes/keys"
# /bin/chmod o-rwx "$GOFETCHROVER/volumes/completedHL7dir"
# /bin/chmod o-rwx "$GOFETCHROVER/volumes/errorHL7dir"
# sudo sh -c "/bin/chmod o-rwx $GOFETCHROVER/volumes/rover/*.json" 
# sudo sh -c "/bin/chmod o-rwx $GOFETCHROVER/volumes/dcare/*.json"
/bin/echo

#/bin/echo "...reloading groups without logging in/out..."
#/bin/newgrp docker rover