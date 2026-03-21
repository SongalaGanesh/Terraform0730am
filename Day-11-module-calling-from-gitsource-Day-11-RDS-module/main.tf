

module "rds" {
    source = "github.com/SongalaGanesh/Terraform0730am.git/Day-11-RDS-module"
    vpc_cidr = "10.0.0.0/16"

subnets = {
  subnet1 = {
    cidr = "10.0.0.0/24"
    az   = "us-east-1a"
  }
  subnet2 = {
    cidr = "10.0.1.0/24"
    az   = "us-east-1b"
  }
}

db_identifier         = var.db_identifier
db_name               = var.db_name
db_instance_class     = var.db_instance_class
db_allocated_storage  = var.db_allocated_storage
db_username           = var.db_username

#note here db_username is passing value to module variable and var.db_username is decalrined in variables.tf file and value is assigned in terraform.tfvars file


backup_window      = "02:00-03:00"
maintenance_window = "sun:04:00-sun:05:00"

  
}