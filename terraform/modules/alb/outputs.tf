output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.load_balancer.arn
}

output "alb_id" {
  description = "ID of the ALB"
  value       = aws_lb.load_balancer.id
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.load_balancer.dns_name
}

output "alb_zone_id" {
  description = "Route53 hosted zone ID to use for ALIAS records"
  value       = aws_lb.load_balancer.zone_id
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener"
  value       = try(aws_lb_listener.http_redirect[0].arn, aws_lb_listener.http_forward[0].arn, null)
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = try(aws_lb_listener.https[0].arn, null)
}
