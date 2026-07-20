# Outputs do lab.
# IP público: o Terraform NÃO consulta a ENI no apply (count dinâmico quebra no 1º apply).
# Use: .\scripts\build-and-push.ps1 -ResolvePublicIp  OU  o comando em public_ip_cli_fallback.

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

# Mantido como null de propósito: lookup de ENI com count depende de IDs só conhecidos
# depois do apply e falha no plan. O script PowerShell resolve o IP via AWS CLI.
output "public_ip" {
  description = "Sempre null no Terraform deste lab. Resolva com -ResolvePublicIp ou public_ip_cli_fallback."
  value       = null
}

output "public_ip_cli_fallback" {
  description = "Passos AWS CLI para obter o IP público da task RUNNING."
  value       = <<-EOT
    # 1) Task RUNNING:
    aws ecs list-tasks --cluster ${aws_ecs_cluster.lab.name} --service-name ${aws_ecs_service.app.name} --desired-status RUNNING --region ${var.aws_region} --query "taskArns[0]" --output text
    # 2) ENI da task:
    # aws ecs describe-tasks --cluster ${aws_ecs_cluster.lab.name} --tasks <TASK_ARN> --region ${var.aws_region} --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value | [0]" --output text
    # 3) IP público:
    # aws ec2 describe-network-interfaces --network-interface-ids <ENI_ID> --region ${var.aws_region} --query "NetworkInterfaces[0].Association.PublicIp" --output text
    # Preferível: .\scripts\build-and-push.ps1 -ResolvePublicIp
  EOT
}

output "force_new_deployment_command" {
  description = "Após o docker push, force um novo deployment do service."
  value       = "aws ecs update-service --cluster ${aws_ecs_cluster.lab.name} --service ${aws_ecs_service.app.name} --force-new-deployment --region ${var.aws_region}"
}
