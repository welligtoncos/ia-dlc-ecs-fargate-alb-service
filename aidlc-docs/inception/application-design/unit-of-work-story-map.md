# Mapa RF → Unidades — Fase 2

| RF | Descrição | Unidade | Notas |
|---|---|---|---|
| RF-F2-01 | Reutilizar API FastAPI | `hello-app` (SKIP) | Sem code gen |
| RF-F2-02 | Rede 2 AZs | `hello-infra` | |
| RF-F2-03 | ALB público HTTP :80 | `hello-infra` | |
| RF-F2-04 | TG + HC `/health` | `hello-infra` | usa endpoint da app |
| RF-F2-05 | Service desired=2 + self-heal | `hello-infra` | |
| RF-F2-06 | SGs alb / task | `hello-infra` | |
| RF-F2-07 | CloudWatch Logs | `hello-infra` | manter |
| RF-F2-08 | README/script DNS ALB | `hello-tooling-docs` | |
| RF-F2-09 | Cenário self-healing documentado | `hello-tooling-docs` (+ exercício em Build and Test) | |

## Critérios de sucesso do lab
| Critério | Cobertura |
|---|---|
| API via DNS ALB | infra + tooling |
| 2 tasks | infra |
| Distribuição / HC | infra |
| Matar task → recria | infra (comportamento) + tooling (roteiro) + B&T |
