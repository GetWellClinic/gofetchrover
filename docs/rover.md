# Rover Configuration Details

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
    "incomingMuleFolder": "/volumes/incoming/lifelabs/"
    "verification_interval": 60,
    ...
```

`incomingMuleFolder` is the folder location used for LifeLabs when configuring Mule. Refer to `LabProperties.properties` for the path used for LifeLabs. This folder will have the same name as the key file name in 'volumes/keys/*' and is generated during `./mule setup` installation.
        For example, if the key file name is `LifelabsRover.key` when mule was installed, the folder path will be `/volumes/incoming/LifelabsRover/`.

`client_cert_path`, `root_cert_path`, and `client_key_path` specify the locations of the certificates.
        If you get an "SSL Error: self-signed certificate found in chain", you can try to substitute with:
        ```
        "root_cert_path": false,
        ```
        "app_name" and "app_version" must remain default values to work with Rover Excelleris, as these completed conformance testing with Lifelabs.

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
The code is set up to run every 8 hrs by default.
To change the frequency to download every 5 min, edit the Docker/rover/Dockerfile file and update the following line:
``` bash
RUN echo "* */8 * * * ...
```
Replace with `*/5 * * * *` for every 5 min downloads, or any other desired cron expression.

### Log file
Logs are available at: `volumes/rover/gfr.log`
