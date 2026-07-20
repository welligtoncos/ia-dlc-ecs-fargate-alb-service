# Code Generation Summary — `hello-tooling-docs`

## Artefatos gerados

| Caminho | Componente | Descrição |
|---|---|---|
| `scripts/build-and-push.ps1` | ScriptBuildPush | ECR login, build `./app`, push `:latest`, force-new-deployment; `-AwsProfile`, `-ResolvePublicIp` |
| `.gitignore` | GitIgnore | TF state/dir, Python, venv, `.env`, IDE; lock TF não ignorado |
| `docs/ecs-fargate-alb-policy.json` | IamPolicyDoc | Movido da raiz |
| `README.md` | DocLabOrchestration | Unificado: lab principal + AI-DLC breve |

## Removido
- `ecs-fargate-alb-policy.json` na raiz (após move para `docs/`)

## Traceabilidade
| RF / CS | Cobertura |
|---|---|
| RF-03 | Script oficial PowerShell |
| RF-06 / RF-07 | `-ResolvePublicIp` + seções curl/IP no README |
| RF-08 | README didático pt-BR + referência policy |
| RF-09 | Seção SSO |
| CS-4 | Estrutura + papéis documentados |
| Resiliency | Checklist destroy + exercício recreate |

## Fora desta geração
- `terraform apply` / push real
- Mudanças em `infra/` ou `app/`

## Próximo
Build and Test (instruções do lab completo) após aprovação desta unidade.
