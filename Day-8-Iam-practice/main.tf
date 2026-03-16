resource "aws_iam_role" "admin_role" {
    name = "terraform-admin-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    # AWS = "arn:aws:iam::123456789012:root"
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "admin_attach" {
  role       = aws_iam_role.admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

}
    

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "terraform-ec2-profile"
  role = aws_iam_role.admin_role.name
}



resource "aws_instance" "test" {
    ami           = "ami-0c94855ba95c71c99"
    instance_type = "t2.micro"
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
    associate_public_ip_address = true
    tags = {
        Name = "Terraform-EC2-Instance"
    }
    

}