#!/bin/bash
# Setup script for GoFetchRover
# Version 2025.06.21

# Note: This script should be run in ../bin directory for autodetect base directory to be correct

echo "------------------------"
echo "PFX Extraction Script"
echo "------------------------"

cd ..
export GOFETCHROVER=$(pwd)

echo ""
echo ""
echo " Directory listing for: $GOFETCHROVER/volumes/secrets/"
ls -la $GOFETCHROVER/volumes/secrets/
echo ""
echo ""

# Set default directory
DEFAULT_PFX_DIR="$GOFETCHROVER/volumes/secrets"

echo "client_key.pem, client_certificate.pem and root_certificate.pem will be saved to $GOFETCHROVER/volumes/secrets"
echo ""

read -p "Do you want to append a timestamp to the file names? (y/n) if no, files will be overwritten if they already exist: " answer
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

filename=""

if [[ "$answer" == "y" || "$answer" == "yes" ]]; then
    timestamp=$(date +"%Y%m%d-%H%M%S")
    filename="_${timestamp}"
fi

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
openssl pkcs12 -in "$PFX_FILE" -nocerts -nodes -passin pass:"$PFX_PASSWORD" -out $GOFETCHROVER/volumes/secrets/client_key$filename.pem

# Extract the client certificate
echo "Extracting client certificate to client_certificate.pem..."
openssl pkcs12 -in "$PFX_FILE" -clcerts -nokeys -passin pass:"$PFX_PASSWORD" -out $GOFETCHROVER/volumes/secrets/client_certificate$filename.pem

# Extract the root/CA certificate(s)
echo "Extracting CA certificate(s) to root_certificate.pem..."
openssl pkcs12 -in "$PFX_FILE" -cacerts -nokeys -passin pass:"$PFX_PASSWORD" -out $GOFETCHROVER/volumes/secrets/root_certificate$filename.pem

echo ""
echo "Extraction complete. Files saved in:"
echo " - $GOFETCHROVER/volumes/secrets/client_key$filename.pem"
echo " - $GOFETCHROVER/volumes/secrets/client_certificate$filename.pem"
echo " - $GOFETCHROVER/volumes/secrets/root_certificate$filename.pem"
echo ""