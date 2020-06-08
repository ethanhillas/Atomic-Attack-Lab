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

# Windows
variable "DC_instance_type" {
}

variable "MS_instance_type" {
}

variable "DC_ip" {
}

variable "MS_ip" {
}

variable "DC_ami_owner" {
}

variable "DC_ami_name" {
}

variable "MS_ami_owner" {
}

variable "MS_ami_name" {
}