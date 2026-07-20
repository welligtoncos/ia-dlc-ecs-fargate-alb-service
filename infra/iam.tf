# IAM para ECS Fargate.
# Por quê duas roles:
# - execution role: agente ECS puxa imagem do ECR e escreve logs
# - task role: permissões da aplicação em runtime (neste lab, mínima/vazia de ações extras)

data "aws_iam_policy_document" "ecs_tasks_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "execution" {
  name               = "${local.project_name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume.json
}

resource "aws_iam_role_policy_attachment" "execution_ecr_logs" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task" {
  name               = "${local.project_name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume.json
}
