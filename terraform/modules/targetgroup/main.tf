resource "aws_lb_target_group" "TG" {
  name        = "TG"
  target_type = var.target_type
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-target-group"
    }
  )
}
