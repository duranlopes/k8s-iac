resource "aws_instance" "master" {
  count = var.instance_count_master

  ami                    = local.ami_id
  instance_type          = var.instance_type_master
  key_name               = aws_key_pair.k8s.key_name
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.k8s.id]

  tags = {
    Name = "${var.project_name}-master-${count.index}"
    Role = "control-plane"
  }
}

resource "aws_instance" "node" {
  count = var.instance_count_node

  ami                    = local.ami_id
  instance_type          = var.instance_type_node
  key_name               = aws_key_pair.k8s.key_name
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.k8s.id]

  tags = {
    Name = "${var.project_name}-node-${count.index}"
    Role = "worker"
  }
}
