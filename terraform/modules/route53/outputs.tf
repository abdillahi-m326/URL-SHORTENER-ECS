output "hosted_zone_id" {
  description = "The hosted zone ID used for records."
  value       = local.hosted_zone_id
}

output "root_record_fqdn" {
  description = "FQDN of the root/apex record"
  value       = try(aws_route53_record.root[0].fqdn, null)
}

output "www_record_fqdn" {
  description = "FQDN of the www record"
  value       = try(aws_route53_record.www[0].fqdn, null)
}
