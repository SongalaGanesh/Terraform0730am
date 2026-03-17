module "ganesh" {
  source = "../Day-2-Terraform-all-config-files"
  ami_id = "ami-02dfbd4ff395f2a1b"
  instance_type = "t3.micro"
  test_instance_type = "t3.nano"
}