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
sudo chmod ug+rx *.sh
sudo ./install-docker.sh
sudo ./setup.sh
```

3. Read the documents for GoFetchRover

[Readme.md](docs/Readme.md) Installation Instructions

