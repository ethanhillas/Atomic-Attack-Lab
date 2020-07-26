output "DC" {
  value = aws_instance.DC
}

output "Server2016" {
  value = aws_instance.Server2016
}

output "Server2012R2" {
  value = aws_instance.Server2012R2
}

output "Server2019" {
  value = aws_instance.Server2019
}

output "RHEL7_1" {
  value = aws_instance.RHEL7_1
}

output "Ubuntu1804" {
  value = aws_instance.Ubuntu1804
}

output "DC_password" { 
  value = "${rsadecrypt(aws_instance.DC.password_data, file("${var.win_rsa_private_key_file}"))}"
}

output "Server2016_password" { 
  value = "${rsadecrypt(aws_instance.Server2016.password_data, file("${var.win_rsa_private_key_file}"))}"
}

output "Server2012R2_password" { 
  value = "${rsadecrypt(aws_instance.Server2012R2.password_data, file("${var.win_rsa_private_key_file}"))}"
}

output "Server2019_password" { 
  value = "${rsadecrypt(aws_instance.Server2019.password_data, file("${var.win_rsa_private_key_file}"))}"
}