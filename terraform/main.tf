# Initialise Terraform
terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "adv-emul-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-southeast-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "adv-emul-terraform-state-locks"
    encrypt        = true
  }
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
  public_key_file = var.public_key_file
  int_public_key_file = var.int_public_key_file
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
  public_key = module.core.public_key
  public_subnet_cidr = var.public_subnet_cidr
  attacker_subnet_cidr = var.attacker_subnet_cidr
  victim_subnet_cidr = var.victim_subnet_cidr
  ovpn_ami_owner = var.ovpn_ami_owner
  ovpn_ami_name = var.ovpn_ami_name
  ovpn_instance_type = var.ovpn_instance_type
  ovpn_private_ip = var.ovpn_private_ip
  trusted_network = var.trusted_network
  #private_key_path = var.private_key_path
}

module "attacker" {
  source = "./attacker"

  # Project/deployment variables
  project_name = var.project_name
  managed_by = var.managed_by
  region = var.region

  # Module variables
  vpc_id = module.core.vpc_id
  public_key = module.core.public_key
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
  int_public_key = module.core.int_public_key
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