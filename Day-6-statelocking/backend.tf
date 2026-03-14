terraform {
    backend "s3" {
        bucket = "ganesh-songala"
        key    = "terraform.tfstate"  //if also add folder like  Day-1/terraform.tfstate
        region = "us-east-1"
        use_state_locking = true  //by default it is true, if you want to disable it you can set it to false
    }
}