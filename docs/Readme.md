# GoFetchRover
*Copyright © 2024 by Spring Health Corporation, Toronto, Ontario, Canada*<br />
*LICENSE: GNU Affero General Public License Version 3*<br />
**Document Version 2025.06.21**

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

## Installation ##
Note: You may create a new user and log in as that user if you prefer. The user who runs the following commands will be added to the docker group in step 2.

1. Download the repository on GitHub

	```
	sudo chown g+rx /opt
	cd /opt
	sudo git pull https://github.com/GetWellClinic/gofetchrover.git
	cd /opt/gofetchrover
	sudo git branch --show-current
	sudo git checkout [dev|main]
	```

2. Install pre-requisites (Docker and Docker Compose), and initialize GoFetchRover

	```
	cd /opt/gofetchrover/bin
	sudo ./install-docker.sh
	```
	Reboot system and then,
	Lifelabs will provide you with login details, and an encrypted certificate package in PFX format.

	Upload the Lifelabs PFX file securely to /opt/gofetchrover/volumes/secrets/ with your favourite SSH/SCP terminal.

	Extract and install the certificates and private key from Lifelabs:
	```
	cd /opt/gofetchrover/bin
	./setup.sh
	(Enter password for PFX file)
	```

3. Upload the OSCAR lab connector Key Pairs

	Go in to your OSCAR and under Administration -> System Management -> Key Pair Generator

	A) If no keypairs exist, create new keypairs for each lab: (Create New Key)
				
	Service Name:	Lab Type connector:
			
	LifelabsHL7		(ExcellerisON)			for Ontario

	LifelabsRover	(EXCELLERIS)			for BC

	Alphalabs		(ALPHA)

	Dynacare		(GDML)

	MedhealthLabs	(EPSILON/MHL)

	Save each *.key file in a secure place.

	Edit the keypair file with nano or Notepad++ and ensure that it is formatted correctly.

		- End of each line is Unix style EOL with (LF) hidden symbol
		- Each key is on a single line, does not span separate lines. You may need to edit the keys so they are on a single line each.
		- Use the sample keypair template to see how the keypairs should be formatted.

	B) If there are Current Public Keys that exist: (Create keypair files)

		1. Copy the OSCAR Public Key.
		2. Copy each Private Service Key.
		3. Note the Service name for each Private Service Key.
		4. Create separate keypair files based on the sample template with the Service Name, the common OSCAR Public Key, and the unique Private Service Key.

	C) Upload the keypairs to GoFetchRover

		1. Name each keypair file with a descriptive name (ie. use the Service Name as the filename) and no spaces.
		2. Upload the *.key files to /opt/gofetchrover/volumes/keys/ with your favourite SSH/SCP terminal.

4. Mule Setup

	You need to repeat this SETUP step everytime you add a new lab connector.

	```
	cd /opt/gofetchrover
    ./mule setup
	```
	Read more in the document [mule.md](mule.md) for detailed instructions.

5. Edit the configuration files for each lab connector

	```
	sudo nano /opt/gofetchrover/volumes/rover/LabProperties.properties
	sudo nano /opt/gofetchrover/volumes/dcare/dynacare_config.json
	```

6. Mule Build

	You will also need to repeat this BUILD step everytime you add a new lab connector.

	```
	cd /opt/gofetchrover
	./mule build
	```
	Read more in the document [mule.md](mule.md) for detailed instructions.

7. Run Mule on first installation

	```
	cd /opt/gofetchrover
	./mule run
	docker ps -a
	```

8. Install the lab downloaders:
						
	**Lifelabs/Rover**: Read [rover.md](rover.md)

	**Dynacare**: Read [dynacare.md](dynacare.md)

	**Alphalabs**: Read [sftp.md](sftp.md)

	**Med-Health** Labs: Read [sftp.md(sftp.md)]

9. Install GoFetchRover as a system service

The system is already configured to restart containers that were running during a system reboot.

## Maintenance ##
	
1. Starting and stopping GoFetchRover containers

Starting docker containers individually:
```
docker ps -a
docker start [ gofetchrover-muled-1 | gofetchrover-rover-1 | gofetchrover-dcare-1 | gofetchrover-alphalab-1 | gofetchrover-medhealth-1 ]
```

Stopping docker containers individually:
```
docker ps -a
docker stop [ gofetchrover-muled-1 | gofetchrover-rover-1 | gofetchrover-dcare-1 | gofetchrover-alphalab-1 | gofetchrover-medhealth-1 ]
```

2. Modifying JSON configuration files:

Everytime you modify any of the lab JSON configuration files, remember to rebuild the docker container
```
cd /opt/gofetchrover
./gofetch [ rover | dcare ]
./gofetch sftp [ alphalab | medhealth ]
```

3. Initiate lab download on demand

This will trigger GoFetchRover to execute the labdownload script on demand, once.
```
cd /opt/gofetchrover
./fetchnow [ rover | dcare | alphalab | medhealth ]
```

4. Updating root CA certificates

If you get SSL errors, you may need to update the container's root CA-certificates. Rebuild the docker containers to run the update scripts.
```
cd /opt/gofetchrover
./gofetch [ rover | dcare ]
./gofetch sftp [ alphalab | medhealth ]
```

5. Log files:

	Mule: Docker/mule/mule-1.3.3/logs/mule.log
	
	Rover: volumes/rover/gfr.log
					
	Dynacare: volumes/dcare/dcare.log

	AlphaLabs: volumes/alphalab/alphalab.log

	Med-Health: volumes/medhealth/medhealth.log

	Note: Backup of monthly logs are saved in their respective individual subdirectories ```logs/backup```

	Remember to set your system timezone if you want your logs to show your local timezone:
	```
	sudo timedatectl
	sudo timedatectl set-timezone America/Toronto
	or
	sudo tzselect
	```
	
6. Updating GoFetchRover

	Note: you may need to run these commands with `sudo`.

	Show current Git branch
	```
	cd /opt/gofetchrover
	git branch --show-current
	```				
	(Optional: Stash any local changes you made to the code, that may prevent a `git pull`)
	```
	git stash
	```
	Pull latest code from GitHub repo
	```
	git pull
	```
	
	Edit the JSON configuration files as needed.

	You may need to rebuild docker containers for the latest changes to take effect. Run the `gofetch` scripts again:
	```
	cd /opt/gofetchrover
	./gofetch [ mule | rover | dcare ]
	./gofetch sftp [ alphalab | medhealth ]
	```
