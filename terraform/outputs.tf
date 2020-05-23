output "ovpn_server" {
  value = format("OpenVPN server\nPublic IP: %s\nPublic DNS: %s", module.public.ovpn_eip.public_dns, module.public.ovpn_eip.public_ip)
}


## Local file provisioners for ansible hosts files
# OVPN
resource "local_file" "ovpn_ansible_hosts_file" {
  filename = var.ovpn_ansible_hosts_file
  #depends_on = [module.public.ovpn_eip_association]
  content = <<-EOT
  [ovpn_server]
  ${module.public.ovpn_eip.public_dns} ansible_host=${module.public.ovpn_eip.public_ip}

  [ovpn_server:vars]
  ansible_user=ubuntu
  EOT
}

# Victims
resource "local_file" "windows_ansible_hosts_file" {
  filename = var.windows_ansible_hosts_file
  content = <<-EOT
  [dc]
  ${module.victim.DC.private_dns} ansible_host=${module.victim.DC.private_ip} ansible_user=Administrator ansible_password=${module.victim.DC_password}

  [ms]
  ${module.victim.MS.private_dns} ansible_host=${module.victim.MS.private_ip} ansible_user=Administrator ansible_password=${module.victim.MS_password}
  EOT
}

# Attackers