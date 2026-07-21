# Outputs do lab — Fase 2 (HA + ALB).
# Fluxo principal: alb_dns_name. IP da task permanece output oficial alternativo (Q5=B).

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

output "alb_dns_name" {
  description = "DNS do Application Load Balancer (curl http://<dns>/ e /health)."
  value       = aws_lb.app.dns_name
}

output "alb_arn" {
  description = "ARN do ALB."
  value       = aws_lb.app.arn
}

output "target_group_arn" {
  description = "ARN do Target Group."
  value       = aws_lb_target_group.app.arn
}

output "alb_url" {
  description = "URL HTTP base do lab via ALB."
  value       = "http://${aws_lb.app.dns_name}"
}

# Lookup de ENI no apply quebra o plan — IP via CLI/script (oficial alternativo ao ALB).
output "public_ip" {
  description = "Sempre null no Terraform. Use public_ip_cli_fallback ou -ResolvePublicIp (caminho oficial alternativo ao ALB)."
  value       = null
}

output "public_ip_cli_fallback" {
  description = "Passos AWS CLI para obter IP público de uma task RUNNING (oficial alternativo)."
  value       = <<-EOT
    aws ecs list-tasks --cluster ${aws_ecs_cluster.lab.name} --service-name ${aws_ecs_service.app.name} --desired-status RUNNING --region ${var.aws_region} --query "taskArns[0]" --output text
    # Depois: describe-tasks → ENI → describe-network-interfaces → Association.PublicIp
    # Ou: .\scripts\build-and-push.ps1 -ResolvePublicIp
  EOT
}

output "force_new_deployment_command" {
  description = "Após o docker push, force um novo deployment do service."
  value       = "aws ecs update-service --cluster ${aws_ecs_cluster.lab.name} --service ${aws_ecs_service.app.name} --force-new-deployment --region ${var.aws_region}"
}
