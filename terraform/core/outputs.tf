output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "igw" {
  value = aws_internet_gateway.igw
}

output "ssh_public_key" {
  value = aws_key_pair.ssh_public_key
}

output "win_rsa_public_key" {
  value = aws_key_pair.win_rsa_public_key
}