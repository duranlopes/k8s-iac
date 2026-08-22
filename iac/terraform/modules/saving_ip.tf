resource "local_file" "master_public_ip" {
  count    = var.instance_count_master
  content  = aws_instance.master[count.index].public_ip
  filename = "${path.module}/../address/master-public${count.index}"
}

resource "local_file" "master_private_ip" {
  count    = var.instance_count_master
  content  = aws_instance.master[count.index].private_ip
  filename = "${path.module}/../address/master-private${count.index}"
}

resource "local_file" "node_public_ip" {
  count    = var.instance_count_node
  content  = aws_instance.node[count.index].public_ip
  filename = "${path.module}/../address/node${count.index}"
}
