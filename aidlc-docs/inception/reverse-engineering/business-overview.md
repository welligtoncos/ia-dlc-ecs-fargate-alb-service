# Business Overview — Lab Hello Fargate (Fase 1)

## Propósito
Lab didático de aprendizado AWS: publicar uma API Hello World containerizada no **Amazon ECS Fargate**, com infraestrutura 100% Terraform, e validar o caminho ponta a ponta (imagem → ECR → task → HTTP).

## Transações de negócio (didáticas)
1. **Provisionar lab** — operador roda `terraform apply` (VPC, ECR, IAM, cluster, service, logs).
2. **Publicar imagem** — `scripts/build-and-push.ps1` faz login ECR, build, push, force-new-deployment.
3. **Consumir API** — `GET /` (Hello World) e `GET /health` via IP público da task (sem ALB).
4. **Encerrar lab** — `terraform destroy` (custo ~zero).

## Atores
- Operador/estudante (SSO + CLI + Docker + Terraform)
- Clientes HTTP (curl/navegador) contra IP:8000

## Fora do escopo da Fase 1
- ALB, multi-AZ, desired_count > 1, HTTPS, CI/CD, autoscaling
