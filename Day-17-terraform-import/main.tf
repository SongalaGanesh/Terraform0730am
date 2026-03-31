#importing the existing ec2 instance to terraform state file
resource "aws_instance" "name" {
    ami = "ami-0c3389a4fa5bddaad"
    instance_type = "t2.micro"
    tags = {
        Name = "test"
    }   
  
}
#importing the existing s3 bucket to terraform state file
resource "aws_s3_bucket" "name" {
    bucket = "tfxdtxwxywxwqx"
}
resource "aws_s3_bucket_versioning" "name" {
    bucket = aws_s3_bucket.name.id
    versioning_configuration {
        status = "Suspended"
    }
  
}