provider "aws" {
  
}

variable "allowed_ports" {
    type = map(string)
    default = {
    #key = value
    22    = "203.0.113.0/24"    # SSH (Restrict to office IP)
    80    = "0.0.0.0/0"         # HTTP (Public)
    443   = "0.0.0.0/0"         # HTTPS (Public)
    8080  = "10.0.0.0/16"       # Internal App (Restrict to VPC)
    9000  = "192.168.1.0/24"    # SonarQube/Jenkins (Restrict to VPN)
    3389  = "10.0.1.0/24"
    3000  = "10.0.2.0/24"

  }
}
  
resource "aws_security_group" "devops-project" {
  name        = "devops-project"
  description = "Allow TLS inbound traffic"

  

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description = "Allow access to port ${ingress.key}"
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = [ingress.value]  #  also if we want to allow access from another security group
    #   security_groups = [aws_security_group.app.id]
    }
     
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-project"
  }
}


# locals {
#   app_ports = [
#     { port = 5432, desc = "Postgres" },
#     { port = 6379, desc = "Redis"    },
#     { port = 2181, desc = "Zookeeper"},
#   ]
# }

# resource "aws_security_group" "backend" {
#   name   = "backend-sg"
#   vpc_id = var.vpc_id

#   dynamic "ingress" {
#     for_each = local.app_ports
#     content {
#       description     = "${ingress.value.desc} from app"
#       from_port       = ingress.value.port
#       to_port         = ingress.value.port
#       protocol        = "tcp"
#       security_groups = [aws_security_group.app.id]
#     }
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }