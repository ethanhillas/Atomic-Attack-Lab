# Subnet
# Route table
# Route table association
# SGs
# Servers
# Elastic IPs
# NAT Gateway

# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = var.vpc_id

  cidr_block = var.public_subnet_cidr
  availability_zone = "${var.region}a" # ap-southeast-2a
  map_public_ip_on_launch = false

  tags = {
    Name = "public_subnet-${var.project_name}"
    project_name = var.project_name
    managed_by = var.managed_by
  }
}


# Route Table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw.id
  }

  tags = {
    Name = "public_subnet_route_table-${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}

# Route table association
resource "aws_route_table_association" "route_table_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

## Security Groups
# OVPN public
resource "aws_security_group" "ovpn_public" {
  name = "ovpn_public_access"
  description = "Required security group rules for ovpn to recieve connections from the internet"
  vpc_id = var.vpc_id

  ingress {
    description = "SSH inbound for remote admin"
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = [var.trusted_network]
  }

  ingress {
    description = "OVPN admin web ui"
    protocol  = "tcp"
    from_port = 943
    to_port   = 943
    cidr_blocks = [var.trusted_network]
  }

  ingress {
    description = "OVPN client webserver"
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = [var.trusted_network]
  }

  ingress {
    description = "OVPN VPN port"
    protocol  = "udp"
    from_port = 1194
    to_port   = 1194
    cidr_blocks = [var.trusted_network]
  }

  egress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "ovpn_public_sg-${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}

# OVPN
resource "aws_security_group" "ovpn_private" {
  name = "ovpn_private_access"
  description = "Required security group rules for ovpn clients internally"
  vpc_id = var.vpc_id

    ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = [var.attacker_subnet_cidr, 
                   var.victim_subnet_cidr]
  }

  egress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = [var.attacker_subnet_cidr, 
                   var.victim_subnet_cidr]
  }
  
  tags = {
    Name = "ovpn_private_sg-${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}

## Servers
# OVPN
# ami definition
data "aws_ami" "ovpn_ami" {
  most_recent = true
  owners = [var.ovpn_ami_owner]

  filter {
    name = "name"
    values = [var.ovpn_ami_name]
  }
}

# Server instance
resource "aws_instance" "ovpn" {
  # type
  ami = data.aws_ami.ovpn_ami.id
  instance_type = var.ovpn_instance_type
  
  # access
  key_name = var.public_key.key_name

  # networking
  source_dest_check = false #required for ovpn server
  subnet_id = aws_subnet.public_subnet.id
  private_ip = var.ovpn_private_ip
  vpc_security_group_ids = [aws_security_group.ovpn_public.id,
                            aws_security_group.ovpn_private.id]

  # storage

  #depends_on = [aws_eip.ovpn_eip]

  tags = {
    Name = "ovpn_instance-${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}


# Elastic IPs
resource "aws_eip" "ovpn_eip" {
  vpc = true
  tags = {
    Name = "ovpn_eip-${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}

resource "aws_eip_association" "ovpn_eip_association" {
  instance_id = aws_instance.ovpn.id
  allocation_id = aws_eip.ovpn_eip.id
}

resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = "nat_eip-${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on = [var.igw]
  tags = {
    Name = "nat_gateway-${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}