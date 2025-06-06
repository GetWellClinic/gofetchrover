#!/bin/bash
# Version 2025.05.06

# Output file to save the generated Mule configuration
output_file="mule-config.xml"

# Clear the content of the output file if it already exists
> "$output_file"

# Directory containing the .key files
folder_path="volumes/keys"

# Initialize counter
counter=1

# Write the XML declaration and doctype to the output file
cat <<EOF > "$output_file"
<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE mule-configuration PUBLIC "-//MuleSource //DTD mule-configuration XML V1.0//EN"
"http://mule.mulesource.org/dtds/mule-configuration.dtd">

<mule-configuration id="Mule_Test" version="1.0">
    
    <environment-properties>
        <file-properties location="LabProperties.properties" override="false"/>
    </environment-properties>
    
    <connector name="myFileConnector" className="org.mule.providers.file.FileConnector">
        <properties>
            <property name="outputPattern" value="\${DATE}_\${ORIGINALNAME}"/>
            <property name="pollingFrequency" value="1000"/>
        </properties>
    </connector>
    
    <transformers>
        <transformer name="FileToByteArray" className="org.mule.custom.providers.file.transformers.FileToByteArray"/>
    </transformers>
    
    <interceptor-stack name="default">
        <interceptor className="org.mule.interceptors.LoggingInterceptor"/>
        <interceptor className="org.mule.interceptors.TimerInterceptor"/>
    </interceptor-stack>
    
    <model name="oscarUploader">
        <mule-descriptor name="UploaderUMO" implementation="org.mule.custom.Uploader">
            <inbound-router>
EOF

# Loop over the .key files in the folder
find "$folder_path" -type f -name "*.key" | while read file; do
    # Extract the file name without extension
    file_name=$(basename "$file" .key)
    
    # Define the incoming directory and key location based on the counter
    incoming_dir="incomingHL7dir$counter"
    key_location="keyLocation$counter"
    
    # Add the endpoint block to the XML content
    cat <<EOF >> "$output_file"
                <endpoint address="file:///\${$incoming_dir}?connector=myFileConnector" transformers="FileToByteArray">
                    <filter pattern="*.hl7,*.xml,*.HL7,*.XML" className="org.mule.custom.providers.file.filters.BusyFilter"/>
                    <properties>
                        <property name="keyLocation" value="\${$key_location}" />
                        <property name="oscarURL" value="\${oscarURL}"/>
                        <property name="smtpServer" value="\${smtpServer}" />
                        <property name="senderEmailAddress" value="\${senderEmailAddress}" />
                        <property name="recipientEmailAddress" value="\${recipientEmailAddress}" />
                    </properties>
                </endpoint>
EOF
    
    # Increment the counter for the next file
    ((counter++))
done

# Close the inbound-router, outbound-router, and other components
cat <<EOF >> "$output_file"
            </inbound-router>
            
            <outbound-router>
                <router className="org.mule.routing.outbound.OutboundPassThroughRouter">
                    <endpoint address="file:///\${completedHL7dir}" />
                </router>
            </outbound-router>

            <interceptor name="default"/>
            
            <exception-strategy className="org.mule.custom.CustomExceptionStrategy">
                <endpoint address="file:///\${errorHL7dir}"/>
            </exception-strategy>
        </mule-descriptor>
    </model>
</mule-configuration>
EOF

echo "Mule configuration has been saved to $output_file"

# Variables
REPO_URL="git@github.com/GetWellClinic/hl7_file_management.git"
CLONE_DIR="./Docker/mule"

# Clone the repo into ./Docker/mule
if [ -d "$CLONE_DIR/.git" ]; then
    echo "Repo already cloned in $CLONE_DIR. Pulling latest changes..."
    git -C "$CLONE_DIR" pull
else
    echo "Cloning repo into $CLONE_DIR..."
    git clone "$REPO_URL" "$CLONE_DIR"
fi

# Directory to move the file to after generation
destination_directory="./Docker/mule/src/main/resources"

# Move the generated file to the desired location
mv "$output_file" "$destination_directory"