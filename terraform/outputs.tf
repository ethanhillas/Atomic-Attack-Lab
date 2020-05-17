output "ovpn_server" {
  value = format("OpenVPN server\nPublic IP: %s\nPublic DNS: %s", module.public.ovpn.public_ip, module.public.ovpn.public_dns)
}