############################
# CloudWatch Logs for WAF
############################
resource "aws_cloudwatch_log_group" "waf_logs" {
  count             = var.enabled && var.enable_logging ? 1 : 0
  name              = "/aws/waf/${var.name_prefix}-web-acl"
  retention_in_days = 30

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-waf-logs"
  })
}

############################
# WAF Web ACL
############################
resource "aws_wafv2_web_acl" "waf_rules" {
  count       = var.enabled ? 1 : 0
  name        = "${var.name_prefix}-waf"
  description = "Managed WAF rules for ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "RateLimitPerIP"
    priority = 0

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = var.rate_limit
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitPerIP"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name_prefix}-web-acl"
    sampled_requests_enabled   = true
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-web-acl"
  })
}

############################
# WAF Logging Configuration
############################
resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  count        = var.enabled && var.enable_logging ? 1 : 0
  resource_arn = aws_wafv2_web_acl.waf_rules[0].arn

  log_destination_configs = [
    "${aws_cloudwatch_log_group.waf_logs[0].arn}:*"
  ]
}

############################
# Associate WAF with ALB
############################
resource "aws_wafv2_web_acl_association" "alb_association" {
  count        = var.enabled ? 1 : 0
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.waf_rules[0].arn
}
