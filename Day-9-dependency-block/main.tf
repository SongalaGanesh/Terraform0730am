resource "aws_security_group" "ec2-sg" {
  name        = "ec2_security_group"
  description = "Security group for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2-instance" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  depends_on    = [aws_security_group.ec2-sg, aws_iam_instance_profile.ec2_instance_profile]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  associate_public_ip_address = true
  tags = {
    Name = "Terraform-EC2-Instance"
  }

}

resource "aws_iam_policy" "S3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Policy to allow access to S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

}

resource "aws_iam_policy_attachment" "policy_attach" {
  name       = "attach_policy_to_role"
  policy_arn = aws_iam_policy.S3_access_policy.arn
  roles      = [aws_iam_role.ec2_role.name]
  depends_on = [ aws_iam_role.ec2_role,aws_iam_policy.S3_access_policy ]
  
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
  depends_on = [ aws_iam_policy_attachment.policy_attach ]
}
