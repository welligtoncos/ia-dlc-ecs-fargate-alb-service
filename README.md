# Lab Hello World — FastAPI no Amazon ECS Fargate

Projeto didático: container FastAPI → Amazon ECR → ECS Fargate (IP público, sem ALB), infraestrutura 100% Terraform.

**Critério de sucesso:** `terraform apply` → push da imagem → `curl` em `/` e `/health` → `terraform destroy`.

---

## Visão rápida do fluxo

```text
1. aws sso login
2. terraform -chdir=infra apply
3. .\scripts\build-and-push.ps1
4. curl http://<IP>:8000/  e  /health
5. terraform -chdir=infra destroy   ← obrigatório (custo ~zero)
```

---

## Pré-requisitos

| Ferramenta | Uso |
|---|---|
| **AWS CLI v2** + perfil **SSO** | Auth, ECR, ECS, EC2 (IP) |
| **Docker** Desktop/Engine | `docker build` / `push` |
| **Terraform** CLI | `apply` / `destroy` / `output` |
| **PowerShell** | Script oficial de build/push |
| Conta AWS com permissões | Ver policy de estudo em `docs/` |

Opcional: Cursor + AI-DLC já configurados neste repo (seção breve no final).

---

## Validação local (sem AWS)

Faça estes passos **antes** do `terraform apply` para validar a API e a imagem Docker na sua máquina.

### App com Python (pytest + uvicorn)

Na **raiz do repositório**:

```powershell
pip install -r app\requirements.txt
pytest -q
```

Esperado: `2 passed` (`/` e `/health`).

Rodar a API localmente:

```powershell
cd app
uvicorn main:app --host 0.0.0.0 --port 8000
```

Em outro terminal:

```powershell
curl http://127.0.0.1:8000/
curl http://127.0.0.1:8000/health
```

Esperado: `Hello World` e `{"status":"ok","service":"hello-fargate"}`.

### App com Docker

