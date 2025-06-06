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

## Installation ##

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
sudo ./setup.sh
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


4. Extract the certificates and key from Lifelabs

Lifelabs will provide you with login details, and an encrypted certificate package in PFX format.

Upload the Lifelabs PFX file securely to /opt/gofetchrover/volumes/secrets/ with your favourite SSH/SCP terminal.

Extract and install the certificates and private key from Lifelabs:
```
cd /opt/gofetchrover/volumes/secrets
sudo extract-pfx.sh {lifelabs_client.pfx}
(Enter password for PFX file)
(Choose Yes to 'Do you want to move the files to default location')
```

5. Mule Setup

You need to repeat this SETUP step everytime you add a new lab connector.

```
cd /opt/gofetchrover
sudo ./mule setup
cd bin
sudo ./fix-permissions.sh
```
Read more in the document [mule.md](docs/mule.md) for detailed instructions.

6. Edit the configuration files for each lab connector

```
sudo nano /opt/gofetchrover/volumes/rover/LabProperties.properties
sudo nano /opt/gofetchrover/volumes/dcare/dynacare_config.json
```

7. Mule Build

You will also need to repeat this BUILD step everytime you add a new lab connector.

```
cd /opt/gofetchrover
sudo ./mule build
cd bin
sudo ./fix-permissions.sh
```
Read more in the document [mule.md](docs/mule.md) for detailed instructions.

8. Run Mule on first installation

```
cd /opt/gofetchrover
sudo ./mule run
sudo docker ps -a
```

