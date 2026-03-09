resource "aws_instance" "dev" {
    ami           = var.ami_id
    instance_type = var.instance_type
    tags = {
        Name = "dev-instance"
    }
}

resource "aws_instance" "test" {
    ami           = var.ami_id
    instance_type = var.test_instance_type
    tags = {
        Name = "test-instance"
    }
}