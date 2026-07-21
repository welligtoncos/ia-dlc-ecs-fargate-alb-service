# NFR Requirements — `hello-tooling-docs` Fase 2 (mínimo)

## Decisões (respostas Q1–Q6 = A)

| # | Tema | Decisão |
|---|---|---|
| 1 | Script / ALB | Sempre imprimir `alb_dns_name` + exemplos `curl http://<dns>/` e `/health` após o push |
| 2 | IP alternativo | Manter `-ResolvePublicIp` como caminho **oficial alternativo**; fluxo principal = DNS ALB |
| 3 | Self-healing | Exercício didático no README: list-tasks → stop-task → observar recreate desired=2 + TG healthy (CLI + console) |
| 4 | README | Reescrever lab para HA+ALB; manter local/Docker e AI-DLC breve; atualizar diagrama/lições |
| 5 | Policy IAM | Revisar só se faltar ação ELB óbvia; senão atualizar texto README (“policy cobre lab com ALB”) |
| 6 | Custo / destroy | Destacar ALB + 2 tasks; destroy obrigatório; aviso de replace no plan in-place Fase 1→2 |

## NFRs

### Usabilidade / LabOrchestration
- Fluxo linear: SSO → `terraform apply` → `build-and-push.ps1` → curl **via ALB** → exercício self-healing → `destroy`
- Script continua PowerShell; `-AwsProfile` opcional

### Disponibilidade / Resiliência (documentação — Resiliency ON)
- README explica HA (2 AZs, desired=2, ALB/TG) e demonstra self-healing matando 1 task
- Sem SLO de produção; RTO = recreate ECS

### Custo / Manutenibilidade
- Alerta explícito de custo ALB + 2 tasks
- Destroy checklist obrigatório
- Documentar possible replace de rede/SG no apply in-place

### Segurança operacional (Security OFF)
- Não versionar state/secrets (`.gitignore` existente)
- Policy estudo em `docs/`; listener aberto documentado no lab (herdado da infra)

### Performance
- N/A — docs/script; sem benchmarks

## Fora de escopo desta unidade
- Provisionar recursos AWS (já em `hello-infra`)
- Alterar `app/`
- Infrastructure Design (N/A)

## Compliance
| Extension | Status | Rationale |
|---|---|---|
| Resiliency | Compliant | Documenta HA + exercício self-healing |
| Security | N/A | OFF; só texto/policy estudo |
| PBT | N/A | OFF |
