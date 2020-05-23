output "DC" {
  value = aws_instance.DC
}

output "MS" {
  value = aws_instance.MS
}

output "DC_password" { 
  value = "${rsadecrypt(aws_instance.DC.password_data, file("./utils/certs/windows_rsa"))}"
}

output "MS_password" { 
  value = "${rsadecrypt(aws_instance.MS.password_data, file("./utils/certs/windows_rsa"))}"
}