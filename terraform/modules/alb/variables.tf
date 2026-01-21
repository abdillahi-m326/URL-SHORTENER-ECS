variable "name_prefix" {}
variable "security_group_ids" { type = list(string) }
variable "subnet_ids" { type = list(string) }
variable "tags" { type = map(string) }

variable "http_enabled" { type = bool }
variable "https_enabled" { type = bool }
variable "redirect_http_to_https" { type = bool }

variable "http_port" {
  type    = number
  default = 80
}

variable "https_port" {
  type    = number
  default = 443
}

variable "certificate_arn" {
  type    = string
  default = null
}

variable "target_group_blue_arn" { type = string }
variable "target_group_green_arn" { type = string }

variable "test_listener_enabled" {
  type    = bool
  default = true
}

variable "test_listener_port" {
  type    = number
  default = 9000
}

variable "internal" {
  type    = bool
  default = false
}

variable "load_balancer_type" {
  type    = string
  default = "application"
}

variable "ssl_policy" {
  type    = string
  default = null
}
