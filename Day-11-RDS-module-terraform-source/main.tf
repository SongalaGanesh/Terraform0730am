module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier        = var.db_identifier
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.db_allocated_storage
  allocated_storage = var.db_allocated_storage

  db_name  = var.db_name
  username = var.db_username
  port     = "3306"

  #iam_database_authentication_enabled = true
   manage_master_user_password = true

  vpc_security_group_ids = ["sg-0952d97b0339c425b"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  #monitoring_interval    = "30"
  #monitoring_role_name   = "MyRDSMonitoringRole"
  #create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = ["subnet-02d05ac8c98e0d388", "subnet-044d1935ab5448019"]

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = true

  
  
}