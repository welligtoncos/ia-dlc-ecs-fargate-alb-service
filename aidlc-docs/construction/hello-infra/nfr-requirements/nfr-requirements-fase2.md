# NFR Requirements — `hello-infra` Fase 2 (HA + ALB)

## Decisões

| # | Tema | Decisão |
|---|---|---|
| 1 | HA | 2 AZs + desired=2 + ALB/TG; RTO estudo = recreate/redeploy; sem multi-região |
| 2 | Health check TG | `/health` :8000 matcher 200; defaults do provider (detalhe no Infra Design) |
| 3 | Custo | Destroy obrigatório; alertar custo ALB + 2 tasks |
| 4 | Logs | CW Logs 7d; sem Container Insights |
| 5 | Segurança (Security OFF) | SG task 8000 só do SG ALB; ALB:80 com `allowed_cidr` (default aberto documentado) |
| 6 | Apply in-place | Aceitar replace de rede/SG; documentar no README |

## Categorias NFR

### Disponibilidade / Resiliência (extension ON)
- HA didática multi-AZ + 2 tasks + ALB self-healing via TG HC
- Não é certificação de produção / multi-região

### Custo
- ALB + 2× Fargate 256/512; destroy obrigatório

### Observabilidade
- Logs de task; health no TG (não Container Insights)

### Segurança operacional
- Isolamento SG ALB→tasks; CIDR do listener documentado

### Performance
- Sem SLO; lab Hello World atrás do ALB

## Compliance
| Extension | Status |
|---|---|
| Resiliency | Compliant (HA lab + self-healing) |
| Security | N/A (OFF) |
| PBT | N/A (OFF) |
