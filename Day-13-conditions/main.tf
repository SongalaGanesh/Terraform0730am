provider "aws" {
  
}

# 1. count condition — create resource or not
variable "create_bastion" {
  type    = bool
  default = true
}

resource "aws_instance" "bastion" {
  count         = var.create_bastion ? 1 : 0
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
}


# 2. condition in variable validation
variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "instance_type" {
  type    = string
  default = "t2.micro"

  validation {
    condition     = can(regex("^t2\\.|^t3\\.|^m5\\.", var.instance_type))
    error_message = "Only t2, t3, or m5 instance types are allowed."
  }
}


# 3. Conditional value with locals
variable "environment" {
  default = "dev"
}

locals {
  instance_type = var.environment == "prod" ? "t3.large" : "t2.micro"
  min_size      = var.environment == "prod" ? 3 : 1
  max_size      = var.environment == "prod" ? 10 : 2

  # nested condition
  instance_name = (
    var.environment == "prod" ? "prod-server" :
    var.environment == "staging" ? "staging-server" :
    "dev-server"
  )
}

resource "aws_instance" "app" {
  ami           = "ami-0abcdef1234567890"
  instance_type = local.instance_type

  tags = {
    Name = local.instance_name
  }
}

# 4. Condition on cidr_blocks — your SG use case
variable "environment" {
  default = "dev"
}

variable "allowed_ports" {
  type = map(string)
  default = {
    22   = "203.0.113.0/24"
    80   = "0.0.0.0/0"
    443  = "0.0.0.0/0"
    8080 = "10.0.0.0/16"
  }
}

resource "aws_security_group" "devops-project" {
  name        = "devops-project-veera-nit"
  description = "Allow inbound traffic"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description = "Allow port ${ingress.key}"
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"

      # condition: lock down all ports in prod, use variable CIDRs in dev
      cidr_blocks = var.environment == "prod" ? ["10.0.0.0/16"] : [ingress.value]
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


# 5. Conditional resource with for_each
variable "enable_monitoring" {
  type    = bool
  default = false
}

variable "monitoring_ports" {
  type = map(string)
  default = {
    9090 = "10.0.0.0/16"   # Prometheus
    3000 = "10.0.0.0/16"   # Grafana
    9100 = "10.0.0.0/16"   # Node Exporter
  }
}

# only creates these rules if monitoring is enabled
resource "aws_security_group_rule" "monitoring" {
  for_each = var.enable_monitoring ? var.monitoring_ports : {}

  type              = "ingress"
  security_group_id = aws_security_group.devops-project.id
  protocol          = "tcp"
  from_port         = each.key
  to_port           = each.key
  cidr_blocks       = [each.value]
  description       = "Monitoring port ${each.key}"
}


# 6. Conditional tag / value
variable "environment" {
  default = "dev"
}

locals {
  common_tags = {
    Environment = var.environment
    Team        = "devops"
    # only add CostCenter tag in prod
    CostCenter  = var.environment == "prod" ? "CC-1234" : null
  }
}

resource "aws_instance" "app" {
  ami           = "ami-0abcdef1234567890"
  instance_type = var.environment == "prod" ? "t3.large" : "t2.micro"
  tags          = local.common_tags
}




#       Condition                    						 typeSyntax
# True/false 										togglecount = var.create ? 1 : 0
# Value 											switchvar.env == "prod" ? "t3.large" : "t2.micro"
# Empty map (skip for_each)						    var.enable ? var.ports : {}
# Empty list (skip dynamic block)                   var.enable ? [1] : []
# Input validation                                  validation { condition = ... }
# Null tag (omit it)                                Tag = var.env == "prod" ? "val" : null