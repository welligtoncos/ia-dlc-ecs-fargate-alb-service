# Plano de Code Generation — `hello-tooling-docs` Fase 2

## Contexto
- Unidade: LabOrchestration HA+ALB (RF-F2-08, RF-F2-09)
- Depende de: outputs `hello-infra` (`alb_dns_name`, cluster/service)
- Brownfield: modificar `scripts/build-and-push.ps1`, reescrever `README.md`, revisar `docs/` se preciso
- `.gitignore`: **inalterado**
- App: **intacta**

## Passos

### Passo 1 — Script (`scripts/build-and-push.ps1`)
- [x] Após force-new-deployment, ler e imprimir `alb_dns_name` + exemplos `curl http://<dns>/` e `/health`
- [x] Fail-fast se output `alb_dns_name` falhar (mensagem pedindo `terraform apply`)
- [x] Manter `-ResolvePublicIp` como caminho oficial alternativo (IP :8000)
- [x] Manter `-AwsProfile`; atualizar comentário SYNOPSIS/DESCRIPTION (lab HA+ALB)
- [x] Não adicionar `-DemoSelfHealing`

### Passo 2 — README (`README.md`)
- [x] Reescrever lab para HA+ALB: fluxo principal via DNS (não IP)
- [x] Ordem: SSO → plan/apply (aviso replace Fase 1→2) → build-and-push → curl ALB → self-healing → destroy
- [x] Destacar custo ALB + 2 tasks; destroy obrigatório
- [x] Exercício self-healing: list-tasks → stop-task → observar desired=2 + TG healthy (CLI + o que ver no console)
- [x] Atualizar diagrama/lições: 2 AZs, ALB, SG alb→task, HC `/health`
- [x] Manter seções locais/Docker e AI-DLC breve (adaptadas)
- [x] Documentar risco `allowed_cidr` aberto
- [x] Mencionar `-ResolvePublicIp` como alternativo

### Passo 3 — Policy IAM (`docs/ecs-fargate-alb-policy.json`)
- [x] Revisar ações ELB; se já cobrir Create/Delete/Describe LB/TG/Listener/Register — só alinhar texto no README
- [x] Expandir JSON só se faltar ação óbvia para o lab Fase 2

### Passo 4 — Resumo de processo
- [x] `aidlc-docs/construction/hello-tooling-docs/code/generation-summary-fase2.md`

### Passo 5 — Validação leve
- [x] Conferir que script referencia `alb_dns_name`; README curl usa porta 80 (sem `:8000` no ALB)
- [x] Não alterar `app/` nem `infra/`

## Traceabilidade
| RF | Cobertura |
|---|---|
| RF-F2-08 | Script print ALB + README DNS |
| RF-F2-09 | Exercício self-healing no README |

## Fora deste plano
- `terraform apply` / push reais
- Automação de kill-task no script
- Mudanças em `infra/` ou `app/`
- Infrastructure Design (N/A nesta unidade)

## Compliance
| Extension | Status |
|---|---|
| Resiliency | Doc HA + self-healing |
| Security | OFF; risco CIDR documentado |
| PBT | OFF |
