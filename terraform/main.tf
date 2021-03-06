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
  trusted_networks = var.trusted_networks
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
  ssh_public_key = module.core.ssh_public_key
  igw = module.core.igw
  nat_gateway = module.public.nat_gateway
  victim_subnet_cidr = var.victim_subnet_cidr
  attacker_subnet_cidr = var.attacker_subnet_cidr
  ovpn_internal_cidr = "${module.public.ovpn.private_ip}/32"
  DC_instance_type = var.DC_instance_type
  Server2016_instance_type = var.Server2016_instance_type
  Server2012R2_instance_type = var.Server2012R2_instance_type
  Server2019_instance_type = var.Server2019_instance_type
  RHEL7_1_instance_type = var.RHEL7_1_instance_type
  Ubuntu1804_instance_type = var.Ubuntu1804_instance_type
  DC_ip = var.DC_ip
  Server2016_ip = var.Server2016_ip
  Server2012R2_ip = var.Server2012R2_ip
  Server2019_ip = var.Server2019_ip
  RHEL7_1_ip = var.RHEL7_1_ip
  Ubuntu1804_ip = var.Ubuntu1804_ip
  DC_ami_owner = var.DC_ami_owner
  DC_ami_name = var.DC_ami_name
  Server2016_ami_owner = var.Server2016_ami_owner
  Server2016_ami_name = var.Server2016_ami_name
  Server2012R2_ami_owner = var.Server2012R2_ami_owner
  Server2012R2_ami_name = var.Server2012R2_ami_name
  Server2019_ami_owner = var.Server2019_ami_owner
  Server2019_ami_name = var.Server2019_ami_name
  RHEL7_1_ami_owner = var.RHEL7_1_ami_owner
  RHEL7_1_ami_name = var.RHEL7_1_ami_name
  Ubuntu1804_ami_owner = var.Ubuntu1804_ami_owner
  Ubuntu1804_ami_name = var.Ubuntu1804_ami_name
}