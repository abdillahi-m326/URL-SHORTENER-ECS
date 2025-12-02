output "certificate_arn" {
  description = "ARN of the issued/validated ACM certificate"
  value       = aws_acm_certificate.acm_cert.arn
}

output "certificate_domain_name" {
  description = "Primary domain name on the certificate"
  value       = aws_acm_certificate.acm_cert.domain_name
}

output "certificate_sans" {
  description = "Subject alternative names on the certificate"
  value       = aws_acm_certificate.acm_cert.subject_alternative_names
}

output "validation_record_fqdns" {
  description = "FQDNs of DNS validation records created"
  value       = [for r in aws_route53_record.acm_certificate_validation : r.fqdn]
}

output "hosted_zone_id" {
  description = "Hosted zone ID used for validation records"
  value       = local.hosted_zone_id
}
