#!/bin/bash

./bin/mule-connector-config.sh

# Directory to check
folder_path="volumes/keys"

# Incoming folder path
incoming_folder_path="volumes/incoming"

# Path to the properties file
properties_file="volumes/LabProperties.properties"

# Initialize or clear the properties file
> "$properties_file"

counter=1

# Loop through all .key files in the folder
find "$folder_path" -type f -name "*.key" | while read file; do
  # Extract the file name without extension
  file_name=$(basename "$file" .key)
  
  # Create incoming directory with the file name
  mkdir -p "$incoming_folder_path/$file_name"
  
  # Append to the properties file with the relevant paths
  echo "incomingHL7dir$counter=/$incoming_folder_path/$file_name" >> "$properties_file"
  echo "keyLocation$counter=/$file" >> "$properties_file"
  echo "" >> "$properties_file"  
  ((counter++))
done

# Create errorHL7dir and completedHL7dir directories
mkdir -p "volumes/errorHL7dir"
mkdir -p "volumes/completedHL7dir"

# Append the other configurations at the end of the properties file
echo "errorHL7dir=/volumes/errorHL7dir" >> "$properties_file"
echo "completedHL7dir=/volumes/completedHL7dir" >> "$properties_file"
echo "" >> "$properties_file"  
echo "oscarURL=https://yourdomain/oscar/lab/newLabUpload.do" >> "$properties_file"
echo "" >> "$properties_file"  
echo "# smtpServer for notifying errors" >> "$properties_file"
echo "smtpServer=localhost:25" >> "$properties_file"
echo "senderEmailAddress=labupload@yourdomain.com" >> "$properties_file"
echo "recipientEmailAddress=username@email.com" >> "$properties_file"

echo "Properties file generated at $properties_file"
