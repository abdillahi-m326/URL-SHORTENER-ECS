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

  tags = merge(
    var.tags,
    {
      Name = local.task_role_name
    }
  )
}

resource "aws_iam_role_policy_attachment" "task_policy_attachments" {
  for_each   = toset(var.task_managed_policy_arns)
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "dynamodb_inline_policy" {
  role = aws_iam_role.task_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "dynamodb:GetItem",
        "dynamodb:PutItem"
      ],
      Resource = aws_dynamodb_table.urls.arn,
      Condition = {
        StringEquals = {
          "aws:SourceVpce" = aws_vpc_endpoint.dynamodb.id
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_inline_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_role_policy.dynamodb_inline_policy.arn
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

  tags = merge(
    var.tags,
    {
      Name = local.execution_role_name
    }
  )
}

resource "aws_iam_role_policy_attachment" "execution_policy_attachments" {
  for_each   = toset(var.execution_managed_policy_arns)
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = each.value
}
