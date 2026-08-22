resource "aws_security_group" "k8s" {
  name        = "${var.project_name}-sg"
  description = "Security group for the Kubernetes cluster"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.k8s.id
  description       = "SSH"
  cidr_ipv4         = var.ssh_ingress_cidrs[0]
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.k8s.id
  description       = "HTTP"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.k8s.id
  description       = "HTTPS"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "kube_apiserver" {
  security_group_id = aws_security_group.k8s.id
  description       = "Kubernetes API server"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 6443
  to_port           = 6443
}

resource "aws_vpc_security_group_ingress_rule" "nodeport" {
  security_group_id = aws_security_group.k8s.id
  description       = "NodePort range"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 30000
  to_port           = 32767
}

resource "aws_vpc_security_group_ingress_rule" "icmp" {
  security_group_id = aws_security_group.k8s.id
  description       = "ICMP ping"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "icmp"
  from_port         = -1
  to_port           = -1
}

resource "aws_vpc_security_group_ingress_rule" "self_all" {
  security_group_id            = aws_security_group.k8s.id
  description                  = "Allow all traffic within the group (cluster internals)"
  referenced_security_group_id = aws_security_group.k8s.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.k8s.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
