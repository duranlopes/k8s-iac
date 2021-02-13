variable "aws_ami" {
  default = "ami-026c8acd92718196b"
}

variable "instance_type_master" {
  default = "t2.micro"
}

variable "instance_type_node" {
  default = "t2.micro"
}

variable "instance_count_master" {
  default = 1
}

variable "instance_count_node" {
  default = 1
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_key_path" {
  description = "key_path"
  default     = "./key/id_rsa.pub"
}