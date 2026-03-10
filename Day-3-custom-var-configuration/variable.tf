variable "ami_id" {
    description = "The AMI ID for the AWS instance"
    type        = string 
}

variable "instance_type" {
    description = "The instance type for the AWS instance"
    type        = string 
}

variable "test_instance_type" {
    description = "The instance type for the AWS test instance"
    type        = string 
}   

variable "test_ami_id" {
    description = "The AMI ID for the AWS test instance"
    type        = string
}