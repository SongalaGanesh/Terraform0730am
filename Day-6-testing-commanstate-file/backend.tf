terraform {
  backend "s3" {
    bucket = "ganesh-songala"
    key    = "day-6/terraform.tfstate"  //good practice to add folder name also
    region = "us-east-1"
  }
}

#if we use common s3 path for two diff directories you may destory or modify existing resources