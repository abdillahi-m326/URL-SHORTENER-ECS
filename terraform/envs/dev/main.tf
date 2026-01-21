module "vpc" {
  source = "../../modules/vpc"

  name_prefix          = var.name_prefix
  vpc_cidr             = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = var.tags
}

# ALB SG
module "alb_securitygroup" {
  source      = "../../modules/securitygroup"
  name_prefix = "${var.name_prefix}-alb"
  vpc_id      = module.vpc.vpc_id
  description = "ALB security group"
  tags        = var.tags

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS"
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "All outbound"
    }
  ]
}

# Tasks SG (VPC-only ingress on app port)
module "tasks_securitygroup" {
  source      = "../../modules/securitygroup"
  name_prefix = "${var.name_prefix}-tasks"
  vpc_id      = module.vpc.vpc_id
  description = "ECS tasks security group"
  tags        = var.tags

  ingress_rules = [
    {
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr]
      description = "App traffic from within VPC (ALB to tasks)"
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "All outbound"
    }
  ]
}

module "iam" {
  source      = "../../modules/iam"
  name_prefix = var.name_prefix
  tags        = var.tags

  task_managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ]

  enable_dynamodb_policy = false
}


module "targetgroup" {
  source      = "../../modules/targetgroup"
  name_prefix = var.name_prefix
  vpc_id      = module.vpc.vpc_id
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  tags        = var.tags
}

module "alb" {
  source = "../../modules/alb"

  name_prefix        = var.name_prefix
  internal           = false
  load_balancer_type = "application"

  security_group_ids = [module.alb_securitygroup.security_group_id]
  subnet_ids         = module.vpc.public_subnet_ids
  tags               = var.tags

  http_enabled           = true
  https_enabled          = false
  redirect_http_to_https = false

  http_port = 80

  target_group_blue_arn  = module.targetgroup.blue_arn
  target_group_green_arn = module.targetgroup.green_arn

  test_listener_enabled = false
  test_listener_port    = 9000
}

resource "aws_cloudwatch_log_group" "ecs_app" {
  name              = "/ecs/url_shortener_app"
  retention_in_days = 7

  tags = {
    Name        = "${var.name_prefix}-url-shortener-app-logs"
    Environment = var.tags["Environment"]
  }
}

module "ecs" {
  source = "../../modules/ecs"

  name_prefix = var.name_prefix
  aws_region  = var.aws_region

  cluster_name     = "url_shortener_cluster"
  ecs_service_name = "url_shortener_ecs_service"
  desired_count    = 2

  subnet_ids              = module.vpc.private_subnet_ids
  tasks_security_group_id = module.tasks_securitygroup.security_group_id


  target_group_blue_arn = module.targetgroup.blue_arn

  task_family    = "url_shortener_task"
  task_cpu       = 1024
  task_memory    = 2048
  container_name = "url_shortener"
  container_port = 8000

  container_image             = "210678020643.dkr.ecr.us-east-1.amazonaws.com/url_shortener_app:latest"
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  log_group_name              = "/ecs/url_shortener_app"

  depends_on = [module.alb, aws_cloudwatch_log_group.ecs_app]
}
/*
module "codedeploy" {
  source = "../../modules/codedeploy"

  codedeploy_app_name         = "url-shortener-codedeploy"
  deployment_group_name       = "url-shortener-group"
  codedeploy_service_role_arn = module.iam.codedeploy_role_arn

  ecs_cluster_name = module.ecs.cluster_name
  ecs_service_name = module.ecs.service_name

  prod_listener_arn = module.alb.prod_listener_arn
  test_listener_arn = module.alb.test_listener_arn

  target_group_blue_name  = module.targetgroup.blue_name
  target_group_green_name = module.targetgroup.green_name
}
**/

module "waf" {
  source = "../../modules/WAF"

  enabled        = true
  rate_limit     = 10000
  enable_logging = false

  alb_arn     = module.alb.alb_arn
  name_prefix = var.name_prefix
  tags        = var.tags
}


