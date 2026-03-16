resource "aws_db_instance" "primary" {
  allocated_storage = 20
  identifier        = "primary-db-instance"
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  multi_az          = false
  username          = "admin"
  password          = "Ganesh123"
  #   manage_master_user_password = true #rds and secret manager manage this passwordmana
  db_subnet_group_name   = aws_db_subnet_group.aws_db_read_replica_subnet_group.name
  vpc_security_group_ids = [aws_security_group.DB_SG.id]

  backup_retention_period = 7                     # Retain backups for 7 days
  maintenance_window      = "sun:04:00-sun:05:00" # Maintenance every Sunday (UTC)
  skip_final_snapshot     = true
}


resource "aws_db_instance" "Read_Replica" {
  identifier        = "read-replica-db-instance"
  instance_class    = "db.t3.micro"

  replicate_source_db = aws_db_instance.primary.identifier


  publicly_accessible = false
  skip_final_snapshot = true
}

resource "aws_vpc" "prod" {
  cidr_block = "192.0.0.0/16"

  tags = {
    Name = "prod-vpc"
  }
}

resource "aws_subnet" "prod_private_subnet1" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "192.0.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prod-public-subnet"
  }
}

resource "aws_subnet" "prod_private_subnet2" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "192.0.20.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "prod-private-subnet"
  }
}

resource "aws_db_subnet_group" "aws_db_read_replica_subnet_group" {
  name       = "aws-db-read-replica-subnet-group"
  subnet_ids = [aws_subnet.prod_private_subnet1.id, aws_subnet.prod_private_subnet2.id]
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
