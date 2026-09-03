module "k8s_cluster" {
  source = "./modules"

  project_name          = var.project_name
  ami_id                = var.ami_id
  instance_type_master  = var.instance_type_master
  instance_type_node    = var.instance_type_node
  instance_count_master = var.instance_count_master
  instance_count_node   = var.instance_count_node
  public_key            = var.public_key
}

variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string
  default     = "k8s-iac"
}

variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID override. Empty resolves latest Ubuntu 22.04 LTS."
  type        = string
  default     = ""
}

variable "instance_type_master" {
  description = "Control plane instance type."
  type        = string
  default     = "t3.large"
}

variable "instance_type_node" {
  description = "Worker node instance type."
  type        = string
  default     = "t3.large"
}

variable "instance_count_master" {
  description = "Number of control plane instances."
  type        = number
  default     = 1
}

variable "instance_count_node" {
  description = "Number of worker instances."
  type        = number
  default     = 2
}

variable "public_key" {
  description = "SSH public key material for the EC2 key pair."
  type        = string
}

terraform {
  required_version = ">= 1.16.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = var.project_name
      ManagedBy = "terraform"
    }
  }
}

output "master_public_ips" {
  description = "Public IPs of the control plane instances."
  value       = module.k8s_cluster.master_public_ips
}

output "node_public_ips" {
  value = module.k8s_cluster.node_public_ips
}

output "load_balancer_dns" {
  value = module.k8s_cluster.load_balancer_dns
}
