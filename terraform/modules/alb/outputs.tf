output "alb_arn" {
  value = aws_lb.load_balancer.arn
}

output "prod_listener_arn" {
  value = var.https_enabled ? aws_lb_listener.https[0].arn : aws_lb_listener.http_forward[0].arn
}

output "test_listener_arn" {
  value = var.test_listener_enabled ? aws_lb_listener.test[0].arn : null
}

output "alb_dns_name" {
  value = aws_lb.load_balancer.dns_name
}

output "alb_zone_id" {
  value = aws_lb.load_balancer.zone_id
}
