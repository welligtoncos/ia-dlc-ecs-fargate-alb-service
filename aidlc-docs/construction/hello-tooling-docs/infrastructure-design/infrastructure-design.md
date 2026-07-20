# Infrastructure Design — `hello-tooling-docs`

## Escopo cloud
**N/A** — nenhum recurso AWS novo. A unidade consome outputs/CLIs da infra e da app já geradas.

## Decisões

| # | Tema | Decisão |
|---|---|---|
| 1 | Cloud | N/A |
| 2 | Tooling local | Documentar AWS CLI v2, Docker, Terraform, PowerShell, SSO |
| 3 | Path `infra/` | Detectar raiz do repo a partir do script → `./infra` |

## Ambiente do operador (não provisionado)
| Ferramenta | Uso |
|---|---|
| AWS CLI v2 + SSO | Auth, ECR login, ECS force deploy, IP fallback |
| Docker | build/tag/push `./app` |
| Terraform CLI | apply/destroy + `terraform output -raw` |
| PowerShell | `scripts/build-and-push.ps1` |

## Shared infrastructure
- N/A
