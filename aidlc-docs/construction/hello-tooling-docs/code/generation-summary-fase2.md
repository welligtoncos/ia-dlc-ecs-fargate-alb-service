# Code Generation Summary — `hello-tooling-docs` Fase 2

## Artefatos

| Arquivo | Mudança |
|---|---|
| `scripts/build-and-push.ps1` | Sempre imprime `alb_dns_name` + curls :80; fail-fast; `-ResolvePublicIp` alternativo |
| `README.md` | Reescrito HA+ALB: runbook, self-healing, custo/destroy, lições 2 AZ/ALB/SG |
| `docs/ecs-fargate-alb-policy.json` | **Sem mudança JSON** — ações ELB já cobrem o lab; texto README alinhado |
| `.gitignore` | Inalterado |

## Validação leve
- Script chama `Get-TfOutputRaw "alb_dns_name"` após redeploy
- README curls: `http://<ALB-DNS>/` sem `:8000`
- `app/` e `infra/` não alterados nesta unidade

## Próximo
**Build and Test** (instruções curl ALB + self-healing + destroy).
