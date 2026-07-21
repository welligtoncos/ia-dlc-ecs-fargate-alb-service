# NFR Design Patterns — `hello-tooling-docs` Fase 2

## Decisões (Q1–Q6 = A)

| # | Tema | Padrão |
|---|---|---|
| 1 | Resilience | LabOrchestration HA: curl via ALB; self-healing **manual** no README (stop-task); sem `-DemoSelfHealing` |
| 2 | Fail-fast | `$ErrorActionPreference = 'Stop'`; falha ao ler `alb_dns_name` → pedir `terraform apply` |
| 3 | Scale / Perf | N/A; README menciona `desired_count=2` fixo |
| 4 | Security docs | Documentar risco `allowed_cidr` + SG ALB→task; sem auth no script |
| 5 | Components | Evoluir ScriptBuildPush, DocLabOrchestration, IamPolicyDoc; GitIgnore intacto |
| 6 | Runbook order | SSO → plan/apply (replace) → push → curl ALB → self-healing → destroy |

## Padrões aplicados
- **Runbook didático HA**: README como orquestrador humano do lab multi-AZ + ALB
- **Infra as source of truth**: DNS/nomes via `terraform output`
- **Fail-fast scripting**: para na primeira falha AWS/Docker/TF
- **Self-healing demo (Resiliency ON)**: exercício manual pós-validação HTTP
- **Cost hygiene**: destroy obrigatório + alerta ALB + 2 tasks
- **Dual validation path**: principal ALB; alternativo `-ResolvePublicIp`

## Compliance
| Extension | Status | Rationale |
|---|---|---|
| Resiliency | Compliant | Documenta HA + exercício recreate |
| Security | N/A | OFF; só documentação de risco |
| PBT | N/A | OFF |
