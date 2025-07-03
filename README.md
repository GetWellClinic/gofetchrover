# GoFetchRover
*Copyright © 2024 by Spring Health Corporation, Toronto, Ontario, Canada*<br />
*LICENSE: GNU Affero General Public License Version 3*<br />
**Document Version 2025.06.05**

GoFetchRover is a HL7/XML lab downloader for OSCAR that works with:
- LifeLabs Excelleris/Rover (XML/HL7)
- Gamma Dynacare Lab(SOAP)
- Alpha Labs (SFTP)
- Med-Health Laboratories (SFTP)

*Requirements*
- Docker
- Docker Compose
- Git
- OSCAR Key Pairs for each lab connection
- Login credentials for each lab
- Lifelabs PFX certificates and keys

## Introduction ##

## Brief Installation Summary ##

Note: You may create a new user and log in as that user if you prefer. The user who runs the following commands will be added to the docker group in step 2. We recommend using dedicated user (such as "rover" ) to run GoFetchRover

Example to create a user 'rover' and add the rover user to a group 'rover'
```
sudo /usr/sbin/useradd -m -s /bin/bash rover
sudo passwd rover         
sudo groupadd rover 
sudo /usr/sbin/usermod -a -G rover $USER
```
To add the user rover to the sudo group (so they can run commands with elevated privileges), run:
```
sudo usermod -aG sudo rover
```
To remove the user rover from the sudo group after installing:
```
sudo deluser rover sudo
```

1. Download the repository on GitHub, use your owner_name and group_name

    ```
    cd /opt
    sudo git clone https://github.com/GetWellClinic/gofetchrover.git
    sudo chown -R owner_name:group_name gofetchrover/
    cd /opt/gofetchrover
    git branch --show-current
    git checkout [dev|main]
    ```

2. Install pre-requisites (Docker and Docker Compose), and initialize GoFetchRover

    ```
    cd /opt/gofetchrover/bin
    sudo ./install-docker.sh
    ```
    Reboot the system and then,
    
    Lifelabs will provide you with login details, and an encrypted certificate package in PFX format.

    Upload the Lifelabs PFX file securely to /opt/gofetchrover/volumes/secrets/ with your favourite SSH/SCP terminal.

    To extract and install the certificates and private key from Lifelabs:
    ```
    cd /opt/gofetchrover/bin
    ./setup.sh
    (Enter password for PFX file)
    ```

3. Read the documents for GoFetchRover

[Readme.md](docs/Readme.md) Installation Instructions

