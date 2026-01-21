variable "codedeploy_app_name" {
  type        = string
  description = "Name of the CodeDeploy application"
}

variable "deployment_group_name" {
  type        = string
  description = "Name of the CodeDeploy deployment group"
}

variable "codedeploy_service_role_arn" {
  type        = string
  description = "IAM role ARN assumed by CodeDeploy (AWSCodeDeployRoleForECS)"
}

variable "ecs_cluster_name" {
  type        = string
  description = "ECS cluster name"
}

variable "ecs_service_name" {
  type        = string
  description = "ECS service name"
}

variable "prod_listener_arn" {
  type        = string
  description = "ALB production listener ARN"
}

variable "test_listener_arn" {
  type        = string
  description = "ALB test listener ARN"
}

variable "target_group_blue_name" {
  type        = string
  description = "Blue target group name"
}

variable "target_group_green_name" {
  type        = string
  description = "Green target group name"
}
