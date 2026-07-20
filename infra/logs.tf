# CloudWatch Logs da task.
# Por quê log group dedicado + retenção curta: ver logs do lab sem acumular custo.

resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${local.project_name}"
  retention_in_days = 7

  tags = {
    Name = "${local.project_name}-logs"
  }
}
