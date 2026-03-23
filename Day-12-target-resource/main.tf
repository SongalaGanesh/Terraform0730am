provider "aws" {
  
}
resource "aws_instance" "target_instance" {
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = "t2.micro"
    tags = {
        Name = "Terraform-Target-Instance"
    }
  
}

resource "aws_s3_bucket" "s3" { 
    bucket = "terraform-target-resource-bucket"
  
}