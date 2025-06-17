# SFTP Configuration Details

This script automates the installation process for SFTP downloader. It accepts a single argument that specifies the action to perform.

## Usage

```bash
./gofetch [sftp] [medhealth | alphalab]
```

## Setup Instructions

**Prerequisite:**

Mule should be installed. [Mule Setup Guide](mule.md)

**Important:**  

For medhealth:

Before running the setup command, ensure that the following contents in `volumes/medhealth/medhealth_config.json` are updated.

For alphalab:

Before running the setup command, ensure that the following contents in `volumes/alphalab/alphalab_config.json` are updated.

Update the following JSON configuration with your specific values:

For alphalab

```json

{
    "hostname": "Host Address",
    "port": 22,
    "username": "username",
    "password": "password",
    "remote_dir": "/",
    "local_dir": "/volumes/alphalab/files",
    "mule_upload_dir": "/volumes/incoming/alphalab",
    "last_downloaded_file": "2025-05-27 00:00:00",
    "delete_files" : false,
    "delete_files_older_than" : 1000
}
    
```

For medhealth

```json

{
    "hostname": "Host Address",
    "port": 22,
    "username": "username",
    "password": "password",
    "remote_dir": "/",
    "local_dir": "/volumes/medhealth/files",
    "mule_upload_dir": "/volumes/incoming/medhealth",
    "last_downloaded_file": "2025-05-27 00:00:00",
    "delete_files" : false,
    "delete_files_older_than" : 1000
}
    
```
remote_dir: Server location of the files to be downloaded.

local_dir: Location to save the downloaded files locally.

mule_upload_dir: Location for Mule uploads.

last_downloaded_file: The modification time (mtime) of the last downloaded file.

For example, if last_downloaded_file is "2025-05-27 00:00:00", only files with an mtime after this timestamp will be downloaded.

delete_files: Deletes files from the server if set to true.

delete_files_older_than: When set to 20, deletes files older than 20 days. Files less than 15 days old will not be deleted as a precaution.

For example, if the key file name for alphalab is `alphalab.key` when mule was installed, the mule_upload_dir path will be `/volumes/incoming/alphalab/`.

### Running Setup
For alphalab
```bash
./gofetch sftp alphalab
```
For medhealth
```bash
./gofetch sftp medhealth
```
### Updating Config File
If required, update the alphalab-config.json file. There is no need to rebuild; just restart the container.

Example:
```bash
docker restart gofetchrover-alphalab-1
```
### Cron
The code is set up to run and download labs every 8 hrs, by default.
To change the frequency to every 5 min, edit the Docker/sftp/Dockerfile file and update the following line:
``` bash
RUN echo "1 8,20 * * * ...
```
Replace with `*/5 * * * *` for every 5 min, or with any other desired cron expression.

### Log file
Logs are available at: `volumes/alphalab/alphalab.log`

### To add more labs
To the docker compose file add
```
your_lab_name:
    restart: 'always'
    build:
        context: Docker/sftp
        args:
            SFTP_NAME: your_lab_name
    volumes:
        - ./volumes:/volumes
        - /etc/localtime:/etc/localtime:ro
        - /etc/timezone:/etc/timezone:ro
```
To gofetch.sh file in project root add
```
if [ "$SFTP_NAME" != "medhealth" ] && [ "$SFTP_NAME" != "alphalab" ] && [ "$SFTP_NAME" != "your_lab_name" ]; then
    echo "Error: Invalid service name. Please provide either 'medhealth', 'alphalab' or 'your_lab_name'."
    exit 1
fi
```
Then add the config file to the location volumes/your_lab_name/your_lab_name_config.json

and then use

```bash
./gofetch sftp your_lab_name
```
this should start a new docker container with your new sftp settings.

Use these steps to add as many SFTP labs as you need.