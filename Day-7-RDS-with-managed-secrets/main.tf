resource "aws_db_instance" "Database" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "8.4.7"
  instance_class    = "db.t3.micro"
  multi_az          = false
  db_name           = "mydatabase"
  username          = "admin"
  #   password               = random_password.db_password.result
  manage_master_user_password = true #rds and secret manager manage this passwordmana
  db_subnet_group_name        = aws_db_subnet_group.aws_db_subnet_group.id
  vpc_security_group_ids      = [aws_security_group.DB_SG.id]

  backup_retention_period = 7                     # Retain backups for 7 days
  backup_window           = "02:00-03:00"         # Daily backup window (UTC)
  maintenance_window      = "sun:04:00-sun:05:00" # Maintenance every Sunday (UTC)
  deletion_protection     = true
  skip_final_snapshot     = true

  tags = {
    Name = "MyDatabaseInstance"
  }
}

resource "aws_vpc" "prod" {
  cidr_block = "192.0.0.0/16"
  tags = {
    Name = "prod-vpc"
  }
}

resource "aws_subnet" "prod_public_subnet" {
  vpc_id            = aws_vpc.prod.id
  cidr_block = "192.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "prod-public-subnet"
  }
}

resource "aws_subnet" "prod_private_subnet" {
  vpc_id            = aws_vpc.prod.id
  cidr_block = "192.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "prod-private-subnet"
  }
}

resource "aws_db_subnet_group" "aws_db_subnet_group" {
  name       = "aws-db-subnet-group"
  subnet_ids = [aws_subnet.prod_public_subnet.id, aws_subnet.prod_private_subnet.id]
}

resource "aws_security_group" "DB_SG" {
  name        = "db-security-group"
  description = "Allow MySQL traffic"
  vpc_id      = aws_vpc.prod.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["192.0.0.0/16"]
  }
}
