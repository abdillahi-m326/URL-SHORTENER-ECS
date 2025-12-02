data "aws_route53_zone" "selected" {
  count        = var.zone_id == null ? 1 : 0
  name         = var.zone_name
  private_zone = var.private_zone
}

locals {
  hosted_zone_id = var.zone_id != null ? var.zone_id : data.aws_route53_zone.selected[0].zone_id
}

resource "aws_acm_certificate" "acm_cert" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = var.validation_method

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm_certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.acm_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id         = local.hosted_zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = var.dns_record_ttl
  allow_overwrite = var.allow_overwrite
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.acm_cert.arn
  validation_record_fqdns = [for r in aws_route53_record.acm_certificate_validation : r.fqdn]
}
