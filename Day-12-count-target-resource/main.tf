provider "aws" {
  
}

variable "dev" {
    type = bool
    default = false
}

variable "instance-type" {
    type = string
    default = "t2.micro"
}


data "aws_ami" "amazon_linux" {
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["amazon"]
}

data "aws_vpc" "default_vpc" {
    default = true
}

data "aws_security_group" "default_sg" {
    name = "default"
    vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_instance" "name" {
    ami           = "ami-02dfbd4ff395f2a1b"
    instance_type = "t2.micro"
    count = var.dev ? 1 : 0
    #if dev is true then create 1 instance if false then create 0 instance
    
  
}

resource "aws_instance" "ec2_data_source" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = var.instance-type
    depends_on = [data.aws_security_group.default_sg]
    tags = {
        Name = "Terraform-EC2-Data-Source"
    }
     count = var.dev ? 1 : 0
  
}