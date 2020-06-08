# Initialise Terraform
terraform {
  required_version = ">=0.12.0"
  backend "s3" {} # this is initialised via the python-terraform module using backend_config
}

# Initialise AWS provider
provider "aws" {
  version = ">=2.57"
  region = var.region
  profile = var.aws_credential_profile
}

module "core" {
  source = "./core"

  # Project/deployment variables
  project_name = var.project_name
  managed_by = var.managed_by
  region = var.region

  # Module variables
  vpc_cidr = var.vpc_cidr
  ssh_public_key_file = var.ssh_public_key_file
  win_rsa_public_key_file = var.win_rsa_public_key_file
}

module "public" {
  source = "./public"

  # Project/deployment variables
  project_name = var.project_name
  managed_by = var.managed_by
  region = var.region

  # Module variables
  vpc_id = module.core.vpc_id
  igw = module.core.igw
  ssh_public_key = module.core.ssh_public_key
  public_subnet_cidr = var.public_subnet_cidr
  attacker_subnet_cidr = var.attacker_subnet_cidr
  victim_subnet_cidr = var.victim_subnet_cidr
  ovpn_ami_owner = var.ovpn_ami_owner
  ovpn_ami_name = var.ovpn_ami_name
  ovpn_instance_type = var.ovpn_instance_type
  ovpn_private_ip = var.ovpn_private_ip
  trusted_network = var.trusted_network
}

module "attacker" {
  source = "./attacker"

  # Project/deployment variables
  project_name = var.project_name
  managed_by = var.managed_by
  region = var.region

  # Module variables
  vpc_id = module.core.vpc_id
  ssh_public_key = module.core.ssh_public_key
  igw = module.core.igw
  nat_gateway = module.public.nat_gateway
  attacker_subnet_cidr = var.attacker_subnet_cidr
  victim_subnet_cidr = var.victim_subnet_cidr
  ovpn_internal_cidr = "${module.public.ovpn.private_ip}/32"
  caldera_ami_owner = var.caldera_ami_owner
  caldera_ami_name = var.caldera_ami_name
  caldera_instance_type = var.caldera_instance_type
  caldera_private_ip = var.caldera_private_ip
}

module "victim" {
  source = "./victim"

  # Project/deployment variables
  project_name = var.project_name
  managed_by = var.managed_by
  region = var.region

  # Module variables
  vpc_id = module.core.vpc_id
  win_rsa_public_key = module.core.win_rsa_public_key
  win_rsa_private_key_file = var.win_rsa_private_key_file
  igw = module.core.igw
  nat_gateway = module.public.nat_gateway
  victim_subnet_cidr = var.victim_subnet_cidr
  attacker_subnet_cidr = var.attacker_subnet_cidr
  ovpn_internal_cidr = "${module.public.ovpn.private_ip}/32"
  DC_instance_type = var.DC_instance_type
  MS_instance_type = var.MS_instance_type
  DC_ip = var.DC_ip
  MS_ip = var.MS_ip
  DC_ami_owner = var.DC_ami_owner
  DC_ami_name = var.DC_ami_name
  MS_ami_owner = var.MS_ami_owner
  MS_ami_name = var.MS_ami_name
}