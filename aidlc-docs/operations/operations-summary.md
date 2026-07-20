# Operations — Resumo (Placeholder)

## Status
Esta fase é um **placeholder** no AI-DLC atual. Não há pipeline de deploy/monitoramento automatizado neste workflow.

## Escopo futuro (quando expandido)
- Planejamento e execução de deployment
- Monitoramento e observabilidade
- Procedimentos de resposta a incidentes
- Fluxos de manutenção e suporte
- Checklists de prontidão para produção

## Estado atual deste projeto (lab Hello Fargate)
- **Construction concluída**: unidades `hello-infra`, `hello-app`, `hello-tooling-docs` + Build and Test
- **Operação didática** documentada no `README.md` e no script `scripts/build-and-push.ps1`:
  1. `aws sso login`
  2. `terraform -chdir=infra apply`
  3. `.\scripts\build-and-push.ps1`
  4. `curl` em `/` e `/health`
  5. `terraform -chdir=infra destroy` (obrigatório)
- Placeholders de change management / incidentes da organização permanecem TBD no README
- CI/CD fora de escopo (deploy manual)

## Encerramento do workflow
O fluxo AI-DLC para o lab FastAPI → ECR → ECS Fargate está **completo**.
