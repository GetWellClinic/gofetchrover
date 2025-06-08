# Dynacare Configuration Details

This script automates the installation process for Dynacare. It accepts a single argument that specifies the action to perform.

## Usage

```bash
./gofetch [dcare]
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
    "save_dir": "/volumes/incoming/Dynacare"
    
```
save_dir: location to save the downloaded files.

For example, if the key file name for dynacare is `Dynacare.key` when mule was installed, the save_dir path will be `/volumes/incoming/Dynacare/`.

### Running Setup

```bash
./gofetch dcare
```
### Updating Config File
If required, update the dynacare-config.json file. There is no need to rebuild; just restart the container.

Example:
```bash
docker restart gofetchrover-dcare-1
```
### Cron
The code is set up to run and download labs every 8 hrs, by default.
To change the frequency to every 5 min, edit the Docker/dcare/Dockerfile file and update the following line:
``` bash
RUN echo "1 */8 * * * ...
```
Replace with `*/5 * * * *` for every 5 min, or with any other desired cron expression.

### Log file
Logs are available at: `volumes/dcare/dcare.log`
