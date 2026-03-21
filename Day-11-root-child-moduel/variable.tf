# VPC variables
variable "cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = ""
}

variable "subnet_1_cidr" {
  description = "Subnet 1 CIDR block"
  type        = string
  default     = ""
}

variable "subnet_2_cidr" {
  description = "Subnet 2 CIDR block"
  type        = string
  default     = ""
}

variable "az1" {
  description = "Availability zone 1"
  type        = string
  default     = ""
}

variable "az2" {
  description = "Availability zone 2"
  type        = string
  default     = ""
}

# EC2 variables
variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "instance_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "root_volume_size" {
  type    = number
  default = 20
}

variable "root_volume_type" {
  type    = string
  default = "gp3"
}

variable "delete_on_termination" {
  type    = bool
  default = true
}

variable "encrypted" {
  type    = bool
  default = true
}

# RDS variables
variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = ""
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = ""
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = ""
}
