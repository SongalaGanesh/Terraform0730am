output "dev_public_ip" {
  value = aws_instance.dev.public_ip
}

output "dev_private_ip" {
  value = aws_instance.dev.private_ip
}

output "test_prviate_ip" {
  value = aws_instance.test.private_ip
}
