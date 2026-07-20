# Logical Components — `hello-tooling-docs`

| Componente | Responsabilidade | Artefato |
|---|---|---|
| **ScriptBuildPush** | Login ECR, `docker build ./app`, tag, push, force-new-deployment; opcional `-ResolvePublicIp`; `-AwsProfile` opcional | `scripts/build-and-push.ps1` |
| **DocLabOrchestration** | Guia SSO→apply→push→curl→destroy; AI-DLC breve; troubleshooting; risco CIDR | `README.md` |
| **GitIgnore** | Evitar state/secrets/cache no git | `.gitignore` |
| **IamPolicyDoc** | Policy de estudo IAM | `docs/ecs-fargate-alb-policy.json` (movido da raiz) |

## Fora
- Provisionamento Terraform
- Código FastAPI
