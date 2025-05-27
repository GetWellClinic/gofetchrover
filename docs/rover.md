# Mule Configuration Details

This script automates the installation process for Rover. It accepts a single argument that specifies the action to perform.

## Usage

```bash
./rover [rover]
```

## Setup Instructions

**Prerequisite:**

Mule should be installed. [Mule Setup Guide](mule.md)

**Important:**  
Before running the setup command, ensure that the following contents in `volumes/rover/rover_config.json` are updated.

Update the following JSON configuration with your specific values:

```json

    "base_url": "https://api.ontest.excelleris.com/",
    "user_id": "your_userid",
    "password": "your_password",
    "client_cert_path": "/volumes/rover/your_client_certificate.pem",
    "root_cert_path": "/volumes/rover/your_root_certificate.pem",
    "client_key_path": "/volumes/rover/your_client_key.pem",
    "incomingMuleFolder": "/volumes/incoming/lifelabs-keyPair/"
    
```

`incomingMuleFolder` is the folder location used for LifeLabs when configuring Mule. Refer to `LabProperties.properties` for the path used for LifeLabs. This folder will have the same name as the key file and is generated during Mule installation.

"client_cert_path", "root_cert_path", and "client_key_path" specify the locations of the certificates.

For example, if the key file name is `lifelabs-keyPair.key`, the folder path will be `/volumes/incoming/lifelabs-keyPair/`.

### Running Setup

```bash
./rover rover
```
### Updating Config File
If required, update the rover-config.json file. There is no need to rebuild; just restart the container.

Example:
```bash
docker restart gofetchrover-rover-1
```
### Cron
The code is set up to run every five minutes. To change the frequency, edit the Docker/rover/Dockerfile file and update the following line:
``` bash
RUN echo "*/5 * * * * ...
```
Replace `*/5 * * * *` with the desired cron expression.

### Log file
Logs are available at: `volumes/rover/gfr.log`
