resource "aws_vpc" "ganesh" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "ganesh-vpc"
    }
  
}

resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.ganesh.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "ganesh-public-subnet"
    }
}

resource "aws_instance" "state-lock-test-wth-dynamodb" {
  ami           = "ami-0c94855ba95c71c99" // Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"
  tags = {
    Name="test-with-dynamodb"
  }

  
}