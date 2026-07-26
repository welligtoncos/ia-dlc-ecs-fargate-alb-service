# Operations — Resumo (Placeholder) — Fase 2

## Status
Esta fase é um **placeholder** no AI-DLC atual. Não há pipeline de deploy/monitoramento automatizado neste workflow.

## Escopo futuro (quando expandido)
- Planejamento e execução de deployment
- Monitoramento e observabilidade
- Procedimentos de resposta a incidentes
- Fluxos de manutenção e suporte
- Checklists de prontidão para produção

## Estado atual deste projeto (lab Hello Fargate — Fase 2 HA + ALB)
- **Construction concluída**:
  - `hello-infra` — Terraform 2 AZs + ALB + TG + Service `desired_count=2`
  - `hello-tooling-docs` — README/script DNS ALB + self-healing
  - `hello-app` — **SKIP** (FastAPI intacta)
  - Build and Test — pytest + instruções curl ALB / self-healing / destroy
- **Operação didática** no `README.md` e `scripts/build-and-push.ps1`:
  1. `aws sso login`
  2. `terraform -chdir=infra plan` / `apply` (aviso replace se migrando da Fase 1)
  3. `.\scripts\build-and-push.ps1` (imprime `alb_dns_name`)
  4. `curl http://<ALB-DNS>/` e `/health`
  5. (Opcional) Exercício self-healing: `stop-task` → observar recreate
  6. `terraform -chdir=infra destroy` (**obrigatório** — custo ALB + 2 tasks)
- Placeholders de change management / incidentes da organização: TBD no README
- CI/CD fora de escopo (deploy manual)
- HTTPS / NAT / autoscaling: fora de escopo

## Encerramento do workflow
O fluxo AI-DLC da **Fase 2 (HA com ALB)** está **completo** (Inception + Construction + Operations placeholder).
