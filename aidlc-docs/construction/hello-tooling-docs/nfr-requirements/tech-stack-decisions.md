# Tech Stack Decisions — `hello-tooling-docs`

| Camada | Escolha | Motivo |
|---|---|---|
| Automação | PowerShell 5+/7 | Lab Windows |
| AWS CLI | v2 (SSO) | Auth do operador |
| Docker CLI | build/tag/push | Imagem → ECR |
| Docs | Markdown README + `docs/` | Didática pt-BR |
| Ignore | `.gitignore` amplo | State/secrets/cache |

## Artefatos previstos no Code Gen
- `scripts/build-and-push.ps1` (`-AwsProfile`, `-ResolvePublicIp`, force-new-deployment)
- `README.md` unificado
- `.gitignore`
- `docs/ecs-fargate-alb-policy.json` (move da raiz)
