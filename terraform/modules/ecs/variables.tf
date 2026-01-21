variable "name_prefix" {
  description = "Name prefix for tagging resources"
  type        = string
}

variable "aws_region" {
  description = "AWS region for logs"
  type        = string
}

variable "cluster_name" {
  description = "Name of ECS cluster"
  type        = string
  default     = "url_shortener_app_cluster"
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "url_shortener_ecs_service"
}

variable "desired_count" {
  description = "Number of running tasks"
  type        = number
  default     = 2
}

variable "subnet_ids" {
  description = "List of PRIVATE subnet IDs for ECS tasks"
  type        = list(string)
}

variable "tasks_security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "target_group_blue_arn" {
  description = "ARN of the BLUE target group (initial attachment)"
  type        = string
}

variable "task_family" {
  description = "ECS task definition family name"
  type        = string
  default     = "ecs_task_family"
}

variable "task_cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 1024
}

variable "task_memory" {
  description = "Memory for the task (in MiB)"
  type        = number
  default     = 2048
}

variable "container_name" {
  description = "Name of the application container"
  type        = string
}

variable "container_port" {
  description = "Container port exposed"
  type        = number
}

variable "container_image" {
  description = "Full container image URI (Docker Hub or ECR)"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "Execution role ARN for ECS tasks to pull images/logs"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}
