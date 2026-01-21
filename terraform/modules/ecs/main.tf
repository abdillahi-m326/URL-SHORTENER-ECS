resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name

  tags = {
    Name = "${var.name_prefix}-ecs-cluster"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = var.task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }

      environment = [
        { name = "TABLE_NAME", value = "urls" },
        { name = "AWS_REGION", value = var.aws_region }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name                = var.ecs_service_name
  cluster             = aws_ecs_cluster.ecs_cluster.id
  task_definition     = aws_ecs_task_definition.task.arn
  launch_type         = "FARGATE"
  platform_version    = "LATEST"
  desired_count       = var.desired_count
  scheduling_strategy = "REPLICA"
  /*
  # REQUIRED for CodeDeploy Blue/Green on ECS
  deployment_controller {
    type = "CODE_DEPLOY"
  }
**/
  # Attach service to BLUE target group initially
  load_balancer {
    target_group_arn = var.target_group_blue_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  network_configuration {
    assign_public_ip = false
    subnets          = var.subnet_ids
    security_groups  = [var.tasks_security_group_id]
  }

  lifecycle {
    # CodeDeploy manages task sets / deployments; avoid Terraform fighting deployments
    ignore_changes = [
      task_definition,
      load_balancer,
      desired_count
    ]
  }

}
