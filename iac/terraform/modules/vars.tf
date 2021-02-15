variable "aws_ami" {
  default = "ami-026c8acd92718196b"
}

variable "instance_type_master" {
  #default = "t2.micro"
  default = "t2.large"
}

variable "instance_type_node" {
  #default = "t2.micro"
  default = "t2.large"
}

variable "instance_count_master" {
  default = 1
}

variable "instance_count_node" {
  default = 2
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_key_path" {
  description = "key_path"
  #default     = "./key/id_rsa.pub"
  default = "/home/duran/.ssh/id_rsa.pub"
}

variable "public_cidr_block" {
  default = "10.0.0.0/16"
}

variable "availability_zone" {
  default = "us-east-1a"
}
