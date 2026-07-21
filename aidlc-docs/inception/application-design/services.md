# Services — Fase 2

## LabOrchestration (conceitual)
Orquestração **manual** do lab (não é um serviço AWS):

1. `aws sso login`
2. `terraform apply` (rede HA + ALB + service desired=2)
3. `scripts/build-and-push.ps1`
4. `curl http://<alb_dns_name>/` e `/health`
5. Exercício: encerrar 1 task no console → observar self-healing
6. `terraform destroy`

## ECS Service (runtime AWS)
- Nome lógico: service `hello-fargate`
- Mantém `desired_count=2`
- Integra com Target Group (registro automático de IPs das tasks)
- Não substitui o ALB: o ALB é o front door HTTP

## Não há
- Serviço de aplicação novo
- Service mesh / API Gateway
