resource "aws_instance" "ec2" {
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = "t2.micro"
    lifecycle {
        create_before_destroy = true
    }
    tags = {
        Name = "Terraform-EC2-1"
    }
}


resource "aws_instance" "ec2-2" {
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = "t2.micro"
    lifecycle {
        ignore_changes = [ tags ]
    }
    tags = {
        Name = "Terraform-EC2-2"
    }
  
}

resource "aws_instance" "ec2-3" {
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = "t2.micro"
    lifecycle {
        prevent_destroy = true
    }
    tags = {
        Name = "Terraform-EC2-3"
    }
  
}

resource "aws_instance" "Ganesh" {
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = "t2.micro"
    lifecycle {
        replace_triggered_by = [ aws_instance.ec2 ]
    }
    tags = {
        Name = "Terraform-Ganesh"
    }
  
}





