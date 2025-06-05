# Dynacare Configuration Details

This script automates the installation process for Dynacare. It accepts a single argument that specifies the action to perform.

## Usage

```bash
./rover [dcare]
```

## Setup Instructions

**Prerequisite:**

Mule should be installed. [Mule Setup Guide](mule.md)

**Important:**  
Before running the setup command, ensure that the following contents in `volumes/dcare/dynacare_config.json` are updated.

Update the following JSON configuration with your specific values:

```json

    "authURL": "https://batches.gd-results.com/LogonService.svc?WSDL",
    "batchURL": "https://batches.gd-results.com/Batches.svc?WSDL",
    "user": "your_username",
    "pw": "your_password",
    "save_dir": "/volumes/incoming/dcare"
    
```
save_dir: location to save the downloaded files.

For example, if the key file name for dynacare is `dcare.key` when mule was installed, the save_dir path will be `/volumes/incoming/dcare/`.

### Running Setup

```bash
./rover dcare
```
### Updating Config File
If required, update the dynacare-config.json file. There is no need to rebuild; just restart the container.

Example:
```bash
docker restart gofetchrover-dcare-1
```
### Cron
The code is set up to run every five minutes. To change the frequency, edit the Docker/dcare/Dockerfile file and update the following line:
``` bash
RUN echo "*/5 * * * * ...
```
Replace `*/5 * * * *` with the desired cron expression.

### Log file
Logs are available at: `volumes/dcare/dcare.log`
