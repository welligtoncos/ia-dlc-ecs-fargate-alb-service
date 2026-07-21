# Componentes — Fase 2 (HA + ALB)

## Visão geral
Mesmos quatro componentes da Fase 1; **CloudInfra** ganha ALB/TG/Service HA. **ApiApp** permanece intacta.

| Componente | Pasta | Propósito na Fase 2 |
|---|---|---|
| **ApiApp** | `app/` | FastAPI `/` e `/health` (sem mudanças) |
| **ContainerImage** | `app/Dockerfile` | Imagem OCI (sem mudanças) |
| **CloudInfra** | `infra/*.tf` | VPC 2 AZ, ECR, IAM, logs, **ALB + TG + HC**, ECS Service desired=2 |
| **Tooling** | `scripts/`, `README.md` | Push imagem; curl **DNS ALB**; roteiro self-healing |

Serviço conceitual: **LabOrchestration** (ver `services.md`).

---

## ApiApp
- **Responsabilidades**: HTTP na 8000; `/` e `/health`.
- **Não faz**: Conhecer ALB, headers especiais, ou networking AWS.
- **Nota Q5**: Resposta B (código custom para ALB) **rejeitada no design** por conflitar com RF “app intacta”; adotado comportamento de A.

## ContainerImage
- Inalterado vs Fase 1.

## CloudInfra
- **Responsabilidades**:
  - Rede: 2 subnets públicas / 2 AZs, IGW, rotas
  - SG **alb** (ingress 80) e SG **task** (ingress 8000 só do SG alb)
  - ALB público + listener :80 + Target Group (ip, :8000, HC `/health`)
  - ECS cluster, task definition, service `desired_count=2` + `load_balancer`
  - ECR, IAM, CloudWatch Logs
  - Output principal: `alb_dns_name`
- **Não faz**: Build/push; matar task no exercício (operador no console)

## Tooling
- Build/push + force-new-deployment
- Documentar DNS ALB (não IP da task como fluxo principal)
- Guia self-healing + destroy
