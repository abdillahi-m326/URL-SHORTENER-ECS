locals {
  task_role_name      = coalesce(var.task_role_name, "${var.name_prefix}-ecs-task-role")
  execution_role_name = coalesce(var.execution_role_name, "${var.name_prefix}-ecs-task-execution-role")
}

resource "aws_iam_role" "ecs_task_role" {
  name = local.task_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = var.task_assume_role_services
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, { Name = local.task_role_name })
}

resource "aws_iam_role_policy_attachment" "task_policy_attachments" {
  for_each   = toset(var.task_managed_policy_arns)
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = each.value
}

# NOTE: This inline policy references resources that likely live OUTSIDE the IAM module
# (aws_dynamodb_table.urls, aws_vpc_endpoint.dynamodb). If those aren't in this module,
# this will fail. Prefer passing ARNs/IDs in as variables if you keep it here.
resource "aws_iam_role_policy" "dynamodb_inline_policy" {
  count = var.enable_dynamodb_policy ? 1 : 0

  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:GetItem",
        "dynamodb:PutItem"
      ]
      Resource = var.dynamodb_table_arn
      Condition = {
        StringEquals = {
          "aws:SourceVpce" = var.dynamodb_vpc_endpoint_id
        }
      }
    }]
  })
}

# CodeDeploy role for ECS blue/green
resource "aws_iam_role" "codedeploy_role" {
  name = coalesce(var.codedeploy_role_name, "${var.name_prefix}-codedeploy-ecs-role")

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Principal = { Service = "codedeploy.amazonaws.com" },
        Effect    = "Allow"
      }
    ]
  })

  tags = merge(var.tags, { Name = coalesce(var.codedeploy_role_name, "${var.name_prefix}-codedeploy-ecs-role") })
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = local.execution_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = var.execution_assume_role_services
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, { Name = local.execution_role_name })
}

resource "aws_iam_role_policy_attachment" "execution_policy_attachments" {
  for_each   = toset(var.execution_managed_policy_arns)
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = each.value
}
