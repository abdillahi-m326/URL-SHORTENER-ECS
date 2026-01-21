# Task role
output "ecs_task_role_name" {
  description = "Name of the ECS task IAM role."
  value       = aws_iam_role.ecs_task_role.name
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS task IAM role."
  value       = aws_iam_role.ecs_task_role.arn
}

output "ecs_task_role_id" {
  description = "ID of the ECS task IAM role."
  value       = aws_iam_role.ecs_task_role.id
}

# Execution role
output "ecs_task_execution_role_name" {
  description = "Name of the ECS task execution IAM role."
  value       = aws_iam_role.ecs_task_execution_role.name
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution IAM role."
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_execution_role_id" {
  description = "ID of the ECS task execution IAM role."
  value       = aws_iam_role.ecs_task_execution_role.id
}

output "codedeploy_role_arn" {
  value = aws_iam_role.codedeploy_role.arn
}
