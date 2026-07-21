# Logical Components — `hello-tooling-docs` Fase 2

| Componente | Responsabilidade Fase 2 | Artefato |
|---|---|---|
| **ScriptBuildPush** | ECR login → build `./app` → push → force-new-deployment; **sempre** imprimir `alb_dns_name` + curls; `-ResolvePublicIp` opcional; `-AwsProfile` opcional; fail-fast se output ALB ausente | `scripts/build-and-push.ps1` |
| **DocLabOrchestration** | README reescrito: SSO → plan/apply (aviso replace) → push → curl ALB → self-healing (CLI/console) → destroy; custo ALB+2 tasks; risco CIDR; lições 2 AZ / ALB / SG | `README.md` |
| **IamPolicyDoc** | Revisar ELB se faltar ação óbvia; senão só alinhar texto README (“policy cobre lab com ALB”) | `docs/ecs-fargate-alb-policy.json` |
| **GitIgnore** | Sem mudança Fase 2 | `.gitignore` |

## Fluxo lógico

```text
Operador
  -> DocLabOrchestration (runbook)
  -> terraform apply (hello-infra)
  -> ScriptBuildPush (imagem + print ALB)
  -> curl http://<alb-dns>/  e  /health
  -> DocLabOrchestration (exercício stop-task)
  -> terraform destroy
```

## Fora
- Provisionamento Terraform (`hello-infra`)
- Código FastAPI (`hello-app` SKIP)
- Infrastructure Design nesta unidade (N/A)
