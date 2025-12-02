output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.TG.arn
}

output "target_group_name" {
  description = "Name of the target group"
  value       = aws_lb_target_group.TG.name
}

output "target_group_id" {
  description = "ID of the target group"
  value       = aws_lb_target_group.TG.id
}
