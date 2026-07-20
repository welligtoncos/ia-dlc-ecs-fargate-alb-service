# Plano de Code Generation — `hello-tooling-docs`

## Contexto
- Unidade 3/3: scripts, README unificado, `.gitignore`, policy IAM em `docs/`
- Depende de: outputs Terraform (`infra/`) + imagem Docker (`app/`)
- Idioma: pt-BR nos docs; PowerShell no script
- Design: ScriptBuildPush, DocLabOrchestration, GitIgnore, IamPolicyDoc

## Passos

### Passo 1 — Estrutura
- [x] Criar `scripts/` e `docs/` na raiz do workspace

### Passo 2 — `scripts/build-and-push.ps1` (ScriptBuildPush)
- [x] `$ErrorActionPreference = 'Stop'`
- [x] Parâmetros: `[string]$AwsProfile` (opcional), `[switch]$ResolvePublicIp`
- [x] Resolver raiz do repo a partir de `$PSScriptRoot` → `InfraDir=./infra`, `AppDir=./app`
- [x] Ler outputs via `terraform -chdir=$InfraDir output -raw`: `ecr_repository_url`, `aws_region`, `ecs_cluster_name`, `ecs_service_name` (e `public_ip` se `-ResolvePublicIp`)
- [x] `aws ecr get-login-password` + `docker login`
- [x] `docker build -t <repo>:latest ./app` (contexto `./app`)
- [x] `docker push <repo>:latest`
- [x] `aws ecs update-service --force-new-deployment`
- [x] Se `-ResolvePublicIp`: imprimir IP (output TF ou fallback CLI ENI) + exemplos de curl `:8000/` e `/health`
- [x] Comentários didáticos em português; suporte a `$AwsProfile` nas chamadas AWS quando informado

### Passo 3 — `.gitignore` (GitIgnore)
- [x] Cobrir: `.terraform/`, `*.tfstate*`, `crash.log`, `.terraform.tfvars` / `*.auto.tfvars` (exceto exemplos se houver), `__pycache__/`, `*.pyc`, `.venv/`, `venv/`, `.env`, `.idea/`, `.vscode/` (ou padrão IDE), `.DS_Store`
- [x] **Não** ignorar `*.terraform.lock.hcl` (pode ser commitado)

### Passo 4 — Mover policy IAM (IamPolicyDoc)
- [x] Mover `ecs-fargate-alb-policy.json` (raiz) → `docs/ecs-fargate-alb-policy.json`
- [x] Remover cópia na raiz após move

### Passo 5 — `README.md` unificado (DocLabOrchestration)
- [x] Reescrever README: (1) AI-DLC breve + (2) lab Fargate como conteúdo principal
- [x] Seções numeradas: pré-requisitos → SSO → `terraform apply` → `build-and-push.ps1` → curl `/` e `/health` → `terraform destroy` (checklist obrigatório)
- [x] Documentar risco de `allowed_cidr` aberto; troubleshooting (task sem imagem, IP vazio, SSO)
- [x] Referenciar `docs/ecs-fargate-alb-policy.json` (estudo; ALB fora do provisionamento)
- [x] Placeholders: processo de change management / incidentes da organização (TBD)
- [x] Manter o essencial do setup AI-DLC em seção curta (não descartar por completo)

### Passo 6 — Resumo
- [x] `aidlc-docs/construction/hello-tooling-docs/code/generation-summary.md`

### Passo 7 — Validação
- [x] Conferir alinhamento com NFR/infra design e RFs (RF-03, RF-08, CS-4)

## Fora deste plano
- Alterar Terraform em `infra/`
- Alterar código FastAPI / Dockerfile
- `terraform apply` / push real para AWS

## Compliance
| Extension | Status |
|---|---|
| PBT | N/A (sem propriedades de domínio) |
| Resiliency | Documentar curl + destroy/recreate no README |
| Security | OFF / N/A; avisar CIDR aberto no README |
