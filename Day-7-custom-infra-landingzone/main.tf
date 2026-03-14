resource "aws_vpc" "Ganesh_VPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Ganesh_VPC"
  }
}

resource "aws_subnet" "Public_Subnet" {
  vpc_id            = aws_vpc.Ganesh_VPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Public_Subnet"
  }
}

resource "aws_subnet" "Private_Subnet" {
  vpc_id            = aws_vpc.Ganesh_VPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Private_Subnet"
  }
}

resource "aws_internet_gateway" "Ganesh_IGW" {
  vpc_id = aws_vpc.Ganesh_VPC.id
  tags = {
    Name = "Ganesh_IGW"
  }
}

resource "aws_eip" "Nat_EIP" {
  domain = "vpc"

  tags = {
    Name = "Nat_EIP"
  }
}

resource "aws_nat_gateway" "Nat_Gateway" {
  allocation_id = aws_eip.Nat_EIP.id
  subnet_id     = aws_subnet.Public_Subnet.id

  tags = {
    Name = "Ganesh_NAT_Gateway"
  }
  depends_on = [aws_internet_gateway.Ganesh_IGW]
}

resource "aws_route_table" "Public_Route_Table" {
  vpc_id = aws_vpc.Ganesh_VPC.id
  tags = {      
    Name = "Public_Route_Table"
  } 
}

resource "aws_route" "Public_Route" {
  route_table_id         = aws_route_table.Public_Route_Table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Ganesh_IGW.id
}

resource "aws_route_table_association" "Public_Subnet_Association" {
  subnet_id      = aws_subnet.Public_Subnet.id
  route_table_id = aws_route_table.Public_Route_Table.id
}

resource "aws_security_group" "SG" {
  name        = "Ganesh_SG"
  description = "Security group for ec2"
  vpc_id      = aws_vpc.Ganesh_VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Basion_Host" {
  ami           = "ami-02dfbd4ff395f2a1b"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.Public_Subnet.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.SG.id]
  tags = {
    Name = "Basion_Host"
  }
}



