
### Requirements
* Terraform >=0.12
* AWS account
  * IAM user with EC2, S3, DynamoDB privileges
  * S3 bucket for terraform remote backend (TODO - set this up in a init process)
  * DynamoDB for locks on terraform state (TODO - set this up in a init process)
  * aws cli configured (credential profile set up)
* Python3
  * See requirements.txt for required packages, use a venv
* OpenVPN client or OVPN-compatiable client (e.g. Tunnelblick for MacOS, apt package for linux)
  * Connectivity tested on MacOS Catalina 10.15.4 and Kali 2020.2

