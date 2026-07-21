# Build Instructions — Fase 2 (HA + ALB)

## Prerequisites
- **AWS CLI v2** + SSO
- **Docker** Desktop/Engine
- **Terraform** CLI
- **PowerShell** 5.1+
- **Python** 3.x + pip (validação local / pytest)
- Policy IAM de estudo aplicada (`docs/ecs-fargate-alb-policy.json`)

## Build Steps

### 1. Dependências locais (app)
```powershell
pip install -r app\requirements.txt
```

### 2. Auth AWS
```powershell
aws sso login
# ou: aws sso login --profile SEU_PERFIL
```

### 3. Infra (Terraform)
```powershell
terraform -chdir=infra init
terraform -chdir=infra plan    # revise replaces se migrando da Fase 1
terraform -chdir=infra apply
```

**Artefatos esperados:** VPC 2 AZs, ALB, TG, Service `desired_count=2`, outputs `alb_dns_name` / `alb_url`.

### 4. Imagem + redeploy
```powershell
.\scripts\build-and-push.ps1
# ou: .\scripts\build-and-push.ps1 -AwsProfile SEU_PERFIL
```

O script imprime o DNS do ALB e exemplos de curl.

### 5. Verificar sucesso
- Script termina sem erro
- Output `alb_dns_name` não vazio: `terraform -chdir=infra output -raw alb_dns_name`
- Após 1–2 min: targets healthy no TG

## Troubleshooting
| Problema | Ação |
|---|---|
| ImagePull / task restart | Rode o script de push |
| Plan com muitos destroys | Migração Fase 1→2; leia plan ou destroy+apply limpo |
| AccessDenied | Atualize policy IAM na conta |
| alb_dns_name falha | Confirme apply Fase 2 com `alb.tf` |
