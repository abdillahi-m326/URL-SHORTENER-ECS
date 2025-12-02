variable "zone_name" {
  description = "Public hosted zone name"
  type        = string
}

variable "zone_id" {
  description = "Hosted Zone ID"
  type        = string
  default     = null
}

variable "private_zone" {
  description = "Whether the hosted zone is private"
  type        = bool
  default     = false
}

variable "alias_name" {
  description = "Alias target DNS name"
  type        = string
}

variable "alias_zone_id" {
  description = "Alias target hosted zone ID"
  type        = string
}

variable "enable_root_record" {
  description = "Create an apex/root A record"
  type        = bool
  default     = true
}

variable "root_record_name" {
  description = "Name for apex record"
  type        = string
  default     = ""
}

variable "enable_www_record" {
  description = "Create a www A record"
  type        = bool
  default     = true
}

variable "www_record_name" {
  description = "Record name for www"
  type        = string
  default     = "www"
}

variable "evaluate_target_health" {
  description = "Whether to evaluate target health on alias records"
  type        = bool
  default     = true
}
