#Vpc variables
cidr_block = "10.0.0.0/16"
subnet_1_cidr = "10.0.1.0/24"
subnet_2_cidr = "10.0.2.0/24"
az1 = "us-east-1a"
az2 = "us-east-1b"


# ec2 variables
ami_id = "ami-02dfbd4ff395f2a1b"
instance_type = "t3.micro"
instance_name = "advanced-ec2"

security_group_ids = ["sg-0bb675fe819d9b995"]
key_name           = "lin_key"
iam_instance_profile = "Iam-Role"
root_volume_size = 20


# RDS variables
db_username  = "ganesh"
db_name = "mysource-db"
db_password = "Ganesh@123"
db_instance_class = "db.t3.micro"



