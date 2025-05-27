# Mule Automation Script

This script automates the setup, build, and installation process for Mule. It accepts a single argument that specifies the action to perform.

## Usage

```bash
./mule [setup|build|install]
```

## Setup Instructions

**Prerequisite:**
For OSCAR to accept uploads from Mule, key pairs must be configured to authenticate the transfer. Ensure you have the necessary OSCAR key before proceeding.

**Important:**  
Before running the setup command, ensure that all your .key files (without any spaces in their names) are placed in the `volumes/keys` directory. Create the `keys` folder if it does not exist.

### Running Setup

```bash
./mule setup
```

This command generates a `LabProperties.properties` file in the `volumes` directory. The file includes all the keys found in `volumes/keys`.

### Configuration

After the `LabProperties.properties` file is generated, update the following properties to match your environment:

Replace your_domain, with your domain name or ip address.

```properties
# URL for uploading labs
oscarURL=https://your_domain/oscar/lab/newLabUpload.do

# SMTP server configuration for error reporting
smtpServer=server_address:port
senderEmailAddress=labupload@yourdomain.com
recipientEmailAddress=username@email.com
```

Proper configuration of the `smtpServer`, `senderEmailAddress`, and `recipientEmailAddress` ensures accurate and reliable error notifications.


### Building and Installing

After the above changes, use `./mule build` to build the app with all the keys and settings.

Once build successfully use `./mule install` to install and start mule.

Use `docker ps -a` to view the docker app running.

Use docker commands to stop or remove container with container name.

Eg:

To stop container

`docker stop gofetchrover-muled-1`

To remove container

`docker rm gofetchrover-muled-1`


### Adding new keys

To add new keys, just keep new keys along with the old ones in the folder `volumes/keys`
and repeat steps from `setup`

### Folders
The files uploaded to Oscar will be stored under `/volumes/completedHL7dir`, and failed files will be under `/volumes/errorHL7dir`.


### Mule Logs
`docker logs gofetchrover-muled-1`