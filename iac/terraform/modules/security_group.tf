resource "aws_security_group" "security_k8s" {
  name        = "security_k8s"
  description = "Cluster k8s"
  vpc_id      = aws_vpc.vpc_k8s.id

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "30000"
    to_port     = "32767"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "6443"
    to_port     = "6443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ping"
    from_port   = -1
    protocol    = "icmp"
    to_port     = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Security Group K8s"
  }
}

resource "aws_security_group_rule" "allow_all" {
  type              = "ingress"
  to_port           = 0
  protocol          = "-1"
  source_security_group_id   = aws_security_group.security_k8s.id
  from_port         = 0
  security_group_id = aws_security_group.security_k8s.id
}