resource "aws_key_pair" "key_k8s" {
  key_name   = "key_k8s"
  public_key = file(var.aws_key_path)
}

