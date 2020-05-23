output "nat_gateway" {
  value = aws_nat_gateway.nat_gateway
}

output "ovpn" {
  value = aws_instance.ovpn
}

output "ovpn_eip" {
  value = aws_eip.ovpn_eip
}