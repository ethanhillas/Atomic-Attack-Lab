output "DC" {
  value = aws_instance.DC
}

output "MS" {
  value = aws_instance.MS
}

output "DC_password" { 
  value = "${rsadecrypt(aws_instance.DC.password_data, file("${var.win_rsa_private_key_file}"))}"
}

output "MS_password" { 
  value = "${rsadecrypt(aws_instance.MS.password_data, file("${var.win_rsa_private_key_file}"))}"
}