resource "aws_lb" "k8s" {
  name               = "${var.project_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.k8s.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-lb"
  }
}

resource "aws_lb_target_group" "nodes" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.k8s.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nodes.arn
  }
}

resource "aws_lb_target_group_attachment" "nodes" {
  count            = var.instance_count_node
  target_group_arn = aws_lb_target_group.nodes.arn
  target_id        = aws_instance.node[count.index].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "masters" {
  count            = var.instance_count_master
  target_group_arn = aws_lb_target_group.nodes.arn
  target_id        = aws_instance.master[count.index].id
  port             = 80
}
