terraform {
  backend "s3" {
    bucket = "ganesh-songala"
    key    = "terraform.tfstate"  //if also add folder like  Day-1/terraform.tfstate
    region = "us-east-1"
  }
}
