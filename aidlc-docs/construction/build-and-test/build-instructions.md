# Build Instructions — Lab Hello Fargate

## Prerequisites
- **OS**: Windows + PowerShell (comandos abaixo)
- **Python** 3.12+ (para pytest/uvicorn local)
- **Docker** Desktop/Engine (imagem local e push ECR)
- **Terraform** CLI + **AWS CLI v2** + SSO (fluxo AWS)
- **Dependências Python**: `app/requirements.txt`

## Build Steps

### 1. Instalar dependências da app (local)

Na raiz do repositório:

```powershell
pip install -r app\requirements.txt
```

### 2. Build da imagem Docker (local)

```powershell
# Na raiz do repo (contexto ./app)
docker build -t hello-fargate:local ./app
```

Se estiver dentro de `app\`:

```powershell
docker build -t hello-fargate:local .
```

### 3. Build / provisionamento AWS (lab completo)

```powershell
aws sso login
terraform -chdir=infra init
terraform -chdir=infra plan
terraform -chdir=infra apply
.\scripts\build-and-push.ps1
```

O script faz: login ECR → `docker build ./app` → push `:latest` → force-new-deployment.

### 4. Verificar sucesso

| Artefato | Como verificar |
|---|---|
| Dependências Python | `pip show fastapi uvicorn pytest` |
| Imagem local | `docker images hello-fargate:local` |
| Infra | `terraform -chdir=infra output` |
| Imagem no ECR | Console ECR ou `aws ecr describe-images` |

## Troubleshooting

| Problema | Causa | Solução |
|---|---|---|
| `path "./app" not found` | Build rodado de dentro de `app\` | Use `./app` na raiz ou `.` em `app\` |
| `terraform output` falha | Apply ainda não rodou | `terraform -chdir=infra apply` |
| Docker login ECR | SSO expirado | `aws sso login` |
| Task sem imagem | Push não feito | `.\scripts\build-and-push.ps1` |
