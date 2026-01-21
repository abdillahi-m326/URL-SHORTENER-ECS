output "web_acl_arn" {
  value = var.enabled ? aws_wafv2_web_acl.waf_rules[0].arn : null
}

