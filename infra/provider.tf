terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.33.0"
    }
  }
}
terraform {
  backend "s3" {
    bucket = "qzee-demo-xyz"
    key    = "env/default/terraform.tfstate"   # new key path
    region = "us-east-1"
    dynamodb_table = "terraform_lock"
  }
  	
}


provider "aws" {
  region = "us-east-1"
}
