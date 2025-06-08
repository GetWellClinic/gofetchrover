# Mule Automation Script
*Version 2025.06.06*

This script automates the setup, build, and running Mule. It accepts a single argument that specifies the action to perform.

## Usage

```bash
./mule [setup|build|run]
```

## Setup Instructions

**Prerequisite:**
For OSCAR to accept uploads from Mule, key pairs must be configured to authenticate the transfer. Ensure you have generated the necessary OSCAR keypair files before proceeding. Use the example template on how the .key files should be formatted.
Note: The default keypair file that is saved from OSCAR is often malformed. Open the file in an editor like nano or Notepad++ (Windows) and make sure the key is on a single line and not split up on separate lines. Check the end of each lines and be sure to use Linux EOL line feeds (LF). If you show all symbols in a Windows editor like Notepad++ you can see the hidden symbols (LF), be sure to delete any CR symbols. You can also try to convert the EOL (end of line) to Unix style.

**Important:**  
Before running the setup command, ensure that all your OSCAR keypair *.key files (without any spaces in their names) are placed in the `volumes/keys` directory. Create the `keys` folder if it does not exist. Label the keypair filenames simply with name of lab (ie. LifeLabs or Dynacare or AlphaLabs), because the Mule folder names will be created based on the filename (without file extension).

### Mule Setup

```bash
./mule setup
```

This command generates a new `LabProperties.properties` file in the `volumes` directory. The file includes all the OSCAR key pairs found in `volumes/keys`.

### Configuration

After the `LabProperties.properties` file is generated, update the following properties to match your environment:

Replace 'your_emr_domain', with your domain name or ip address, including the port number if applicable.

```properties
# URL for uploading labs
oscarURL=https://your_emr_domain:8443/oscar/lab/newLabUpload.do

# SMTP server configuration for error reporting
smtpServer=server_address:port
senderEmailAddress=labupload@yourdomain.com
recipientEmailAddress=username@email.com
```

Proper configuration of the `smtpServer`, `senderEmailAddress`, and `recipientEmailAddress` ensures accurate and reliable error notifications.


### Building and Running

After the above changes, use `./mule build` to build the app with all the keys and settings.

Once build successfully use `./mule run` to start mule.

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

/opt/gofetchrover/Docker/mule/mule-1.3.3/logs/mule.log

`docker logs gofetchrover-muled-1`