variable "domain_name" {
  description = "Primary domain name for the ACM certificate"
  type        = string
}

variable "subject_alternative_names" {
  description = "SANs for the certificate"
  type        = list(string)
  default     = []
}

variable "validation_method" {
  description = "Validation method for ACM"
  type        = string
  default     = "DNS"
}

variable "zone_id" {
  description = "Hosted Zone ID for DNS validation records. If null, the zone will be looked up by zone_name/private_zone."
  type        = string
  default     = null
}

variable "zone_name" {
  description = "Hosted zone name for lookup when zone_id is null"
  type        = string
  default     = null
}

variable "private_zone" {
  description = "Whether the hosted zone is private"
  type        = bool
  default     = false
}

variable "dns_record_ttl" {
  description = "TTL in seconds for the DNS validation records"
  type        = number
  default     = 60
}

variable "allow_overwrite" {
  description = "Allow overwriting DNS validation records in the hosted zone"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the ACM certificate"
  type        = map(string)
  default     = {}
}
