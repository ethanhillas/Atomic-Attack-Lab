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

#############
## Modules ##
#############

## core ##
variable "vpc_cidr" {
  description = "Subnet to be used within VPC"
}

variable "public_key_file" {
  description = "File location of public key for external servers (OVPN)"
}

variable "int_public_key_file" {
  description = "File location of public key used for internal servers"
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

variable "trusted_network" {
  description = "CIDR of trusted networks allowed to connect to OVPN server"
}

# variable "private_key_path" {
#   description = "Used for remote-exec - TESTING"
# }

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

variable "DC_instance_type" {
  description = "AWS instance type for the Domain Controller server"
}

variable "MS_instance_type" {
  description = "AWS instance type for the member server"
}

variable "DC_ip" {
  description = "Internal IP address of the domain controller"
}

variable "MS_ip" {
  description = "Internal IP address of the member server"
}

variable "DC_ami_owner" {
  description = "Owner of the ami to be used for the domain controller"
}

variable "DC_ami_name" {
  description = "Name of the ami to be used for the domain controller"
}

variable "MS_ami_owner" {
  description = "Owner of the ami to be used for the member server"
}

variable "MS_ami_name" {
  description = "Name of the ami to be used for the member server"
}