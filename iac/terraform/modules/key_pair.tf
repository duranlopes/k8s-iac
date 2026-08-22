resource "aws_key_pair" "k8s" {
  key_name   = "${var.project_name}-key"
  public_key = var.public_key
}
