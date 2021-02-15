output "master_public_ip" {
  value = aws_instance.master[0].public_ip
}

output "master_private_ip" {
  value = aws_instance.master[0].private_ip
}

output "nodes_ip0" {
  value = aws_instance.node[0].public_ip
}


output "nodes_ip1" {
  value = aws_instance.node[1].public_ip
}

output "nodes_ips" {
  value = aws_instance.node.*.public_ip
}
