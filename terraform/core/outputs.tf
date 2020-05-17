output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "igw" {
  value = aws_internet_gateway.igw
}

output "public_key" {
  value = aws_key_pair.public_key
}

output "int_public_key" {
  value = aws_key_pair.int_public_key
}