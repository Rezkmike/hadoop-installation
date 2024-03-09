# Hadoop Install Script

## Description
This repository contains a bash script for automating the installation and basic configuration of Apache Hadoop on a Linux environment. Hadoop is a framework that allows for the distributed processing of large data sets across clusters of computers using simple programming models.

## Prerequisites
- A Linux-based system (Ubuntu, CentOS, etc.)
- Root or sudo privileges
- Internet connection for downloading Hadoop packages
- Java Development Kit (JDK) - The script checks and installs it if not present

## Hadoop Installation

### Getting Started
To begin with the installation, first clone the repository:

```sh
git clone https://github.com/Rezkmike/hadoop-installation.git
cd hadoop-installation
```


### Running the Script
Make the script executable and run it:

```sh
chmod +x run-build.sh
./run-build.sh
```


### Configuration
The script will perform the following tasks:
- Check for and install JDK if not present
- Download the specified version of Hadoop
- Unpack and set up Hadoop in the specified directory
- Configure basic settings for Hadoop operations

### Post-Installation
After the installation, you may need to configure Hadoop according to your specific requirements. The script sets up a basic configuration which can be modified by editing the `hadoop-config.xml` file located in the `conf` directory of your Hadoop installation.

## Troubleshooting
- Ensure you have sufficient privileges to execute scripts and install software.
- Check if your system has Java installed before running the script. The script can install Java, but it's recommended to have it pre-installed and configured.
- If you encounter permission issues, make sure the script is run with sudo or as a root user.

## Contributing
Contributions to this script are welcome. Please fork the repository, make your changes, and submit a pull request.

## License
[Apache License 2.0](LICENSE)
