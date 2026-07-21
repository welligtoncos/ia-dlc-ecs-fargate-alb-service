# Tech Stack Decisions — `hello-tooling-docs` Fase 2

| Área | Escolha | Motivo |
|---|---|---|
| Shell | PowerShell 5.1+ | Script existente; lab Windows |
| IaC outputs | `terraform output -raw alb_dns_name` (e demais) | Fonte de verdade pós-apply |
| AWS CLI | v2 (ECS stop-task, list-tasks, etc.) | Exercício self-healing + fallback IP |
| Docs | Markdown README pt-BR | LabOrchestration didático |
| Policy | JSON em `docs/ecs-fargate-alb-policy.json` | Estudo IAM; revisão mínima ELB |
| App runtime | FastAPI intacta (sem mudança) | Unidade `hello-app` SKIP |

Sem novas linguagens, frameworks ou ferramentas além do stack Fase 1.
