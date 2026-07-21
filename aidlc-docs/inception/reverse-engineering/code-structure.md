# Code Structure — Fase 1

```text
.
├── app/                 # FastAPI + Dockerfile
│   ├── api.py           # GET / , GET /health
│   ├── main.py          # FastAPI app + handler 500
│   ├── Dockerfile
│   └── requirements.txt
├── tests/               # pytest (TestClient)
├── infra/               # Terraform
│   ├── network.tf       # VPC 1 AZ
│   ├── ecr.tf
│   ├── iam.tf
│   ├── logs.tf
│   ├── ecs.tf           # cluster + task def + service (desired=1, sem ALB)
│   ├── variables.tf
│   ├── outputs.tf       # IP via script/CLI (public_ip null)
│   └── ...
├── scripts/build-and-push.ps1
├── docs/ecs-fargate-alb-policy.json
└── README.md
```

## Observação
`infra/terraform.tfstate` pode existir localmente (lab ativo) — não versionar (`.gitignore`).
