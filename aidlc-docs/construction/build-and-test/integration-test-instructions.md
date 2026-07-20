# Integration Test Instructions — Lab Hello Fargate

## Purpose
Validar interações entre `hello-app` (imagem), `hello-infra` (outputs/ECS) e `hello-tooling-docs` (script/README).

## Scenario 1 — API em Docker local (app + Dockerfile)

### Setup
```powershell
docker build -t hello-fargate:local ./app
docker run --rm -d -p 8000:8000 --name hello-local hello-fargate:local
```

### Steps
```powershell
curl http://127.0.0.1:8000/
curl http://127.0.0.1:8000/health
```

### Expected
- `/` → `Hello World`
- `/health` → JSON com `"status":"ok"` e `"service":"hello-fargate"`

### Cleanup
```powershell
docker stop hello-local
```

## Scenario 2 — Script lê outputs Terraform (tooling ↔ infra)

### Setup
Infra já aplicada (`terraform apply` em `infra/`).

### Steps
```powershell
terraform -chdir=infra output -raw ecr_repository_url
terraform -chdir=infra output -raw ecs_cluster_name
terraform -chdir=infra output -raw ecs_service_name
# O script usa os mesmos outputs:
.\scripts\build-and-push.ps1 -ResolvePublicIp
```

### Expected
- Script completa login ECR, build, push e force-new-deployment sem erro
- Com `-ResolvePublicIp`, imprime IP ou orienta fallback

### Cleanup
Não necessário até o destroy do lab.

## Scenario 3 — E2E AWS (lab completo)

### Steps
1. `aws sso login`
2. `terraform -chdir=infra apply`
3. `.\scripts\build-and-push.ps1 -ResolvePublicIp`
4. Aguardar task RUNNING
5. `curl http://<IP>:8000/` e `/health`
6. `terraform -chdir=infra destroy`

### Expected
Hello World via IP público; recursos removidos após destroy.

## Contract / Security
- **Contract tests**: N/A (API mínima documentada no README)
- **Security tests**: N/A (Security Baseline OFF); risco `allowed_cidr` documentado
