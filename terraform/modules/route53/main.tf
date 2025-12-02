data "aws_route53_zone" "primary" {
  count        = var.zone_id == null ? 1 : 0
  name         = var.zone_name
  private_zone = var.private_zone
}

locals {
  hosted_zone_id = var.zone_id != null ? var.zone_id : data.aws_route53_zone.primary[0].zone_id
}

resource "aws_route53_record" "root" {
  count   = var.enable_root_record ? 1 : 0
  zone_id = local.hosted_zone_id
  name    = var.root_record_name != "" ? var.root_record_name : var.zone_name
  type    = "A"

  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}

resource "aws_route53_record" "www" {
  count   = var.enable_www_record ? 1 : 0
  zone_id = local.hosted_zone_id
  name    = var.www_record_name
  type    = "A"

  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}
