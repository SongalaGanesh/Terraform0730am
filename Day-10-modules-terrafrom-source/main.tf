module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type = "t3.micro"
  subnet_id     = "subnet-06160e6a7fa4a5e15"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}