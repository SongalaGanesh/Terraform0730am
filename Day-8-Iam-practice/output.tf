output "role_name" {
  value = aws_iam_role.admin_role
}

output "private_ip" {
    value = aws_instance.test.private_ip
}

output "public_ip" {
    value = aws_instance.test.public_ip
}