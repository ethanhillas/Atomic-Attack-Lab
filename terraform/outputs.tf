output "ovpn_server" {
  value = format("OpenVPN server\nPublic IP: %s\nPublic DNS: %s", module.public.ovpn_eip.public_dns, module.public.ovpn_eip.public_ip)
}


## Local file provisioners for ansible hosts files
# OVPN
resource "local_file" "ovpn_ansible_hosts_file" {
  filename = var.ovpn_ansible_hosts_file
  content = <<-EOT
  [ovpn_server]
  ${module.public.ovpn_eip.public_dns} ansible_host=${module.public.ovpn_eip.public_ip}

  [ovpn_server:vars]
  ansible_user=ubuntu
  EOT
}

# Attackers
resource "local_file" "caldera_ansible_hosts_file" {
  filename = var.caldera_ansible_hosts_file
  content = <<-EOT
  [caldera_server]
  ${module.attacker.caldera.private_dns} ansible_host=${module.attacker.caldera.private_ip}

  [caldera_server:vars]
  ansible_user=ubuntu
  EOT
}

# Victims
resource "local_file" "windows_ansible_hosts_file" {
  filename = var.windows_ansible_hosts_file
  content = <<-EOT
  [dc]
  ${module.victim.DC.private_dns} ansible_host=${module.victim.DC.private_ip} ansible_user=Administrator ansible_password="${module.victim.DC_password}" domain_hostname=JARVIS

  [ms]
  ${module.victim.Server2016.private_dns} ansible_host=${module.victim.Server2016.private_ip} ansible_user=Administrator ansible_password="${module.victim.Server2016_password}" domain_hostname=Mark-XVI
  ${module.victim.Server2012R2.private_dns} ansible_host=${module.victim.Server2012R2.private_ip} ansible_user=Administrator ansible_password="${module.victim.Server2012R2_password}" domain_hostname=Mark-XII
  ${module.victim.Server2019.private_dns} ansible_host=${module.victim.Server2019.private_ip} ansible_user=Administrator ansible_password="${module.victim.Server2019_password}" domain_hostname=Mark-XIX
  EOT
}

