## Project/Deployment ##
variable "region" {
}

variable "project_name" {
}

variable "managed_by" {
}


## attacker ##
variable "vpc_id" {
}

variable "attacker_subnet_cidr" {
}

variable "victim_subnet_cidr" {
}

variable "igw" {
}

variable "nat_gateway" {
}

variable "ssh_public_key" {
}

variable "ovpn_internal_cidr" {
}

variable "caldera_ami_owner" {
}

variable "caldera_ami_name" {
}

variable "caldera_instance_type" {
}

variable "caldera_private_ip" {
}