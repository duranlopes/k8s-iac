provider "aws" {
  region     = "us-east-1"
  profile    = "particular"
  #access_key = var.AWS_ACCESS_KEY_ID
  #secret_key = var.AWS_SECRET_ACCESS_KEY

}

terraform {
  backend "s3" {
    bucket  = "terraform-state-duran"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    profile = "particular"
  }
}

module "ec2" {
  source = "./modules"
}

