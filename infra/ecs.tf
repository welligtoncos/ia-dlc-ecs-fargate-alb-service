# ECS Cluster + Task Definition + Service (Fargate) — Fase 2 HA.
# desired_count=2 + load_balancer no TG; tasks nas 2 subnets públicas.
# Gap: no 1º apply a imagem :latest pode não existir — wait_for_steady_state=false.

resource "aws_ecs_cluster" "lab" {
  name = local.project_name

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    Name = local.project_name
  }
}

locals {
  ecr_image = "${aws_ecr_repository.app.repository_url}:${local.image_tag}"
}

resource "aws_ecs_task_definition" "app" {
  family                   = local.project_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = local.fargate_cpu
  memory                   = local.fargate_memory
  execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn            = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name      = local.project_name
      image     = local.ecr_image
      essential = true
      portMappings = [
        {
          containerPort = local.container_port
          hostPort      = local.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = local.project_name
  cluster         = aws_ecs_cluster.lab.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  # Defaults de rolling: maximumPercent=200, minimumHealthyPercent=100
  wait_for_steady_state = false

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    security_groups  = [aws_security_group.task.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = local.project_name
    container_port   = local.container_port
  }

  depends_on = [
    aws_iam_role_policy_attachment.execution_ecr_logs,
    aws_cloudwatch_log_group.app,
    aws_lb_listener.http,
  ]

  tags = {
    Name = local.project_name
  }
}
