variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
}


variable "security_group_ids" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "associate_public_ip" {
  type    = bool
  default = true
}

variable "instance_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

# IAM Instance Profile
variable "iam_instance_profile" {
  description = "IAM Instance Profile Name"
  type        = string
  default     = null
}

# Root Volume Config
variable "root_volume_size" {
  description = "Root EBS volume size (GB)"
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "EBS volume type (gp2, gp3, io1, etc.)"
  type        = string
  default     = "gp3"
}

variable "delete_on_termination" {
  type    = bool
  default = true
}

variable "encrypted" {
  type    = bool
  default = true
}