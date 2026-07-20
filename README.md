# Lab Hello World — FastAPI no Amazon ECS Fargate

Projeto didático: container FastAPI → Amazon ECR → ECS Fargate (IP público, sem ALB), infraestrutura 100% Terraform.

**Critério de sucesso:** `terraform apply` → push da imagem → `curl` em `/` e `/health` → `terraform destroy`.

---

## Fluxo completo na AWS (copiar e colar)

Na **raiz do repositório**, com Docker Desktop ligado e policy IAM ok:

```powershell
# 1) Auth
aws sso login
# ou: aws sso login --profile SEU_PERFIL

# 2) Infra
terraform -chdir=infra init
terraform -chdir=infra apply

# 3) Imagem + redeploy (+ tenta imprimir o IP)
.\scripts\build-and-push.ps1 -ResolvePublicIp
# ou: .\scripts\build-and-push.ps1 -AwsProfile SEU_PERFIL -ResolvePublicIp

# 4) Testar (use o IP impresso pelo script; NÃO use output -raw public_ip — fica null neste lab)
curl http://<IP>:8000/
curl http://<IP>:8000/health
# Esperado: Hello World  e  {"status":"ok","service":"hello-fargate"}

# 5) Desligar (obrigatório — custo ~zero)
terraform -chdir=infra destroy
```

Se o script não imprimir IP, aguarde 1–2 min (task RUNNING) e rode de novo só a resolução:

```powershell
.\scripts\build-and-push.ps1 -ResolvePublicIp
# ou veja: terraform -chdir=infra output public_ip_cli_fallback
```

**Apply ok (exemplo):** ao final você deve ver outputs como `ecr_repository_url`, `ecs_cluster_name=hello-fargate`, `vpc_id=vpc-...`. A task só responde no `curl` **depois** do passo 3 (imagem no ECR).

---

## Guia de aprendizado no console AWS

Use esta seção **com o lab já no ar** (`apply` + `build-and-push` + `curl` OK). Região: **us-east-1**.

Objetivo: entender **por que** cada botão do console existe — não só “achar o recurso”.

### A história em uma frase

Você empacotou a API em uma **imagem Docker**, guardou no **ECR**, pediu ao **ECS/Fargate** para rodar **1 container** dentro de uma **VPC pública**, liberou a porta **8000** no **Security Group**, e leu o resultado com **curl** (e os logs no **CloudWatch**).

```text
  [Seu PC]
     |  docker build + push (script)
     v
  [ECR]  imagem hello-fargate:latest
     |  ECS puxa a imagem
     v
  [Task Fargate]  = container com FastAPI na porta 8000
     |  vive dentro de
     v
  [VPC → Subnet pública → IGW]  +  [Security Group :8000]
     |
     +--> Internet --> curl http://IP:8000/
     +--> CloudWatch Logs  (o que o uvicorn escreveu)
```

**Analogia rápida**

| Peça AWS | Analogia |
|---|---|
| ECR | Prateleira de caixas (imagens) no depósito |
| Task definition | Receita impressa: “abra esta caixa, use 0,25 vCPU, porta 8000…” |
| Cluster | Galpão onde as máquinas virtuais do Fargate trabalham |
| Service | Chefe de turno: “quero sempre 1 caixa aberta; se fechar, abre outra” |
| Task | A caixa **aberta agora** (processo rodando) |
| VPC / subnet / IGW | Condomínio + rua + portão para a avenida (internet) |
| Security Group | Porteiro: só deixa entrar quem bate na porta 8000 |
| Execution role | Crachá do **operário** que busca a caixa no depósito e anexa o relatório de logs |
| Task role | Crachá do **app** (neste lab quase não usa) |
| CloudWatch Logs | Caderno de bordo do container |

**Fora deste lab (de propósito):** ALB, HTTPS, várias AZs, autoscaling. Aqui o navegador/curl fala **direto** com o IP da task.

---

### Lição 1 — ECR (a imagem)

**Console:** Amazon ECR → Repositories → `hello-fargate`

**O que aprender:** a AWS não “compila” seu Python. Ela **baixa uma imagem** pronta. Se não houver tag `latest`, a task falha ao puxar (ImagePull).

