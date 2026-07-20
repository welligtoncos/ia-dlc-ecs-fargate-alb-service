# NFR Requirements — `hello-tooling-docs`

## Decisões

| # | Tema | Decisão |
|---|---|---|
| 1 | Shell | PowerShell apenas (`scripts/build-and-push.ps1`) |
| 2 | IP helper | Parâmetro opcional `-ResolvePublicIp` no mesmo script |
| 3 | README | Unificado: AI-DLC breve + lab Fargate principal |
| 4 | `.gitignore` | Terraform state/dir, Python, venv, .env, IDE; lock TF pode ser commitado |
| 5 | Policy IAM | Mover para `docs/ecs-fargate-alb-policy.json` |
| 6 | SSO profile | `-AwsProfile` opcional |

## NFRs
- **Usabilidade**: fluxo linear SSO → apply → script → curl → destroy
- **Segurança operacional**: não versionar state/secrets; policy em `docs/`
- **Manutenibilidade**: um script oficial; README como LabOrchestration
- **Custo**: checklist destroy obrigatório no README

## Compliance
| Extension | Status |
|---|---|
| Resiliency | recreate + testes mínimos documentados |
| Security | N/A baseline |
| PBT | N/A |
