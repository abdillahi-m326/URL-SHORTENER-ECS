resource "aws_lb_target_group" "blue" {
  name        = "${var.name_prefix}-tg-blue"
  target_type = var.target_type
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.name_prefix}-tg-blue" })
}

resource "aws_lb_target_group" "green" {
  name        = "${var.name_prefix}-tg-green"
  target_type = var.target_type
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.name_prefix}-tg-green" })
}
