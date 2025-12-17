resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "/aws/waf/web-acl"
  retention_in_days = 30

  tags = {
    Environment = "Production"
    Name        = "waf-logs"
  }
}

resource "aws_wafv2_web_acl" "waf_rules" {
  name        = "waf_rules"
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
        limit              = 10000
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
    metric_name                = "WebACL"
    sampled_requests_enabled   = true
  }

  tags = {
    Environment = "Production"
    Name        = "webACL"
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  resource_arn = aws_wafv2_web_acl.waf_rules.arn

  log_destination_configs = [
    aws_cloudwatch_log_group.waf_logs.arn
  ]
}

resource "aws_wafv2_web_acl_association" "alb_association" {
  resource_arn = aws_alb.load_balancer.arn
  web_acl_arn  = aws_wafv2_web_acl.waf_rules.arn
}
