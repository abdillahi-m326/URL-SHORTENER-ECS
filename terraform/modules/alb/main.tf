resource "aws_lb" "load_balancer" {
  name               = "${var.name_prefix}-alb"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-alb" }
  )
}

resource "aws_lb_listener" "http_redirect" {
  count             = var.http_enabled && var.redirect_http_to_https ? 1 : 0
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = tostring(var.https_port)
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "http_forward" {
  count             = var.http_enabled && !var.redirect_http_to_https ? 1 : 0
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.http_forward_target_group_arn
  }
}

resource "aws_lb_listener" "https" {
  count             = var.https_enabled ? 1 : 0
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.https_port
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = var.https_forward_target_group_arn
  }
}
