#!/bin/bash
# This script helps you install gofetchrover as system services running automatically on Linux boot.
# This script should reside and be run in the gofetchrover directory 'bin' in order to properly autodetect base directory for GoFetchRover.
# Run the script as 'sudo ./install-services.sh'

# Version 2025.06.21

CURRENT=$(pwd)
# Automatic detect base directory for GoFetchRover:
cd ..
GOFETCHROVER=$(pwd)
# Override to specify base directory for GoFetchRover:
# GOFETCHROVER=/opt/gofetchrover

/bin/echo "Installing GoFetchRover docker containers as services autostart on system reboot..."
/bin/echo ""

# Confirm base directory:
/bin/echo "Please confirm the correct base directory for GoFetchRover as shown below..."
/bin/echo $GOFETCHROVER
/bin/echo ""
/bin/echo "...if this is incorrect, please press Ctrl-C to cancel installation...!"
read -p "	(Press any key to continue)"

# Edit the GoFetchRover services to match installed GoFetchRover base directory:
/bin/cp $GOFETCHROVER/bin/services/gofetchrover.service.default $GOFETCHROVER/bin/services/gofetchrover.service
/bin/sed -i 's#/opt/gofetchrover#'"$GOFETCHROVER"'#g' $GOFETCHROVER/bin/services/gofetchrover.service

# Install GoFetchRover as system service in Linux:
/bin/cp $GOFETCHROVER/bin/services/gofetchrover.service /etc/systemd/system/
# Reload any changes to system service folder /etc/systemd/system
/usr/bin/systemctl daemon-reload

# Enable system GoFetchRover Muled services:
/usr/bin/systemctl enable gofetchrover.service
# Start system services:
/usr/sbin/service gofetchrover start

/bin/echo "gofetchrover.service has been installed as system services in /etc/systemd/system/"
/bin/echo "GoFetchRover will start automatically on system reboot !"
/bin/echo ""
# To stop services temporarily: 'sudo system gofetchrover stop'

/bin/echo "	Tips:"
/bin/echo "		to stop GoFetchRover 'sudo system gofetchrover stop'"
/bin/echo "		to start GoFetchRover 'sudo system gofetchrover start'"
/bin/echo "		to disable GoFetchRover from restarting on reboot 'sudo systemctl disable gofetchrover.service'"
/bin/echo "		to re-enable GoFetchRover to restart automatically on reboot 'sudo systemctl enable gofetchrover.service'"
/bin/echo ""

# To disable system services, and prevent from restarting on reboot: 'sudo systemctl disable gofetchrover.service'

# Return to original directory
cd $CURRENT