**Olhe:** Images → tag `latest` → digest (igual ao do `docker push`).

**Pergunta:** se eu mudar só o código Python e **não** rodar o script de push, o que a task em produção continua rodando? → A imagem antiga no ECR.

---

### Lição 2 — Task definition (a receita)

**Console:** ECS → Task definitions → `hello-fargate`

**O que aprender:** é o **contrato** do container: qual imagem, CPU (`256`), memória (`512`), porta (`8000`), roles IAM e para onde vão os logs.

**Olhe:** container `hello-fargate` → Image URI do ECR; Log configuration → grupo `/ecs/hello-fargate`.

**Pergunta:** cluster e service mudam a receita? → Não. Eles **usam** uma revisão da task definition.

---

### Lição 3 — Cluster, Service e Task (quem manda no container)

**Console:** ECS → Clusters → `hello-fargate`

1. **Cluster** — só o “lugar”. Sozinho não serve Hello World.
2. **Services** → `hello-fargate` — `Desired tasks = 1`. É quem **mantém** a quantidade. O script chama `force-new-deployment` para o service **recriar** a task com a imagem nova.
3. **Tasks** — abra a task **RUNNING**:
   - Status = container vivo
   - **Configuration / Networking** = Public IP (o do seu `curl`)
   - **Logs** = atalho para CloudWatch

**Pergunta:** qual diferença entre Service e Task? → Service = desejo contínuo; Task = execução atual (pode ser substituída).

---

### Lição 4 — VPC, subnet, IGW e rota (como o IP chega em você)

**Console:** VPC

| Onde | Nome | Ideia |
|---|---|---|
| Your VPCs | `hello-fargate-vpc` | Rede privada do lab (`10.0.0.0/16`) |
| Subnets | `hello-fargate-public-subnet` | Pedacinho em **1 AZ**; task mora aqui |
| Internet gateways | `hello-fargate-igw` | “Portão” VPC ↔ internet |
| Route tables | `hello-fargate-public-rt` | Rota `0.0.0.0/0` → IGW (subnet pública de verdade) |

**O que aprender:** `assign_public_ip = true` **não basta** sem IGW + rota. Sem isso, o `curl` da sua máquina não chega na task.

**Pergunta:** por que 1 AZ só? → Lab barato e simples; produção costuma usar várias AZs + ALB.

---

### Lição 5 — Security Group (o porteiro)

**Console:** EC2 → Security Groups → `hello-fargate-task-sg`

**O que aprender:** mesmo com IP público, sem regra **Inbound TCP 8000** o `curl` dá timeout.

**Olhe:** Inbound = 8000; Outbound = amplo (precisa sair para ECR e CloudWatch).

**Pergunta:** abrir `0.0.0.0/0` na 8000 é ok? → Só em lab. Em estudo sério, restrinja ao seu IP (`allowed_cidr`).

---

### Lição 6 — IAM (dois crachás diferentes)

**Console:** IAM → Roles

| Role | Quem usa? | Para quê? |
|---|---|---|
| `hello-fargate-execution-role` | Agente do ECS (antes/durante o start) | Baixar imagem no ECR + criar streams de log |
| `hello-fargate-task-role` | Código **dentro** do container | Chamar APIs AWS (S3, etc.). Hello World quase não precisa |

**Pergunta:** se faltar a execution role, o sintoma típico é? → Task não puxa imagem ou não escreve logs.

---

### Lição 7 — CloudWatch Logs (quando o curl falha)

**Console:** CloudWatch → Log groups → `/ecs/hello-fargate`

**O que aprender:** se a task está STOPPED ou o `curl` falha, o log mostra se o uvicorn subiu, se a imagem errou, etc.

**Olhe:** stream mais recente → linhas do Uvicorn (“Application startup complete”).

---

### Roteiro sugerido (15–20 min no console)

Siga nesta ordem — acompanha o fluxo real do request:

