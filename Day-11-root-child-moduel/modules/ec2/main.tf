resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids

  associate_public_ip_address = true

  iam_instance_profile = var.iam_instance_profile
  
  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = var.delete_on_termination
    encrypted             = var.encrypted
  }

  tags = merge(
    {
      Name = var.instance_name
    },
    var.tags
  )
}