
### Requirements
* Terraform >=0.12
* AWS account
  * IAM user with EC2, S3, DynamoDB privileges
  * S3 bucket for terraform remote backend (TODO - set this up in a init process)
  * DynamoDB for locks on terraform state (TODO - set this up in a init process)
  * aws cli configured (credential profile set up)
* Ansible (including ansible-runner)
* Python3 >= 3.7
  * see requirements.txt
* OpenVPN client or OVPN-compatiable client (e.g. Tunnelblick for MacOS)

