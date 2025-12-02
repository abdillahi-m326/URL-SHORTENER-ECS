variable "name_prefix" {
  description = "Prefix for naming"
  type        = string
}

variable "security_group_ids" {
  description = "Security groups to attach to the ALB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Subnets for the ALB"
  type        = list(string)
}

variable "internal" {
  description = "Whether the ALB is internal"
  type        = bool
  default     = false
}

variable "load_balancer_type" {
  description = "LB type"
  type        = string
  default     = "application"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "http_enabled" {
  description = "Create HTTP listener"
  type        = bool
  default     = true
}

variable "http_port" {
  description = "HTTP port"
  type        = number
  default     = 80
}

variable "redirect_http_to_https" {
  description = "If true, HTTP listener redirects to HTTPS"
  type        = bool
  default     = true
}

variable "http_forward_target_group_arn" {
  description = "If redirect is false, HTTP listener will forward to this TG ARN"
  type        = string
  default     = null
}
variable "https_enabled" {
  description = "Create HTTPS listener"
  type        = bool
  default     = true
}

variable "https_port" {
  description = "HTTPS port"
  type        = number
  default     = 443
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS"
  type        = string
  default     = null
}

variable "https_forward_target_group_arn" {
  description = "Target group ARN for HTTPS default action"
  type        = string
  default     = null
}
