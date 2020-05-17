# Subnet
# Route table
# Route table association
# SGs
# Windows Servers


# Victim subnet
resource "aws_subnet" "victim_subnet" {
  vpc_id = var.vpc_id

  cidr_block = var.victim_subnet_cidr
  availability_zone = "${var.region}a" # ap-southeast-2a

  tags = {
    Name = "victim_subnet-${var.project_name}"
    project_name = var.project_name
    managed_by = var.managed_by
  }
}

# Route Tables
resource "aws_route_table" "victim_subnet_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_gateway.id
  }

  tags = {
    Name = "victim_subnet_route_table-${var.project_name}"
    project_name = var.project_name
    managed_by = var.managed_by
  }
}

# Route table association
resource "aws_route_table_association" "victim_route_table_association" {
  subnet_id = aws_subnet.victim_subnet.id
  route_table_id = aws_route_table.victim_subnet_route_table.id
}

# Security Groups
resource "aws_security_group" "victim_to_attacker_machines" {
  name = "victim_to_attacker_machines"
  description = "Allow all connections between attacker and victim machines. Restricted egress connections to only attacker subnet (not OVPN)"
  vpc_id = var.vpc_id

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = [
      var.attacker_subnet_cidr, 
      var.ovpn_internal_cidr
    ]
  }

  egress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = [var.attacker_subnet_cidr]
  }
  
  tags = {
    Name = "sg-victim_to_attacker_machines-${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}

resource "aws_security_group" "win_victim_machines_internal" {
  name = "win_victim_machines_internal"
  description = "SG for internal network communication between windows victim hosts"
  vpc_id = var.vpc_id

  ingress {
    protocol = -1
    from_port = 0
    to_port = 0
    self = true
  }

  egress {
    protocol = -1
    from_port = 0
    to_port = 0
    self = true
  }

  tags = {
    Name = "sg-win_victim_machines_internal-${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}

resource "aws_security_group" "win_victim_machines_external" {
  name = "win_victim_machines_external"
  description = "SG for windows machines external network communication via a NAT gateway"
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
    Name = "sg-win_victim_machines_external-${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}

## Windows Servers
# ami definition
data "aws_ami" "DC_ami" {
  most_recent = true
  owners = [var.DC_ami_owner]

  filter {
    name = "name"
    values = [var.DC_ami_name]
  }
}

# ami definition
data "aws_ami" "MS_ami" {
  most_recent = true
  owners = [var.MS_ami_owner]

  filter {
    name = "name"
    values = [var.MS_ami_name]
  }
}

# DC
resource "aws_instance" "DC" {

  ami = data.aws_ami.DC_ami.id
  instance_type = var.DC_instance_type

  subnet_id = aws_subnet.victim_subnet.id
  private_ip = var.DC_ip

  key_name = var.int_public_key.key_name


  user_data = file("./utils/user_data.txt")
  get_password_data = true

  vpc_security_group_ids = [
    aws_security_group.victim_to_attacker_machines.id,
    aws_security_group.win_victim_machines_internal.id,
    aws_security_group.win_victim_machines_external.id
  ]

  tags = {
    Name = "Win-server-DC${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}

# MS
resource "aws_instance" "MS" {

  ami = data.aws_ami.MS_ami.id
  instance_type = var.MS_instance_type

  subnet_id = aws_subnet.victim_subnet.id
  private_ip = var.MS_ip

  key_name = var.int_public_key.key_name

  user_data = file("./utils/user_data.txt")
  get_password_data = true

  vpc_security_group_ids = [
    aws_security_group.victim_to_attacker_machines.id,
    aws_security_group.win_victim_machines_internal.id,
    aws_security_group.win_victim_machines_external.id
  ]

  tags = {
    Name = "Win-server-MS${var.project_name}"
    project_name = var.project_name
    managed-by = var.managed_by   
  }
}