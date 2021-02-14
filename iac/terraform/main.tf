provider "aws" {
  region  = "us-east-1"
  profile = "particular"
}

## tf bucket = terraform-state-duran

#terraform {
#  backend "s3" {
#    bucket  = "terraform-state-duran"
#    key     = "terraform.tfstate"
#    region  = "us-east-1"
#    profile = "particular"
#  }
#}

module "ec2" {
  source = "./modules"
}

