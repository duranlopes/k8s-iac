resource "aws_vpc" "vpc_k8s" {
  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  tags = {
    Name = "VPC Cluster k8s"
  }
}
