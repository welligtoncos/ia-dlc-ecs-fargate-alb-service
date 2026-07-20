# Outputs do lab.
# IP público: tentativa híbrida (espera curta + ENI do SG). Se vazio, use o comando de fallback.

output "aws_region" {
  description = "Região usada."
  value       = var.aws_region
}

output "ecr_repository_url" {
  description = "URL do repositório ECR (use no docker tag/push)."
  value       = aws_ecr_repository.app.repository_url
}

output "ecr_image" {
  description = "URI completa esperada da imagem (tag latest)."
  value       = local.ecr_image
}

output "ecs_cluster_name" {
  description = "Nome do cluster ECS."
  value       = aws_ecs_cluster.lab.name
}

output "ecs_service_name" {
  description = "Nome do service ECS."
  value       = aws_ecs_service.app.name
}

output "vpc_id" {
  description = "ID da VPC do lab."
  value       = aws_vpc.lab.id
}

# Espera curta para a ENI da task aparecer (pode falhar/ficar vazia se não houver task RUNNING).
resource "time_sleep" "wait_for_task_eni" {
  depends_on      = [aws_ecs_service.app]
  create_duration = "45s"
}

data "aws_network_interfaces" "task" {
  depends_on = [time_sleep.wait_for_task_eni]

  filter {
    name   = "group-id"
    values = [aws_security_group.task.id]
  }

  filter {
    name   = "subnet-id"
    values = [aws_subnet.public.id]
  }
}

data "aws_network_interface" "task" {
  count = length(data.aws_network_interfaces.task.ids) > 0 ? 1 : 0
  id    = data.aws_network_interfaces.task.ids[0]
}

output "public_ip" {
  description = "IP público da ENI (pode estar vazio no 1º apply ou se a task ainda não subiu). Use public_ip_cli_fallback."
  value = try(
    data.aws_network_interface.task[0].association[0].public_ip,
    null
  )
}

output "public_ip_cli_fallback" {
  description = "Comando AWS CLI para obter o IP público da task RUNNING (fallback)."
  value       = <<-EOT
    aws ecs list-tasks --cluster ${aws_ecs_cluster.lab.name} --service-name ${aws_ecs_service.app.name} --desired-status RUNNING --region ${var.aws_region} --query "taskArns[0]" --output text
    # Depois: aws ecs describe-tasks ... + ec2 describe-network-interfaces para Association.PublicIp
    # Ou use o helper PowerShell da unidade tooling quando disponível.
  EOT
}

output "force_new_deployment_command" {
  description = "Após o docker push, force um novo deployment do service."
  value       = "aws ecs update-service --cluster ${aws_ecs_cluster.lab.name} --service ${aws_ecs_service.app.name} --force-new-deployment --region ${var.aws_region}"
}
