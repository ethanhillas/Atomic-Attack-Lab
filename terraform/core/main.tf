# VPC
# IGW
# NACL
# Key pair

## VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${var.project_name}"
    project_name = var.project_name
    managed_by = var.managed_by
  }
}

## Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw-${var.project_name}"
    project_name = var.project_name
    managed_by = var.managed_by
  }
}


## NACL



## Key Pair
resource "aws_key_pair" "ssh_public_key" {
  public_key = file(var.ssh_public_key_file)
}

resource "aws_key_pair" "win_rsa_public_key" {
  public_key = file(var.win_rsa_public_key_file)
}