1. ECR → confirme `latest` (origem da app).
2. Task definition → leia image, CPU, porta, log group (receita).
3. Cluster → Service → Desired/Running = 1 (chefe de turno).
4. Task RUNNING → anote Public IP → abra Logs (instância viva).
5. No navegador: `http://<IP>:8000/` e `/health` (mesmo resultado do curl).
6. VPC → subnet → IGW → route table (caminho de rede).
7. Security Group → regra 8000 (porteiro).
8. IAM → as duas roles (crachás).
9. Quando terminar o estudo: `terraform -chdir=infra destroy` e confira se os recursos sumiram.

### CLI (atalhos, mesma ideia)

```powershell
aws sts get-caller-identity
terraform -chdir=infra output
aws ecr describe-images --repository-name hello-fargate --region us-east-1
aws ecs describe-services --cluster hello-fargate --services hello-fargate --region us-east-1 --query "services[0].{status:status,running:runningCount,desired:desiredCount}"
aws ecs list-tasks --cluster hello-fargate --service-name hello-fargate --desired-status RUNNING --region us-east-1
aws logs tail /ecs/hello-fargate --since 10m --region us-east-1
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

Ver **Fluxo completo na AWS** (passo 1). Resumo:

```powershell
aws sso login
# ou: aws sso login --profile SEU_PERFIL
```

Região do lab: **us-east-1**.

---

## 2) Provisionar infraestrutura

```powershell
terraform -chdir=infra init
terraform -chdir=infra apply
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
.\scripts\build-and-push.ps1 -ResolvePublicIp
# ou: .\scripts\build-and-push.ps1 -AwsProfile SEU_PERFIL -ResolvePublicIp
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

Use o IP impresso pelo script (`-ResolvePublicIp`). O output `public_ip` do Terraform fica **null** neste lab.

```powershell
curl http://<IP>:8000/
curl http://<IP>:8000/health
```

Para validar recursos no console/CLI, veja **Validar na AWS** acima.

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
| `public_ip` null / sem IP | Esperado no TF; task ainda subindo | Use `-ResolvePublicIp` após push; aguarde task RUNNING |
| `AccessDenied` / SSO | Sessão expirada | `aws sso login` (+ `-AwsProfile` se usar) |
| `ec2:CreateVpc` / `logs:ListTagsForResource` negado | Policy IAM incompleta no usuário | Atualize `docs/ecs-fargate-alb-policy.json` na conta (seção Policy IAM) e rode `apply` de novo |
| `curl` timeout | SG/`allowed_cidr` ou IP antigo | Confira SG e IP atual da ENI |
| Docker login ECR falha | Credencial ou região | Confira perfil, região `us-east-1`, permissões ECR |

---

## Policy IAM de estudo

Arquivo: [`docs/ecs-fargate-alb-policy.json`](docs/ecs-fargate-alb-policy.json).

Serve para estudar permissões (inclui ações de ALB na policy de aprendizado). **Este lab não cria ALB** — só Fargate com IP público.

A policy precisa permitir **criar VPC** (`ec2:CreateVpc`, subnet, IGW, rotas…) e **tags de logs** (`logs:ListTagsForResource`). Sem isso o `terraform apply` falha com `AccessDenied` / `UnauthorizedOperation` (ex.: usuário `usuario-dados`).

### Criar policy (primeira vez)

```powershell
aws iam create-policy --policy-name EcsFargateAlbLearning --policy-document file://docs/ecs-fargate-alb-policy.json
```

Anexe ao usuário/role (ajuste o nome):

```powershell
$arn = aws iam list-policies --scope Local --query "Policies[?PolicyName=='EcsFargateAlbLearning'].Arn" --output text
aws iam attach-user-policy --user-name usuario-dados --policy-arn $arn
```

### Atualizar policy já existente (versão nova)

```powershell
$arn = aws iam list-policies --scope Local --query "Policies[?PolicyName=='EcsFargateAlbLearning'].Arn" --output text
aws iam create-policy-version --policy-arn $arn --policy-document file://docs/ecs-fargate-alb-policy.json --set-as-default
```

(Admin da conta precisa rodar isso se o seu usuário não puder gerenciar IAM.)

### Depois de corrigir permissões

O apply anterior pode ter criado recursos parciais (ECR, cluster, roles, log group). Rode de novo:

```powershell
terraform -chdir=infra apply
```

Se preferir limpar e recomeçar:

```powershell
terraform -chdir=infra destroy
terraform -chdir=infra apply
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
