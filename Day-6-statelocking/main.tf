resource "aws_vpc" "dev_1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tf-State-locking-vpc"
  }
}

resource "aws_subnet" "dev_1" {
  vpc_id     = aws_vpc.dev_1.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "tf-State-locking-subnet"
  }
}

resource "aws_instance" "dev_2" {
  ami           = "ami-02dfbd4ff395f2a1b"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.dev_1.id
  tags = {
    Name = "resource-instance"
  }
  
}