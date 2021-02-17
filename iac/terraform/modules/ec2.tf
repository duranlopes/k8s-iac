

resource "aws_instance" "master" {
  count         = var.instance_count_master
  ami           = var.aws_ami
  instance_type = var.instance_type_master
  key_name      = aws_key_pair.key_k8s.key_name
  subnet_id     = aws_subnet.k8s_network1.id
  tags = {
    Name = "master-${count.index}"
  }
  vpc_security_group_ids = [aws_security_group.security_k8s.id]
}

resource "aws_instance" "node" {
  count         = var.instance_count_node
  ami           = var.aws_ami
  instance_type = var.instance_type_node
  key_name      = aws_key_pair.key_k8s.key_name
  subnet_id     = aws_subnet.k8s_network1.id
  tags = {
    Name = "node-${count.index}"
  }

  vpc_security_group_ids = [aws_security_group.security_k8s.id]
}
