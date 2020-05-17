# Subnet
# Route table
# Route table association
# SGs
# Servers


# Attacker subnet
resource "aws_subnet" "attacker_subnet" {
  vpc_id = var.vpc_id

  cidr_block = var.attacker_subnet_cidr
  availability_zone = "${var.region}a" # ap-southeast-2a

  tags = {
    Name = "attacker_subnet-${var.project_name}"
    project_name = var.project_name
    managed_by = var.managed_by
  }
}

# Route Table
resource "aws_route_table" "attacker_subnet_route_table" {
  vpc_id = var.vpc_id

  # Remove this route before running attacks
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_gateway.id
  }

  tags = {
    Name = "attacker_subnet_route_table-${var.project_name}"
    project_name = var.project_name
    managed_by = var.managed_by
  }
}

# Route table association
resource "aws_route_table_association" "attacker_route_table_association" {
  subnet_id = aws_subnet.attacker_subnet.id
  route_table_id = aws_route_table.attacker_subnet_route_table.id
}


# Security Groups
resource "aws_security_group" "attacker_to_victim_machines" {
  name = "attacker_to_victim_machines"
  description = "Allow all connections between attacker and victim machines"
  vpc_id = var.vpc_id

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = [var.victim_subnet_cidr]
  }

  egress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = [var.victim_subnet_cidr]
  }
  
  tags = {
    Name = "sg-attacker_to_victim_machines-${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}

resource "aws_security_group" "attacker_machines_internal" {
  name = "attacker_machines_internal"
  description = "SG for communication between attacker machines"
  vpc_id = var.vpc_id

  ingress {
    protocol = -1
    from_port = 0
    to_port = 0
    # using a CIDR instead of self because of OVPN clients are IP based, not VM.
    # OVPN clients will sit in 10.0.1.8/29
    cidr_blocks = [var.attacker_subnet_cidr]
  }

  ingress { 
    description = "SG for connections from OVPN clients"
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks =  [var.ovpn_internal_cidr] 
  }

  egress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = [var.attacker_subnet_cidr]
  }

  tags = {
    Name = "sg-attacker_machines_internal-${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}

resource "aws_security_group" "attacker_machines_external" {
  name = "attacker_machines_external"
  description = "SG for external network communication via a NAT gateway"
  vpc_id = var.vpc_id

  egress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-attacker_machines_external-${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}

## Servers
# Caldera
# ami definition
data "aws_ami" "caldera_ami" {
  most_recent = true
  owners = [var.caldera_ami_owner]

  filter {
    name = "name"
    values = [var.caldera_ami_name]
  }
}

# Server instance
resource "aws_instance" "caldera" {
  # type
  ami = data.aws_ami.caldera_ami.id
  instance_type = var.caldera_instance_type
  
  # access
  key_name = var.public_key.key_name

  # networking
  subnet_id = aws_subnet.attacker_subnet.id
  private_ip = var.caldera_private_ip
  vpc_security_group_ids = [aws_security_group.attacker_machines_internal.id, 
                            aws_security_group.attacker_machines_external.id, 
                            aws_security_group.attacker_to_victim_machines.id]

  # storage


  tags = {
    Name = "caldera_instance-${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}