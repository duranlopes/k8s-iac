variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string
  default     = "k8s-iac"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances. If empty, the latest Ubuntu 22.04 LTS AMI is resolved dynamically."
  type        = string
  default     = ""
}

variable "instance_type_master" {
  description = "EC2 instance type for Kubernetes control plane nodes."
  type        = string
  default     = "t3.large"
}

variable "instance_type_node" {
  description = "EC2 instance type for Kubernetes worker nodes."
  type        = string
  default     = "t3.large"
}

variable "instance_count_master" {
  description = "Number of control plane instances."
  type        = number
  default     = 1
}

variable "instance_count_node" {
  description = "Number of worker node instances."
  type        = number
  default     = 2
}

variable "public_key" {
  description = "SSH public key material used to create the EC2 key pair."
  type        = string
}

variable "public_cidr_block1" {
  description = "CIDR block for public subnet in AZ1."
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone1" {
  description = "Availability zone for subnet 1."
  type        = string
  default     = "us-east-1a"
}

variable "public_cidr_block2" {
  description = "CIDR block for public subnet in AZ2."
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone2" {
  description = "Availability zone for subnet 2."
  type        = string
  default     = "us-east-1b"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "ssh_ingress_cidrs" {
  description = "CIDR blocks allowed to SSH into instances. Restrict this in production."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
