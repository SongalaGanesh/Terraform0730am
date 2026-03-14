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
