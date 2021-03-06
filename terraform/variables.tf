## AWS Provider ##
variable "aws_credential_profile" {
  description = "Name of AWS credential profile to use to authenticate with AWS"
}

variable "region" {
  default = "ap-southeast-2"
  description = "Region to deploy all instances"  
}

## Deployment Information ##
variable "project_name" {
  description = "A project name tagged to all cloud instances"
}

variable "managed_by" {
  default = "terraform"
  description = "Identifying tag for all terraform managed instances"
}

variable "ovpn_ansible_hosts_file" {
  description = "relative location of the ovpn ansible inventory file"
}

variable "windows_ansible_hosts_file" {
  description = "relative location of the windows ansible inventory file"
}

variable "caldera_ansible_hosts_file" {
  description = "relative location of the caldera ansible inventory file"
}

variable "linux_ansible_hosts_file" {
  description = "relative location of the linux ansible inventory file"
}

#############
## Modules ##
#############

## core ##
variable "vpc_cidr" {
  description = "Subnet to be used within VPC"
}

variable "ssh_public_key_file" {
  description = "File location of public key for linux servers"
}

variable "win_rsa_public_key_file" {
  description = "File location of public key used for encrypting secrets for Windows servers"
}


## public ## 
variable "public_subnet_cidr" {
  description = "Subnet to be used within public subnet (public is just the name, it is actually internal to the vpc)"
}

variable "ovpn_ami_owner" {
  description = "Owner of the ami to be used to provision an instance for openvpn"
}

variable "ovpn_ami_name" {
  description = "Name of the ami to be used to provision an instance for openvpn"
}

variable "ovpn_instance_type" {
  description = "Instance type for the openvpn server"
}

variable "ovpn_private_ip" {
  description = "Private IP address assigned to server in the public subnet"
}

variable "trusted_networks" {
  description = "CIDR of trusted networks allowed to connect to OVPN server"
}

## attacker ##
variable "attacker_subnet_cidr" {
  description = "Subnet to be used within the attacker subnet"
}

variable "caldera_ami_owner" {
  description = "Owner of the ami to be used to provision an instance for caldera"
}

variable "caldera_ami_name" {
  description = "Name of the ami to be used to provision an instance for caldera"
}

variable "caldera_instance_type" {
  description = "Instance type for the caldera server"
}

variable "caldera_private_ip" {
  description = "Private IP address assigned to the caldera server in the private subnet"
}


## victim ##
variable "victim_subnet_cidr" {
  description = "Subnet to be used within the victim subnet"
}

variable "win_rsa_private_key_file" {
  description = "File location of private key used for decrypting secrets for Windows servers"
}

variable "DC_instance_type" {
  description = "AWS instance type for the Domain Controller server"
}

variable "Server2016_instance_type" {
  description = "AWS instance type for the member server"
}

variable "Server2012R2_instance_type" {
  description = "AWS instance type for the Server2012R2 server"
}

variable "Server2019_instance_type" {
  description = "AWS instance type for the Server2019 server"
}

variable "RHEL7_1_instance_type" {
  description = "AWS instance type for the RHEL7.1 server"
}

variable "Ubuntu1804_instance_type" {
  description = "AWS instance type for the Ubuntu1804 server"
}

variable "DC_ip" {
  description = "Internal IP address of the domain controller"
}

variable "Server2016_ip" {
  description = "Internal IP address of the Server2016 member server"
}

variable "Server2012R2_ip" {
  description = "Internal IP address of the Server2012R2 server"
}

variable "Server2019_ip" {
  description = "Internal IP address of the Server2019 member server"
}

variable "RHEL7_1_ip" {
  description = "Internal IP address of the Redhat 7.1 server"
}

variable "Ubuntu1804_ip" {
  description = "Internal IP address of the Ubuntu18.04 server"
}

variable "DC_ami_owner" {
  description = "Owner of the ami to be used for the domain controller"
}

variable "DC_ami_name" {
  description = "Name of the ami to be used for the domain controller"
}

variable "Server2016_ami_owner" {
  description = "Owner of the ami to be used for the 2016 server"
}

variable "Server2016_ami_name" {
  description = "Name of the ami to be used for the 2016 server"
}

variable "Server2012R2_ami_owner" {
  description = "Owner of the ami to be used for the Server2012R2 server e.g. Microsoft"
}

variable "Server2012R2_ami_name" {
  description = "Name of the ami to be used for the Server2012R2 server"
}

variable "Server2019_ami_owner" {
  description = "Owner of the ami to be used for the 2019 server"
}

variable "Server2019_ami_name" {
  description = "Name of the ami to be used for the 2019 server"
}

variable "RHEL7_1_ami_owner" {
  description = "Owner of the ami to be used for the RHEL 7.1 server"
}

variable "RHEL7_1_ami_name" {
  description = "Name of the ami to be used for the RHEL 7.1 server"
}

variable "Ubuntu1804_ami_owner" {
  description = "Owner of the ami to be used for the Ubuntu 18.04 server"
}

variable "Ubuntu1804_ami_name" {
  description = "Name of the ami to be used for the Ubuntu 18.04 server"
}