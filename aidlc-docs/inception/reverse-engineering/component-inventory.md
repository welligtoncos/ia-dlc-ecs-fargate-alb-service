# Component Inventory — Fase 1

| Componente | Local | Responsabilidade |
|---|---|---|
| ApiApp | `app/` | HTTP Hello World + health |
| ContainerImage | `app/Dockerfile` | Imagem Python 3.12 slim non-root |
| CloudInfra | `infra/` | Rede, ECR, IAM, ECS, logs |
| Tooling | `scripts/`, `README.md` | Build/push, orquestração didática |
| IamPolicyDoc | `docs/ecs-fargate-alb-policy.json` | Policy de estudo (já inclui ações ALB) |
