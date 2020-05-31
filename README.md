
# Atomic Attack Lab
The Atomic Attack Lab provides an automated MITRE ATT&CK® and Atomic Red Team simulation experience. The ultimate goal is to provide an automated, repeatable, and consistent testing environment that can be used to simulate real ATT&CK techniques. With this base environment you can deploy additional tools and test detection and response capabilities by simply installing any tools on top of the base infrastructure.

The Atomic Attack Lab provides an automated build process for configuring several cloud-based resources in a secure and isolated environment. The environment is built using Terraform in AWS and is configured using Ansible. This makes the process very simple and extensible. 

Another core feature is the ability to isolate the environment from any existing cloud environments and the internet. Atomic Attack Lab uses OpenVPN to access resources in private subnets, protecting them from the internet and other networks whilst also allowing you to access your environment from anywhere. 



## Requirements
* Terraform `>= 0.12`
* AWS account 
* Python3 & virtualenv
* OpenVPN client or OVPN-compatiable client (e.g. Tunnelblick for MacOS, apt package for linux)
  * Connectivity tested on MacOS Catalina 10.15.4 and Kali 2020.2

## Installation
Clone the repository to your local machine.
```  
git clone ...
```

Create a directory to hold the Python virtualenv in the project directory & create the virtualenv.

```
mkdir venv
python3 -m venv ./venv
```

Enter the virtualenv.

```
source ./venv/bin/activate
```

Install python requirements.

```
pip3 install -r requirements.txt
```

## Usage
The Atomic Attack Lab uses a simple python app to coordinate Terraform and Ansible, allowing you to get up and running with a few simple commands.

There are 5 core commands in the Atomic Attack Lab:

```
init      - Initialises Atomic Attack Lab and ensures requirements are met.
build     - Builds Atomic Attack Lab.
recreate  - Destroy and rebuild a specific part of the Atomic Attack Lab infrastructure.
configure - Configures a specific part of the Atomic Attack Lab infrastructure, useful after a recreate command.
destroy   - Destroys all Atomic Attack Lab infrastructure.
```
### Initialise
The `init` command provides a guided setup process to initialise Atomic Attack Lab dependencies. This will complete an automated setup of:
- AWS dependencies (aws CLI, IAM roles, S3-terraform backend, DynamoDB-terraform state locking)
- Terraform 
- Certificates

```
python3 atomic_attack_lab.py init 
```

### Build
The `build` command uses Terraform and Ansible to build and configure Atomic Attack Lab infrastructure. The process first builds all AWS resources using terraform. After this, Ansible takes over to first configure the OpenVPN server, followed by Caldera and the Windows Domain. 

During the build process you will be prompted to connect your build machine to the Atomic Attack Lab network using the provided OpenVPN configuration. This is required to configure the remaining resources in the private subnets.

```
python3 atomic_attack_lab.py build
```

### Recreate
The `recreate` command provides a way to destroy and rebuild a specific module of Atomic Attack Lab infrastructure. During use of Atomic Attack Lab you may cause undesirable effects on victim machines and have to revert back a good state. Instead of destroying all infrastructure and rebuilding, Atomic Attack Lab has the ability to rebuild a specific module of the infrastructure. Currently, the modules supported in the `recreate` command are Windows, Caldera, & OVPN.

```
python3 atomic_attack_lab.py recreate -m windows|caldera|ovpn
```

### Configure
The `configure` command provides a way to configure infrastructure that has been recreated. It can also be used to re-configure infrastructure that may have been changed. Currently, the modules supported in the `configure` command are Windows, Caldera, & OVPN.

```
python3 atomic_attack_lab.py configure -m windows|caldera|ovpn
```

### Destroy
The `destroy` command will destory all Atomic Attack Lab infrastructure

```
python3 atomic_attack_lab.py destroy
```

***
## TODO
```
- Add capability for modules to be specified for post-setup installation of custom tools (e.g. Splunk/Elastic agents, Sysmon).
- Shutdown/Startup scripts for reducing costs on AWS from unused resources
- Automate initialisation process (ssh/rsa certificate generation, AWS resources, etc.)
```