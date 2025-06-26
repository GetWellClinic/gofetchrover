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

echo "------------------------"
echo "PFX Extraction Script"
echo "------------------------"

# Set default directory
DEFAULT_PFX_DIR="$GOFETCHROVER/volumes/secrets"

# Prompt for just the filename
read -p "Enter the name of your .pfx file (e.g. yourfile.pfx, path not required $GOFETCHROVER/volumes/secrets will be used): " PFX_NAME
echo ""

# Append to full path
PFX_FILE="$DEFAULT_PFX_DIR/$PFX_NAME"

# Check if file exists
if [ ! -f "$PFX_FILE" ]; then
  echo "File not found: $PFX_FILE"
  exit 1
fi

# Prompt once for password (no echo)
read -s -p "Enter PFX file password: " PFX_PASSWORD
echo ""

# Extract the private key (unencrypted with -nodes)
echo "Extracting private key to client_key.pem..."
openssl pkcs12 -in "$PFX_FILE" -nocerts -nodes -passin pass:"$PFX_PASSWORD" -out $GOFETCHROVER/volumes/secrets/client_key.pem

# Extract the client certificate
echo "Extracting client certificate to client_certificate.pem..."
openssl pkcs12 -in "$PFX_FILE" -clcerts -nokeys -passin pass:"$PFX_PASSWORD" -out $GOFETCHROVER/volumes/secrets/client_certificate.pem

# Extract the root/CA certificate(s)
echo "Extracting CA certificate(s) to root_certificate.pem..."
openssl pkcs12 -in "$PFX_FILE" -cacerts -nokeys -passin pass:"$PFX_PASSWORD" -out $GOFETCHROVER/volumes/secrets/root_certificate.pem

echo ""
echo "Extraction complete. Files saved in:"
echo " - $GOFETCHROVER/volumes/secrets/client_key.pem"
echo " - $GOFETCHROVER/volumes/secrets/client_certificate.pem"
echo " - $GOFETCHROVER/volumes/secrets/root_certificate.pem"
