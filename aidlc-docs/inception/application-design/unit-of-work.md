# Unidades de Trabalho — Fase 2 (HA + ALB)

## Modelo
- **Tipo**: módulos do mesmo lab (não microserviços)
- **Unidades ativas na Construction**: `hello-infra`, `hello-tooling-docs`
- **Unidade SKIP**: `hello-app` (FastAPI intacta; sem code gen)

## Ordem de Construction
1. `hello-infra`
2. `hello-tooling-docs`

## Organização de código (inalterada na estrutura)

```text
.
├── app/                 # hello-app (SKIP na Fase 2)
├── infra/               # hello-infra — evolui para HA/ALB
├── scripts/             # hello-tooling-docs
├── docs/
├── README.md
└── aidlc-docs/
```

---

## Unidade: `hello-infra`
- **Responsabilidade**: Terraform — VPC **2 AZs**, SGs alb/task, ALB + listener :80, Target Group + HC `/health`, ECS Service `desired_count=2` + `load_balancer`, ECR/IAM/logs existentes, output `alb_dns_name`
- **Componentes**: CloudInfra (incl. ALB/TG/Service HA)
- **Entregáveis**: `infra/*.tf` atualizados (ex.: `network.tf`, `alb.tf` ou equivalente, `ecs.tf`, `outputs.tf`)
- **Não inclui**: mudança de código Python; README completo

## Unidade: `hello-tooling-docs`
- **Responsabilidade**: LabOrchestration Fase 2 — README (DNS ALB, self-healing), ajustes mínimos no `build-and-push.ps1` (ex. imprimir `alb_dns_name`), policy IAM docs se necessário
- **Componentes**: Tooling + docs
- **Entregáveis**: `README.md`, `scripts/build-and-push.ps1` (delta), `docs/` se preciso
- **Não inclui**: provisionar recursos AWS

## Unidade: `hello-app` (SKIP)
- Sem loop de Construction na Fase 2
- Continua servindo `/` e `/health` para o HC do TG
