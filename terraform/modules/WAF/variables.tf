variable "alb_arn" {
  description = "ARN of the ALB to associate this Web ACL with"
  type        = string
}

variable "name_prefix" {
  description = "Name prefix for environment-specific resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to WAF resources"
  type        = map(string)
  default     = {}
}

variable "enabled" {
  type    = bool
  default = true
}

variable "rate_limit" {
  type    = number
  default = 10000
}

variable "enable_logging" {
  type    = bool
  default = false
}
