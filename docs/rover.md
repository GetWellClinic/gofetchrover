# Rover Configuration Details
# Version 2025.06.21

This script automates the installation process for Rover. It accepts a single argument that specifies the action to perform.

## Usage

```bash
./gofetch [rover]
```

## Setup Instructions

**Prerequisite:**

You have already installed GoFetchRover. [GoFetchRover Setup Guide](Readme.md)

Mule should be installed. [Mule Setup Guide](mule.md)

You have received a Lifelabs PFX encrypted file with certificates.

### Extract certificates from Lifelabs PFX file

Copy your PFX file that Lifelabs provides you to `volumes/secrets/`.

Extract the contents of the PFX file (ie. 'clinic-lifelabs.pfx') with the password supplied by Lifelabs.

    ```
    cd /opt/gofetchrover/secrets
    ./extract-pfx.sh clinic-lifelabs.pfx
    (Enter the Lifelabs provided password)
    (Answer Yes to 'Do you want to move the certificates to the default location')
    ls -l -h
    ```

### Edit Rover configuration file

**Important:**  
Before running the setup command, ensure that the following contents in `volumes/rover/rover_config.json` are updated.

Update the following JSON configuration with your specific values:

```json

    "base_url": "https://api.ontest.excelleris.com/",
    "user_id": "your_userid",
    "password": "your_password",
    "client_cert_path": "/volumes/secrets/rover_client_certificate.pem",
    "root_cert_path": "/volumes/secrets/rover_root_certificate.pem",
    "client_key_path": "/volumes/secrets/rover_client_key.pem",
    "incomingMuleFolder": "/volumes/incoming/lifelabs/"
    "verification_interval": 60,
```

   **base_url**:

   Change this to the production or test instance URL.

   **client_cert_path**, and **client_key_path** specify the locations of Lifelab's provided certificates.
   
   **root_cert_path**:

   For test instance, use the Lifelabs provided root certificate from the PFX, ie. `rover_root_certificate.pem`.

   For production instance that uses a commercially signed SSL certificate, substitute the path with `/etc/ssl/certs/ca-certificates.crt`.

   For self signed certificates, substitute this line with
       ```
       "root_cert_path": false,
       ```
   You can issue this command to check the status of the server's SSL certificates:

       ```
       openssl s_client -showcerts -connect api.ontest.excelleris.com:443
       ```

  **incomingMuleFolder**:

  This is the folder location used for LifeLabs when configuring Mule. Refer to `LabProperties.properties` for the path used for LifeLabs. This folder will have the same name as the key file name in 'volumes/keys/*' and is generated during `./mule setup` installation.
  
  For example, if the key file name is `LifelabsRover.key` when mule was installed, the folder path will be `/volumes/incoming/LifelabsRover/`.

  "app_name" and "app_version" must remain default values to work with Rover Excelleris, as these completed conformance testing with Lifelabs.

### Running Setup

```bash
./gofetch rover
```
### Updating Config File
If required, update the rover-config.json file. There is no need to rebuild; just restart the container.

Example:
```bash
docker restart gofetchrover-rover-1
```
### Cron
The code is set up to run and download labs every 8 hrs by default.
To change the frequency to download every 5 min, edit the Docker/rover/Dockerfile file and update the following line:
``` bash
RUN echo "1 */8 * * * ...
```
Replace with `*/5 * * * *` for every 5 min downloads, or any other desired cron expression.

### Log file
Logs are available at: `volumes/rover/gfr.log`
