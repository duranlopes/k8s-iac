output "master_public_ips" {
  description = "Public IPs of the control plane instances."
  value       = aws_instance.master[*].public_ip
}

output "master_private_ips" {
  description = "Private IPs of the control plane instances."
  value       = aws_instance.master[*].private_ip
}

output "node_public_ips" {
  description = "Public IPs of the worker nodes."
  value       = aws_instance.node[*].public_ip
}

output "load_balancer_dns" {
  description = "DNS name of the application load balancer."
  value       = aws_lb.k8s.dns_name
}
