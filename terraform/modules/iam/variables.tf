variable "name_prefix" {
  description = "Prefix for naming IAM roles"
  type        = string
}

variable "task_role_name" {
  description = "Explicit name for the ECS task role. If unset, derive from name_prefix in the module."
  type        = string
  default     = null
}

variable "execution_role_name" {
  description = "Explicit name for the ECS task execution role. If unset, derive from name_prefix in the module."
  type        = string
  default     = null
}

variable "task_assume_role_services" {
  description = "Principal services allowed to assume the ECS task role."
  type        = list(string)
  default     = ["ecs-tasks.amazonaws.com"]
}

variable "execution_assume_role_services" {
  description = "Principal services allowed to assume the ECS execution role."
  type        = list(string)
  default     = ["ecs-tasks.amazonaws.com"]
}

variable "task_managed_policy_arns" {
  description = "Managed policy ARNs to attach to the ECS task role"
  type        = list(string)
  default     = []
}

variable "execution_managed_policy_arns" {
  description = "Managed policy ARNs to attach to the ECS execution role."
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

variable "tags" {
  description = "Common tags applied to both roles."
  type        = map(string)
  default     = {}
}
