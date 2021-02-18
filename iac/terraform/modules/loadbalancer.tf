resource "aws_lb" "k8s-iac" {
  name               = "lb-k8s-iac"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_k8s.id]
  subnets            = [aws_subnet.k8s_network1.id, aws_subnet.k8s_network2.id]

  enable_deletion_protection = false

  tags = {
    Environment = "k8s"
  }
}

resource "aws_lb_target_group" "target-vpc" {
  name     = "lb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_k8s.id
}

resource "aws_lb_listener" "api-listener" {
  load_balancer_arn = aws_lb.k8s-iac.arn
  port              = "80"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-vpc.arn
  }
}

resource "aws_lb_target_group_attachment" "target-vpc-ec2" {
  count            = var.instance_count_node
  target_group_arn = aws_lb_target_group.target-vpc.arn
  target_id        = aws_instance.node[count.index].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "target-vpc-ec2-master" {
  count            = var.instance_count_master
  target_group_arn = aws_lb_target_group.target-vpc.arn
  target_id        = aws_instance.master[count.index].id
  port             = 80
}
