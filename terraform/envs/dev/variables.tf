variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix for naming all resources"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support for VPC"
  type        = bool
  default     = true
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.32.0/20"]
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.16.0/20", "10.0.48.0/20"]
}

variable "tags" {
  description = "Global tags for all resources"
  type        = map(string)
  default = {
    Environment = "production"
    Owner       = "prod"
  }
}


############################
# ALB / Listener Settings
############################
variable "alb_internal" {
  type    = bool
  default = false
}

# If your alb module variable exists; otherwise keep module default
variable "test_listener_port" {
  type    = number
  default = 9000
}

############################
# ECS App
############################
variable "container_image" {
  type = string
}

# If you want this configurable; otherwise hardcode in root
variable "desired_count" {
  type    = number
  default = 2
}

############################
# CodeDeploy Names (optional but recommended)
############################
variable "codedeploy_app_name" {
  type    = string
  default = "url-shortener-codedeploy"
}

variable "codedeploy_group_name" {
  type    = string
  default = "url-shortener-group"
}
