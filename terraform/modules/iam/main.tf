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
