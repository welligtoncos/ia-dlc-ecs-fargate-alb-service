# ECS Cluster + Task Definition + Service (Fargate).
# Por quê Service com desired_count=1: mantém uma task; sem ALB e sem autoscaling.
# Dependency gap: no primeiro apply a imagem :latest pode ainda não existir no ECR.
# O apply NÃO espera steady state — depois rode o script de build/push + force deployment.

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
  desired_count   = 1
  launch_type     = "FARGATE"

  # Não bloquear o apply se a task ainda não ficar saudável (imagem ausente).
  wait_for_steady_state = false

  network_configuration {
    subnets          = [aws_subnet.public.id]
    security_groups  = [aws_security_group.task.id]
    assign_public_ip = true
  }

  # Sem load_balancer { } — acesso direto via IP público da ENI.

  depends_on = [
    aws_iam_role_policy_attachment.execution_ecr_logs,
    aws_cloudwatch_log_group.app,
  ]

  tags = {
    Name = local.project_name
  }
}
