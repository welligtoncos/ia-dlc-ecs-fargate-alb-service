# Logical Components — `hello-infra` Fase 2

| Componente | Responsabilidade | Recursos típicos |
|---|---|---|
| **NetworkHA** | VPC, 2 subnets públicas (2 AZs), IGW, rotas | `network.tf` |
| **LoadBalancer** | ALB público, listener :80, TG ip:8000, HC `/health`, SG alb | `alb.tf` (ou equivalente) |
| **EcsHaService** | Cluster, task def, service desired=2 + load_balancer, SG task | `ecs.tf` |
| **Logging** | Log group `/ecs/hello-fargate` 7d | `logs.tf` |
| **Registry/IAM** | ECR + roles (herdado Fase 1) | `ecr.tf`, `iam.tf` |

## Fora
- ApiApp / mudanças de código
- Autoscaling, HTTPS, NAT
