# Tech Stack Decisions — `hello-infra` Fase 2

| Área | Escolha | Motivo |
|---|---|---|
| IaC | Terraform AWS ~> 5 | Continuação Fase 1 |
| LB | Application Load Balancer HTTP :80 | RF-F2-03 |
| TG | target type `ip`, port 8000, HC `/health` | awsvpc + FastAPI |
| Compute | ECS Fargate Service desired=2 | HA didática |
| Rede | 2 subnets públicas / 2 AZs | Sem NAT (custo) |
| Auth ops | AWS SSO | Herdado |

## Fora
- HTTPS/ACM, NAT Gateway, Container Insights, multi-região
