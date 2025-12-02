variable "name_prefix" {
  description = "Prefix name"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the target group will be created"
  type        = string
}

variable "port" {
  description = "Port on which targets receive traffic"
  type        = number
  default     = 80
}

variable "protocol" {
  description = "Protocol to use for routing traffic to the targets"
  type        = string
  default     = "HTTP"
}

variable "target_type" {
  description = "Type of target to register"
  type        = string
  default     = "ip"
}

variable "tags" {
  description = "Additional tags to apply to the target group"
  type        = map(string)
  default     = {}
}
