
# Atomic Attack Lab
The Atomic Attack Lab provides an automated MITRE ATT&CK® and Atomic Red Team simulation experience. The ultimate goal is to provide an automated, repeatable, and consistent testing environment that can be used to simulate real ATT&CK techniques. With this base environment you can deploy additional tools and test detection and response capabilities by simply installing any tools on top of the base infrastructure. 

The Atomic Attack Lab provides an automated build process for configuring several cloud-based resources in a secure and isolated environment. The environment is built using Terraform in AWS and is configured using Ansible. This makes the process very simple and extensible. 

Another core feature is the ability to isolate the environment from any existing cloud environments and the internet. Atomic Attack Lab uses OpenVPN to access resources in private subnets, protecting them from the internet and other networks whilst also allowing you to access your environment from anywhere. 

## Wiki
See the wiki for tips, tricks, in-depth documentation and general info.

## Requirements
* Terraform `>= 0.12` - see [Terraform install guide](https://learn.hashicorp.com/terraform/getting-started/install.html)
* Ansible - see [Ansible install guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
* AWS account & AWS CLI - See AWS section below
* Python3
* OpenVPN client or OVPN-compatiable client (e.g. Tunnelblick for MacOS, apt package for linux)

## Support
Atomic Attack Lab is supported on MacOS, Debian, & Ubuntu.

## Installation
Setup and install all requirements as detailed above. Clone the repository to your local machine.
```  
git clone https://github.com/ethanhillas/Atomic-Attack-Lab.git
```

Create a Python virtual environment (virtualenv) and activate it. 

Note: if you haven't installed virtualenv, install it with `pip3 install virtualenv`.

```
virtualenv venv
source venv/bin/activate
```

Install python requirements.

```
pip3 install -r requirements.txt
```

Create your own certificates for Terraform and Ansible to access and configure your Atomic Attack Lab. The certificates may be located anywhere, but for ease of use, you can create a directory called `certs` in the project folder and write your certs there. You are responsible for appropriately securing your certificates. You must ensure that the keys have the correct permission (e.g chmod 400 or r--).

```
## SSH Keys
ssh-keygen -t rsa -b 4096 -f /path/to/write/keys

## Windows RSA keys
ssh-keygen -t rsa -b 4096 -m PEM -f /path/to/write/keys
```


## Configuration
Atomic Attack Lab comes with a configuration file that should be customised for your deployment. The `atomic_attack_lab_conf.yml` file is provided as a guide and includes all mandatory configuration items.

Several default options are given and can be customised to suit your deployment. The following options should be updated before running the `init` command.

* project_name: A unique name to tag all AWS resources with
* aws_credential_profile: The name of your AWS CLI credential profile (see AWS section)
* trusted_network: Your current IP, this is used to allow SSH connections to OpenVPN server for installation
* *_instance_type: Instance types for AWS EC2 resources
* terraform_s3_backend_bucket_name: S3 bucket name for Terraform backend (see AWS section)
* terraform_dynamodb_backend_table_name: DynamoDB table name for Terraform backend (see AWS section)
* ssh_public_key_file: Path to the ssh public key added to the open vpn server and caldera server
* ssh_private_key_file: Path to the ssh private key for use by ansible to configure ovpn and caldera
* win_rsa_public_key_file: Path to the rsa public key used for encrypting secrets
* win_rsa_private_key_file: Path to the rsa private key used for decrypting secrets


## Usage
The Atomic Attack Lab uses a simple python app to coordinate Terraform and Ansible, allowing you to get up and running with a few simple commands.

There are 5 core commands in the Atomic Attack Lab:

* `init`      - Initialises configuration and ensures requirements are met for running Atomic Attack Lab. Used for first time setup of Atomic Attack Lab.
* `build`     - Builds Atomic Attack Lab.
* `recreate`  - Destroy and rebuild a specific part of the Atomic Attack Lab infrastructure.
* `configure` - Configures a specific part of the Atomic Attack Lab infrastructure, useful after a recreate command.
* `destroy`   - Destroys all Atomic Attack Lab infrastructure.


### Init
The `init` command provides a guided setup process to initialise Atomic Attack Lab dependencies. This will complete an automated initialisation of:
- Python dependencies
- Terraform dependencies
- Ansible dependencies
<!-- - AWS dependencies (aws CLI, IAM roles, S3-terraform backend, DynamoDB-terraform state locking) -->

```
python3 atomic_attack_lab.py -c <conf_file>.yml init 
```
Note: Manual set up of aws cli, IAM roles, S3/DynamoDB backend is required. See AWS section below.

### Build
The `build` command uses Terraform and Ansible to build and configure Atomic Attack Lab infrastructure. The process first builds all AWS resources using terraform. After this, Ansible takes over to configure the OpenVPN server, followed by Caldera and the Windows Domain. 

During the build process you will be prompted to connect your build machine to the Atomic Attack Lab network using the provided OpenVPN configuration. This is required to configure resources in the private subnets.

```
python3 atomic_attack_lab.py -c <conf_file>.yml build
```

### Recreate
The `recreate` command provides a way to destroy and rebuild a specific module of Atomic Attack Lab infrastructure. During use of Atomic Attack Lab you may cause undesirable effects on your resources and have to revert. Instead of destroying all infrastructure and rebuilding, Atomic Attack Lab has the ability to rebuild a specific module of the infrastructure. Currently, the modules supported in the `recreate` command are Windows, Caldera, & OVPN.

```
python3 atomic_attack_lab.py -c <conf_file>.yml recreate -m windows|caldera|ovpn
```

### Configure
The `configure` command provides a way to configure infrastructure that has been recreated. It can also be used to re-configure infrastructure that may have been changed. Currently, the modules supported in the `configure` command are Windows, Caldera, & OVPN.

```
python3 atomic_attack_lab.py -c <conf_file>.yml configure -m windows|caldera|ovpn
```

### Destroy
The `destroy` command will destory all Atomic Attack Lab infrastructure.

```
python3 atomic_attack_lab.py -c <conf_file>.yml destroy
```

## AWS
### AWS CLI
For Terraform to access your AWS account and build the infrastructure, it requires access to an AWS credential profile. The credential profile is part of the AWS CLI, and is described in detail at [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html).

For the purpose of Atomic Attack Lab, you need to have downloaded and configured AWS CLI with the appropriate credential profile. See [Quickly configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html#cli-quick-configuration) for instructions.

In your Atomic Attack Lab configuration file, provide the name for the credential profile that has been set up. This is called "default" if you didn't provide a profile name.

### IAM roles
Following AWS best practice, you should create an IAM user with least privilege for use by Atomic Attack Lab. The IAM user should have AmazonEC2FullAccess & AmazonS3FullAccess permissions. 

### S3/DynamoDB backend
Terraform is configured to use a remote backend in AWS S3. This means you need to have a S3 bucket and DynamoDB table setup to allow Terraform to read/write state from. The S3 bucket holds state information whilst the DynamoDB table assists with file locking.

Create a new S3 bucket, provide a meaningful name and leave default settings. You will need to provide the name of the bucket in the AAL configuration file.

Create a new DynamoDB table with Primary key called 'LockID' as a String type. Once created, go to the capacity page and change the Read/Write capacity mode to 'on-demand' to ensure you are charged only for reads and writes. You will need to provide the name of the table in the AAL configuration file.

## TODO
```
- Add capability for modules to be specified for post-setup installation of custom tools (e.g. Splunk/Elastic agents, Sysmon).
- Shutdown/Startup scripts for reducing costs on AWS from unused resources
```