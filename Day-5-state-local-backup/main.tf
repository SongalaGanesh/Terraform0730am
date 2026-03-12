resource "aws_vpc" "dev" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name="Ganesh-VPC"
    }
}

resource "aws_instance" "test" {
    ami =  "ami-02dfbd4ff395f2a1b"
    instance_type = "t2.micro"
    tags = {
      Name="test-aws_instance"
    }
}
