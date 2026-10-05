resource "aws_lb" "httpd" {

  name = "httpd"

  load_balancer_type = "application"

  subnets = var.subnet_ids

  security_groups = [aws_security_group.ecs.id]
}

resource "aws_lb_target_group" "httpd" {

  name = "httpd"

  port = 80

  protocol = "HTTP"

  target_type = "ip"

  vpc_id = "vpc-012f50d45daa804ee"

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.httpd.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.httpd.arn
  }
}