Na **raiz do repositório** (contexto `./app` — não rode `./app` se você já estiver dentro de `app\`):

```powershell
docker build -t hello-fargate:local ./app
docker run --rm -p 8000:8000 hello-fargate:local
```

Se você já estiver em `app\`:

```powershell
docker build -t hello-fargate:local .
docker run --rm -p 8000:8000 hello-fargate:local
```

Em outro terminal:

```powershell
curl http://127.0.0.1:8000/
curl http://127.0.0.1:8000/health
```

Se a porta **8000** estiver ocupada (ex.: uvicorn ainda rodando), use outra porta no host:

```powershell
docker run --rm -p 8001:8000 hello-fargate:local
curl http://127.0.0.1:8001/
```

Para parar o container: `Ctrl+C` no terminal do `docker run`, ou `docker stop <CONTAINER_ID>`.

---

## 1) Autenticar (SSO)

```powershell
aws sso login
# ou, com perfil nomeado:
aws sso login --profile SEU_PERFIL
```

Confirme a região do lab: **us-east-1** (default do Terraform).

---

## 2) Provisionar infraestrutura

```powershell
cd infra
terraform init
terraform plan
terraform apply
cd ..
```

O que sobe (resumo): VPC 1 AZ, subnet pública, SG na porta **8000**, ECR `hello-fargate`, cluster/service Fargate 256/512, CloudWatch Logs, **sem ALB**, **sem autoscaling**.

**State:** local (`.tfstate` no `.gitignore`). Comentário nos `.tf` sobre migração futura para S3.

**Ordem importante:** no primeiro `apply`, o service pode falhar/restartar até existir imagem no ECR. Isso é esperado — em seguida rode o script de push e o force-new-deployment (o script já faz o force).

### Risco de rede (estudo)

A variável `allowed_cidr` default é `0.0.0.0/0` (porta 8000 aberta). Use só em lab; restrinja ao seu IP quando possível:

```powershell
terraform -chdir=infra apply -var="allowed_cidr=SEU.IP.PUBLICO/32"
```

---

## 3) Build, push e redeploy

```powershell
# Na raiz do repositório
.\scripts\build-and-push.ps1

# Com perfil SSO e resolução de IP:
.\scripts\build-and-push.ps1 -AwsProfile SEU_PERFIL -ResolvePublicIp
```

O script:

1. Lê `terraform output` em `./infra` (`ecr_repository_url`, cluster, service, região)
2. Faz login no ECR
3. `docker build` com contexto `./app` e tag `:latest`
4. `docker push`
5. `aws ecs update-service --force-new-deployment`
6. Com `-ResolvePublicIp`, tenta imprimir o IP + exemplos de `curl`

---

## 4) Validar HTTP

Obter IP (se ainda não tiver):

```powershell
terraform -chdir=infra output -raw public_ip
# Se vazio: terraform -chdir=infra output public_ip_cli_fallback
# Ou rode de novo: .\scripts\build-and-push.ps1 -ResolvePublicIp
```

Testes:

```powershell
curl http://<IP>:8000/
# Esperado: Hello World

curl http://<IP>:8000/health
# Esperado: {"status":"ok","service":"hello-fargate"}
```

---

## 5) Destruir (checklist obrigatório)

Marque após validar:

- [ ] `curl` `/` e `/health` OK
- [ ] Entendi o caminho imagem → ECR → task → IP
- [ ] Rodei destroy:

```powershell
terraform -chdir=infra destroy
```

- [ ] Confirmei no console (ou CLI) que VPC/ECS/ECR do prefixo `hello-fargate` sumiram
- [ ] Se restarem imagens órfãs no ECR, apague-as manualmente se o destroy não limpou o repositório conforme esperado

**Exercício de resiliência (mínimo):** depois de um destroy bem-sucedido, você pode `apply` + `build-and-push` de novo para “recriar” o lab (RTO na ordem de horas / recreate manual — alinhado ao escopo de estudo).

---

## Estrutura do repositório

```text
.
├── app/                 # FastAPI + Dockerfile
├── infra/               # Terraform (rede, ECR, IAM, ECS, logs)
├── scripts/
│   └── build-and-push.ps1
├── docs/
│   └── ecs-fargate-alb-policy.json   # policy IAM de estudo (ALB NÃO é provisionado neste lab)
├── tests/               # pytest da API
├── aidlc-docs/          # artefatos do processo AI-DLC (não é código da app)
├── .gitignore
└── README.md
```

Papel de cada bloco Terraform: comentários em português nos arquivos `infra/*.tf`.

---

## Troubleshooting

| Sintoma | Causa provável | Ação |
|---|---|---|
| Task não sobe / ImagePull | ECR sem imagem `:latest` | Rode `.\scripts\build-and-push.ps1` |
| `public_ip` vazio | Task ainda não RUNNING ou ENI atrasada | Aguarde 1–2 min; use `-ResolvePublicIp` ou fallback CLI |
| `AccessDenied` / SSO | Sessão expirada | `aws sso login` (+ `-AwsProfile` se usar) |
| `curl` timeout | SG/`allowed_cidr` ou IP antigo | Confira SG e IP atual da ENI |
| Docker login ECR falha | Credencial ou região | Confira perfil, região `us-east-1`, permissões ECR |

---

## Policy IAM de estudo

Arquivo: [`docs/ecs-fargate-alb-policy.json`](docs/ecs-fargate-alb-policy.json).

Serve para estudar permissões (inclui ações de ALB na policy de aprendizado). **Este lab não cria ALB** — só Fargate com IP público.

Exemplos (ajuste conta/caminho):

```powershell
aws iam create-policy --policy-name EcsFargateAlbLearning --policy-document file://docs/ecs-fargate-alb-policy.json
```

---

## Processos da organização (placeholders)

| Tema | Nota |
|---|---|
| Change management | Use o **processo formal da organização** (ferramenta TBD — preencher quando conhecido) |
| Incidentes | Use o **processo existente da organização** (nome TBD) |
| CI/CD | Fora de escopo — deploy **manual** (`terraform` + script) |

---

## AI-DLC (breve)

Este workspace já pode ter o **AI-DLC** configurado (`.cursor/rules/`, `.aidlc-rule-details/`). Artefatos do fluxo ficam em `aidlc-docs/`; código da aplicação fica na raiz (`app/`, `infra/`, `scripts/`).

Se precisar **instalar do zero** no Cursor (Windows/PowerShell), pacote em `%USERPROFILE%\Downloads\aidlc-rules`:

```powershell
New-Item -ItemType Directory -Force -Path ".cursor\rules" | Out-Null
$frontmatter = @"
---
description: "AI-DLC (AI-Driven Development Life Cycle) adaptive workflow for software development"
alwaysApply: true
---

"@
$frontmatter | Out-File -FilePath ".cursor\rules\ai-dlc-workflow.mdc" -Encoding utf8
Get-Content "$env:USERPROFILE\Downloads\aidlc-rules\aws-aidlc-rules\core-workflow.md" |
  Add-Content ".cursor\rules\ai-dlc-workflow.mdc"
New-Item -ItemType Directory -Force -Path ".aidlc-rule-details"
Copy-Item "$env:USERPROFILE\Downloads\aidlc-rules\aws-aidlc-rule-details\*" ".aidlc-rule-details\" -Recurse
```

Verifique: `Test-Path ".aidlc-rule-details\common\process-overview.md"`.

---

## Escopo fora deste lab

- Application Load Balancer / HTTPS / multi-AZ / autoscaling
- Pipeline CI/CD
- Backend remoto de state (S3) — só comentário de futuro
- Security Baseline AI-DLC (desabilitada neste projeto)
