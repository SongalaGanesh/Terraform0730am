module "dev" {
    source = "../Day-10-Modules-2"
    ami_id = "ami-02dfbd4ff395f2a1b"
    instance_type = "t2.micro"
    subnet_id = "subnet-06160e6a7fa4a5e15"
}