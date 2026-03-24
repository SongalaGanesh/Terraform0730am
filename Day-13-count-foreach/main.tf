provider "aws" {
  
}


variable "create_basion" {
    type = bool
    default = true
  
}

# 1. Basic — create or skip a resource
resource "aws_instance" "ec2" {
    count = var.create_basion ? 1 : 0
    ami           = "ami-0abcdef1234567890"
    instance_type = "t2.micro"
    tags = {
        Name = "devops-project-ec2"
    }
}

# 2. Create multiple EC2 instances / or create multpile identical resources

resource "aws_instance" "app" {
    count = 3
    ami           = "ami-0abcdef1234567890"
    instance_type = "t2.micro"
    tags = {
        Name = "devops-project-app-${count.index}"
    }
}


# 3. Create multiple S3 buckets
variable "bucket_count" {
  default = 3
}

resource "aws_s3_bucket" "logs" {
  count  = var.bucket_count
  bucket = "my-project-logs-${count.index}"

  tags = {
    Name = "log-bucket-${count.index}"
  }
}

output "bucket_names" {
  value = aws_s3_bucket.logs[*].bucket
}



# 4. Conditional security group rule with count

variable "enable_ssh" {
  type    = bool
  default = false
}

resource "aws_security_group_rule" "ssh" {
  count = var.enable_ssh ? 1 : 0

  type              = "ingress"
  security_group_id = aws_security_group.main.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["203.0.113.0/24"]
  description       = "SSH from office"
}



# 5. Create IAM users with count
variable "user_count" {
  default = 3
}

resource "aws_iam_user" "devops" {
  count = var.user_count
  name  = "devops-user-${count.index + 1}"   # starts from 1 instead of 0

  tags = {
    Name = "devops-user-${count.index + 1}"
  }
}

output "iam_usernames" {
  value = aws_iam_user.devops[*].name
}


# 6. Basic — loop over a list of strings
variable "environments" {
  type    = set(string)
  default = ["dev", "staging", "prod"]
}

resource "aws_s3_bucket" "env_buckets" {
  for_each = var.environments
  bucket   = "myproject-${each.value}-bucket"

  tags = {
    Name        = "myproject-${each.value}-bucket"
    Environment = each.value
  }
}

# 7. Loop over a map — different values per resource

variable "instances" {
  type = map(string)
  default = {
    web     = "t2.micro"
    app     = "t2.medium"
    db      = "t3.large"
  }
}

resource "aws_instance" "servers" {
  for_each      = var.instances
  ami           = "ami-0abcdef1234567890"
  instance_type = each.value        # t2.micro / t2.medium / t3.large

  tags = {
    Name = "${each.key}-server"     # web-server / app-server / db-server
  }
}

# reference a specific instance
output "web_server_ip" {
  value = aws_instance.servers["web"].public_ip
}

# reference all instances
output "all_server_ips" {
  value = { for k, v in aws_instance.servers : k => v.public_ip }
}


# 8. Security group — your exact use case
variable "allowed_ports" {
  type = map(string)
  default = {
    22   = "203.0.113.0/24"
    80   = "0.0.0.0/0"
    443  = "0.0.0.0/0"
    8080 = "10.0.0.0/16"
    9000 = "192.168.1.0/24"
  }
}

resource "aws_security_group" "main" {
  name = "main-sg"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description = "Allow port ${ingress.key}"
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# 9. IAM users with for_each — named users
variable "iam_users" {
  type    = set(string)
  default = ["ganesh", "ravi", "kumar", "sandhya"]
}

resource "aws_iam_user" "team" {
  for_each = var.iam_users
  name     = each.value

  tags = {
    Name = each.value
  }
}

output "user_arns" {
  value = { for k, v in aws_iam_user.team : k => v.arn }
}

# 10. Map of objects — full config per resource
variable "ec2_instances" {
  type = map(object({
    instance_type = string
    volume_size   = number
    environment   = string
  }))
  default = {
    web = {
      instance_type = "t2.micro"
      volume_size   = 20
      environment   = "prod"
    }
    app = {
      instance_type = "t2.medium"
      volume_size   = 40
      environment   = "prod"
    }
    dev = {
      instance_type = "t2.micro"
      volume_size   = 10
      environment   = "dev"
    }
  }
}

resource "aws_instance" "servers" {
  for_each      = var.ec2_instances
  ami           = "ami-0abcdef1234567890"
  instance_type = each.value.instance_type

  root_block_device {
    volume_size = each.value.volume_size
  }

  tags = {
    Name        = "${each.key}-server"
    Environment = each.value.environment
  }
}

# 11. Multiple S3 buckets with policies
variable "buckets" {
  type = map(string)
  default = {
    logs    = "private"
    static  = "public-read"
    backups = "private"
  }
}

resource "aws_s3_bucket" "project" {
  for_each = var.buckets
  bucket   = "myproject-${each.key}"

  tags = {
    Name = "myproject-${each.key}"
    ACL  = each.value
  }
}

resource "aws_s3_bucket_acl" "project" {
  for_each = var.buckets
  bucket   = aws_s3_bucket.project[each.key].id
  acl      = each.value
}

# count vs for_each — when to use which
# COUNT — use when resources are identical, only quantity differs
resource "aws_instance" "web" {
  count         = 3                         # 3 identical web servers
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
  tags = { Name = "web-${count.index}" }
}

# FOR_EACH — use when each resource has different config
resource "aws_instance" "servers" {
  for_each      = {                         # each server is different
    web = "t2.micro"
    app = "t2.medium"
    db  = "t3.large"
  }
  ami           = "ami-0abcdef1234567890"
  instance_type = each.value
  tags = { Name = each.key }
}
