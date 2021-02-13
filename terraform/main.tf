provider "aws" {
  region = "us-east-1"
  profile = "particular"
}

module "vpc" {
  source             = "./modules"
#  environment        = "production"
#  availability_zones = ["us-east-1a"]
#  ami                = "ami-00a9d4a05375b2763"
#  instance_type      = "t2.nano"
}