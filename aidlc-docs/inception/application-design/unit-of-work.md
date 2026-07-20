# Unidades de Trabalho — Lab FastAPI + Fargate

## Modelo
- **Tipo**: módulos do mesmo lab (não microserviços independentes)
- **Deployável como container**: apenas a app (`hello-app`)
- **IaC**: `hello-infra` (Terraform)
- **Tooling/docs**: `hello-tooling-docs` (scripts, README, `.gitignore`, policy IAM em `docs/`)

## Ordem de Construction / Code Generation
1. `hello-infra`
2. `hello-app`
3. `hello-tooling-docs`

## Organização de código (greenfield multi-unit / monorepo de lab)

```text
.
├── app/                          # hello-app
│   ├── main.py                   # (ou estrutura mínima FastAPI)
│   ├── requirements.txt
│   └── Dockerfile
├── infra/                        # hello-infra
│   ├── provider.tf / versions.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── network.tf
│   ├── ecr.tf
│   ├── iam.tf
│   └── ecs.tf
├── scripts/                      # hello-tooling-docs
│   └── build-and-push.ps1
├── docs/                         # hello-tooling-docs
│   └── ecs-fargate-alb-policy.json   # movido da raiz na geração desta unidade
├── README.md                     # hello-tooling-docs
├── .gitignore                    # hello-tooling-docs
├── .aidlc-rule-details/          # já existente (fora das unidades de lab)
├── .cursor/                      # já existente
└── aidlc-docs/                   # processo AI-DLC
```

---

## Unidade: `hello-infra`
- **Responsabilidade**: Provisionar AWS via Terraform (VPC 1 AZ, SG, ECR, IAM, ECS cluster/task/service, logs, outputs incl. IP).
- **Componentes**: CloudInfra
- **Entregáveis**: arquivos `infra/*.tf`, state local + comentário S3, prefixo `hello-fargate`, região `us-east-1`, Fargate 256/512
- **Não inclui**: código Python, Dockerfile, scripts de push, README completo

## Unidade: `hello-app`
- **Responsabilidade**: API FastAPI (`/`, `/health`), deps Python, Dockerfile (ARG Python 3.12)
- **Componentes**: ApiApp, ContainerImage
- **Entregáveis**: `app/main.py` (ou equivalente), `app/requirements.txt`, `app/Dockerfile`
- **Não inclui**: Terraform, scripts AWS

## Unidade: `hello-tooling-docs`
- **Responsabilidade**: LabOrchestration documentado; `scripts/build-and-push.ps1`; fallback IP; README (AI-DLC breve + lab); `.gitignore`; mover/referenciar policy em `docs/ecs-fargate-alb-policy.json`
- **Componentes**: Tooling + documentação
- **Entregáveis**: `scripts/`, `docs/`, `README.md`, `.gitignore`
- **Não inclui**: lógica da API nem recursos Terraform (exceto consumir outputs)

## PBT / Resiliency por unidade
| Unidade | PBT | Resiliency |
|---|---|---|
| hello-app | Provável N/A (respostas constantes); documentar | `/health` |
| hello-infra | N/A | single-AZ, destroy/recreate, awslogs |
| hello-tooling-docs | N/A | checklist destroy, validação curl, SSO |
