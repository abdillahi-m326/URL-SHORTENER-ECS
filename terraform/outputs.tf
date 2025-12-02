output "vpc_id" {
  description = "VPC ID from the VPC module"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs from the VPC module"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs from the VPC module"
  value       = module.vpc.private_subnet_ids
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "domain_name" {
  value = "ecsprojectv1am.click"
}

output "ecs_cluster_id" {
  value = module.ecs.cluster_id
}

output "ecs_service_name" {
  value = module.ecs.service_name
}
