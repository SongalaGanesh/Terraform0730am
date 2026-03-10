resource "aws_instance" "dev" {
    ami = var.ami_id    
    instance_type = var.instance_type
    tags = {
        Name = "dev-instance"
    }
}

resource "aws_vpc" "test_vpc" {
    provider = aws.devenv
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "test-vpc"
    }
}

resource "aws_subnet" "test_subnet" {
  provider          = aws.devenv
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "test-subnet"
  }
}

resource "aws_instance" "test" {
    ami = var.test_ami_id
    instance_type = var.test_instance_type
    provider = aws.devenv
    subnet_id     = aws_subnet.test_subnet.id
        tags = {
        Name = "test-instance"
    }
}