############################
# Application Load Balancer
############################

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

############################
# HTTP → HTTPS Redirect
############################

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

############################
# HTTP Forward (no redirect)
# (optional prod listener)
############################

resource "aws_lb_listener" "http_forward" {
  count             = var.http_enabled && !var.redirect_http_to_https ? 1 : 0
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.http_port
  protocol          = "HTTP"
  /**
  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = var.target_group_blue_arn
        weight = 1
      }
      target_group {
        arn    = var.target_group_green_arn
        weight = 0
      }
    }
  }

  lifecycle {
    # CodeDeploy will modify weights during deployments
    ignore_changes = [default_action]
  }
  **/
  default_action {
    type             = "forward"
    target_group_arn = var.target_group_blue_arn
  }
}

############################
# HTTPS Prod Listener
############################

resource "aws_lb_listener" "https" {
  count             = var.https_enabled ? 1 : 0
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.https_port
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn
  /**
  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = var.target_group_blue_arn
        weight = 1
      }
      target_group {
        arn    = var.target_group_green_arn
        weight = 0
      }
    }
  }

  

  lifecycle {
    # Prevent Terraform fighting CodeDeploy traffic shifts
    ignore_changes = [default_action]
  }
  **/

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_blue_arn
  }

}

############################
# TEST Listener (CodeDeploy)
############################

resource "aws_lb_listener" "test" {
  count             = var.test_listener_enabled ? 1 : 0
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.test_listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_green_arn
  }
}
