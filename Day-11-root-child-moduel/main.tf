module "vpc" {
  source         = "./modules/vpc"
  cidr_block     = var.cidr_block 
  subnet_1_cidr  = var.subnet_1_cidr  
  subnet_2_cidr  = var.subnet_2_cidr  
  az1            = var.az1 
  az2            = var.az2
}

module "ec2" {
  source = "./modules/ec2"

  instance_name      = var.instance_name
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.subnet_1_id
  security_group_ids = var.security_group_ids
  key_name           = var.key_name

  # IAM Role
  iam_instance_profile = var.iam_instance_profile

  # EBS Config
  root_volume_size      = var.root_volume_size
  root_volume_type      = var.root_volume_type
  delete_on_termination = var.delete_on_termination
  encrypted             = var.encrypted

  tags = {
    Environment = "dev"
    Owner       = "ganesh"
  }
}

module "rds" {
  source = "./modules/rds"

  db_name        = var.db_name
  db_username    = var.db_username
  db_password    = var.db_password
  instance_class = var.db_instance_class

  subnet_ids = [
    module.vpc.subnet_1_id,
    module.vpc.subnet_2_id
  ]

  security_group_ids = var.security_group_ids

  tags = {
    Environment = "dev"
    Owner       = "ganesh"
  }
}

module "s3" {
    source = "./modules/s3"
    bucket = "ganesh-terraform-bucket-2026"

}

module "lambda" {
    source = "./modules/lambda"
}