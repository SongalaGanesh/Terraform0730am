provider "aws" {
    profile = "default"
    region = "us-east-1"  
}

provider "aws" {
    alias = "devenv"
    region = "us-west-2"
    profile = "dev"
}