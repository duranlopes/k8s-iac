resource "local_file" "master_ip" {
  count    = var.instance_count_master
  content  = aws_instance.master[count.index].public_ip
  filename = "../address/ip-master${count.index}"
}

resource "local_file" "node_ip" {
  count    = var.instance_count_node
  content  = aws_instance.node[count.index].public_ip
  filename = "../address/ip-node${count.index}"
}
