# NFR Design Patterns — `hello-infra` Fase 2

## Decisões

| # | Tema | Decisão |
|---|---|---|
| 1 | Self-healing | ECS Service recria tasks; TG só healthy |
| 2 | Rolling | Defaults 200% / 100% healthy |
| 3 | Escala | N/A — desired=2 fixo |
| 4 | Componentes | NetworkHA, LoadBalancer, EcsHaService, Logging |
| 5 | Teste resiliência | Manual: curl ALB → stop task → observar |
| 6 | Imagem ausente | Aceitar falha até push (Fase 1) |

## Padrões

### Availability / Self-healing
- **Desired count = 2** em 2 AZs
- ALB + TG com HC `/health` remove targets ruins
- Service lança nova task quando count cai

### Deployment
- `deployment_maximum_percent = 200`
- `deployment_minimum_healthy_percent = 100`
- Force-new-deployment via script após push

### Scalability
- **N/A** — sem Auto Scaling

### Observability
- CloudWatch Logs 7d
- Health visível no TG / ECS console

### Cost
- Destroy obrigatório; sem Container Insights / NAT

## Compliance Resiliency
| Tema | Status |
|---|---|
| HA multi-AZ + ALB | Compliant (didático) |
| Multi-região / chaos formal | N/A |
| Teste self-healing | Documentado (manual) |
