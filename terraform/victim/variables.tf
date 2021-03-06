## Project/Deployment ##
variable "project_name" {
}

variable "managed_by" {
}

variable "region" {
}


## victim ##
variable "vpc_id" {
}

variable "victim_subnet_cidr" {
}

variable "igw" {
}

variable "nat_gateway" {
}

variable "attacker_subnet_cidr" {
}

variable "ovpn_internal_cidr" {
}

variable "win_rsa_public_key" {
}

variable "win_rsa_private_key_file" {
}

variable "ssh_public_key" {
}

# Windows
variable "DC_instance_type" {
}

variable "Server2016_instance_type" {
}

variable "Server2012R2_instance_type" {
}

variable "Server2019_instance_type" {
}

variable "RHEL7_1_instance_type" {
}

variable "Ubuntu1804_instance_type" {
}

variable "DC_ip" {
}

variable "Server2016_ip" {
}

variable "Server2012R2_ip" {
}

variable "Server2019_ip" {
}

variable "RHEL7_1_ip" {
}

variable "Ubuntu1804_ip" {
}

variable "DC_ami_owner" {
}

variable "DC_ami_name" {
}

variable "Server2016_ami_owner" {
}

variable "Server2016_ami_name" {
}

variable "Server2012R2_ami_owner" {
}

variable "Server2012R2_ami_name" {
}

variable "Server2019_ami_owner" {
}

variable "Server2019_ami_name" {
}

variable "RHEL7_1_ami_owner" {
}

variable "RHEL7_1_ami_name" {
}

variable "Ubuntu1804_ami_owner" {
}

variable "Ubuntu1804_ami_name" {
}