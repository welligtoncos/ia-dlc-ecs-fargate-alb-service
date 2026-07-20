# NFR Design Patterns — `hello-tooling-docs`

## Decisões

| # | Tema | Padrão |
|---|---|---|
| 1 | LabOrchestration | Seções numeradas: SSO → apply → push → curl → destroy |
| 2 | Erros no script | `$ErrorActionPreference = 'Stop'` + mensagens claras |
| 3 | Config AWS/ECR | Ler `terraform output -raw` de `infra/` |
| 4 | Componentes | ScriptBuildPush, DocLabOrchestration, GitIgnore, IamPolicyDoc |
| 5 | Resiliency test | curl `/` e `/health` + exercício destroy/recreate no README |

## Padrões
- **Runbook didático**: README como orquestrador humano
- **Fail-fast scripting**: para na primeira falha
- **Infra as source of truth**: URLs/nomes via outputs Terraform
- **Cost hygiene**: destroy obrigatório no checklist
- **Recreate DR**: documentado como exercício mínimo

## Compliance
| Extension | Status |
|---|---|
| Resiliency | recreate + validação HTTP + destroy |
| Security | N/A |
| PBT | N/A |
