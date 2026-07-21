# Lab Hello World — FastAPI no ECS Fargate + ALB (HA didática)

Projeto didático (**Fase 2**): container FastAPI → Amazon ECR → ECS Fargate (**2 tasks / 2 AZs**) atrás de um **Application Load Balancer** público. Infraestrutura 100% Terraform. App FastAPI **intacta** (`/` e `/health`).

**Critério de sucesso:** `terraform apply` → push da imagem → `curl` no **DNS do ALB** em `/` e `/health` → exercício self-healing → `terraform destroy`.

**Custo:** ALB + 2× Fargate (256/512) geram cobrança enquanto existirem. **Destroy ao final é obrigatório.**

---

## Fluxo completo na AWS (copiar e colar)

Na **raiz do repositório**, com Docker Desktop ligado e policy IAM ok:

```powershell
# 1) Auth
aws sso login
# ou: aws sso login --profile SEU_PERFIL

# 2) Infra (Fase 2: 2 AZs + ALB + desired=2)
# Se você já tinha a Fase 1 aplicada: revise o plan — pode haver replace de subnet/SG.
terraform -chdir=infra init
terraform -chdir=infra plan
terraform -chdir=infra apply

# 3) Imagem + redeploy (imprime DNS do ALB)
.\scripts\build-and-push.ps1
# ou: .\scripts\build-and-push.ps1 -AwsProfile SEU_PERFIL

# 4) Testar via ALB (porta 80 — SEM :8000)
curl http://<ALB-DNS>/
curl http://<ALB-DNS>/health
# Esperado: Hello World  e  {"status":"ok","service":"hello-fargate"}

# 5) Self-healing (opcional, didático) — ver seção abaixo

# 6) Desligar (obrigatório)
terraform -chdir=infra destroy
```

DNS do ALB (se o script já rodou):

```powershell
terraform -chdir=infra output -raw alb_dns_name
```

**Caminho oficial alternativo (IP da task):** `.\scripts\build-and-push.ps1 -ResolvePublicIp` — útil para estudar ENI; o SG da task só libera **8000 a partir do ALB**, então curl direto no IP pode falhar. Prefira o DNS.

**Apply ok:** outputs incluem `alb_dns_name`, `alb_url`, `ecs_cluster_name=hello-fargate`, `vpc_id`. As tasks só respondem no ALB **depois** do passo 3 (imagem no ECR) e targets healthy.

---

## Arquitetura (visão rápida)

```text
Internet
   |
   v
 ALB :80  (2 AZs)  -->  Target Group (ip:8000, HC GET /health)
                           |
              +------------+------------+
              |                         |
         Task A (AZ-a)            Task B (AZ-b)
         FastAPI :8000            FastAPI :8000
         (IP público p/ ECR/logs; tráfego HTTP via ALB)
```

**Fora deste lab (de propósito):** HTTPS/ACM, NAT Gateway, autoscaling, multi-região, CI/CD.

---

## Exercício self-healing (didático)

Com o lab no ar (`curl` no ALB OK) e `desired_count=2`:

```powershell
$cluster = "hello-fargate"
$service = "hello-fargate"
$region  = "us-east-1"

# 1) Listar tasks RUNNING
aws ecs list-tasks --cluster $cluster --service-name $service --desired-status RUNNING --region $region

# 2) Escolher UMA task ARN e pará-la
aws ecs stop-task --cluster $cluster --task <TASK-ARN> --region $region

# 3) Observar o service recriar até runningCount=2
aws ecs describe-services --cluster $cluster --services $service --region $region `
  --query "services[0].{desired:desiredCount,running:runningCount,pending:pendingCount}"
```

**No console (us-east-1):**
- **ECS** → cluster `hello-fargate` → Service → Tasks: uma some e outra nasce
- **EC2** → Target Groups → `hello-fargate-tg` → Targets: unhealthy breve, depois healthy de novo
- **ALB**: `curl http://<ALB-DNS>/health` deve voltar a responder (pode haver falha curta durante o replace)

Isso demonstra self-healing do **ECS Service + health check do TG** — não é HA multi-região de produção.

---

## Guia de aprendizado no console AWS

Use com o lab no ar. Região: **us-east-1**.

### O que você montou

Imagem no **ECR**, **2 tasks Fargate** em **2 subnets públicas**, **ALB** recebendo HTTP :80, **TG** checando `/health` na porta 8000, SG da task só aceitando tráfego do SG do ALB.

### Lições-chave

| Lição | O que olhar | Por quê |
|---|---|---|
| 2 AZs | VPC → Subnets `hello-fargate-public-subnet-a/b` | ALB exige ≥2 AZs; tasks distribuídas |
| ALB | EC2 → Load Balancers → `hello-fargate-alb` | Ponto único de DNS para o lab |
| Target Group | TG → Health checks path `/health` | Só targets healthy recebem tráfego |
| SG em camadas | SG alb (80 do `allowed_cidr`) → SG task (8000 só do alb) | Tasks não ficam abertas na internet na :8000 |
| Service desired=2 | ECS Service desired/running | Base do exercício self-healing |
| Logs | CloudWatch `/ecs/hello-fargate` | Debug se target unhealthy |

**Pergunta:** por que o curl no ALB não usa `:8000`? → Listener do ALB é **:80**; o ALB fala com as tasks na **8000**.

---

## Validar na AWS (CLI rápido)

```powershell
terraform -chdir=infra output
aws elbv2 describe-target-health --target-group-arn $(terraform -chdir=infra output -raw target_group_arn) --region us-east-1
aws ecs describe-services --cluster hello-fargate --services hello-fargate --region us-east-1 --query "services[0].{status:status,running:runningCount,desired:desiredCount}"
aws ecs list-tasks --cluster hello-fargate --service-name hello-fargate --desired-status RUNNING --region us-east-1
aws logs tail /ecs/hello-fargate --since 10m --region us-east-1
```

---

## Pré-requisitos

| Ferramenta | Uso |
|---|---|
| **AWS CLI v2** + perfil **SSO** | Auth, ECR, ECS, ELB, EC2 |
| **Docker** Desktop/Engine | `docker build` / `push` |
| **Terraform** CLI | `apply` / `destroy` / `output` |
| **PowerShell** | Script oficial de build/push |
| Conta AWS com permissões | Policy de estudo em `docs/` (inclui ELB) |

---

## Validação local (sem AWS)

### App com Python (pytest + uvicorn)

```powershell
pip install -r app\requirements.txt
pytest -q
```

Esperado: `2 passed`.

```powershell
cd app
uvicorn main:app --host 0.0.0.0 --port 8000
```

```powershell
curl http://127.0.0.1:8000/
curl http://127.0.0.1:8000/health
```

### App com Docker

```powershell
docker build -t hello-fargate:local ./app
docker run --rm -p 8000:8000 hello-fargate:local
```

```powershell
curl http://127.0.0.1:8000/
curl http://127.0.0.1:8000/health
```

---

## 1) Autenticar (SSO)

```powershell
aws sso login
# ou: aws sso login --profile SEU_PERFIL
```

Região do lab: **us-east-1**.

---

## 2) Provisionar infraestrutura

```powershell
terraform -chdir=infra init
terraform -chdir=infra plan    # revise replaces se vinha da Fase 1
terraform -chdir=infra apply
```

O que sobe (resumo): VPC **2 AZs**, 2 subnets públicas, SG alb + SG task, **ALB** + listener :80 + TG (HC `/health`), ECR `hello-fargate`, cluster/service Fargate **desired=2**, CloudWatch Logs. **Sem autoscaling. Sem HTTPS.**

**Migração Fase 1 → 2:** apply in-place pode **destruir/recriar** subnet/SG. Leia o `plan` com atenção. Alternativa: `destroy` completo e `apply` limpo.

**State:** local (`.tfstate` no `.gitignore`).

**Ordem:** no 1º apply as tasks podem falhar até existir imagem `:latest` no ECR — rode o script em seguida.

### Risco de rede (estudo)

`allowed_cidr` default `0.0.0.0/0` libera **HTTP :80 no ALB**. Lab apenas; restrinja ao seu IP quando possível:

```powershell
terraform -chdir=infra apply -var="allowed_cidr=SEU.IP.PUBLICO/32"
```

---

## 3) Build, push e redeploy

```powershell
.\scripts\build-and-push.ps1
# ou: .\scripts\build-and-push.ps1 -AwsProfile SEU_PERFIL
```

O script:

1. Lê outputs Terraform (`ecr_repository_url`, cluster, service, região)
2. Login ECR → `docker build ./app` → push `:latest`
3. `ecs update-service --force-new-deployment`
4. **Sempre** imprime `alb_dns_name` + exemplos de curl
5. Com `-ResolvePublicIp`, tenta IP da task (alternativo)

---

## 4) Validar HTTP (ALB)

```powershell
curl http://<ALB-DNS>/
curl http://<ALB-DNS>/health
```

Sem `:8000` no host do ALB.

---

## 5) Destruir (checklist obrigatório)

- [ ] `curl` no ALB `/` e `/health` OK
- [ ] (Opcional) Exercício self-healing feito
- [ ] Entendi: Internet → ALB → TG → 2 tasks
- [ ] Rodei destroy:

```powershell
terraform -chdir=infra destroy
```

- [ ] Confirmei no console que VPC/ALB/ECS/ECR do prefixo `hello-fargate` sumiram
- [ ] Imagens órfãs no ECR: apague manualmente se necessário

---

## Estrutura do repositório

```text
.
├── app/                 # FastAPI + Dockerfile (intacta na Fase 2)
├── infra/               # Terraform HA: network, alb, ecs, ecr, iam, logs
├── scripts/
│   └── build-and-push.ps1
├── docs/
│   └── ecs-fargate-alb-policy.json   # policy IAM de estudo (cobre ALB/ELB)
├── tests/
├── aidlc-docs/
├── .gitignore
└── README.md
```

---

## Troubleshooting

| Sintoma | Causa provável | Ação |
|---|---|---|
| Task não sobe / ImagePull | ECR sem `:latest` | `.\scripts\build-and-push.ps1` |
| Target unhealthy | App/HC ou SG | Confira `/health` local; TG path `/health`; SG task←alb |
| `curl` ALB timeout | SG alb / `allowed_cidr` / DNS errado | Output `alb_dns_name`; SG :80; aguarde healthy |
| `alb_dns_name` falha no script | Apply sem ALB / state antigo | `terraform apply` Fase 2 |
| Replace inesperado no plan | Migração Fase 1→2 | Leia plan; ou destroy+apply limpo |
| `AccessDenied` | Policy IAM | Atualize `docs/ecs-fargate-alb-policy.json` na conta |
| Curl no IP :8000 falha | Esperado (SG só do ALB) | Use DNS do ALB |

---

## Policy IAM de estudo

Arquivo: [`docs/ecs-fargate-alb-policy.json`](docs/ecs-fargate-alb-policy.json).

Cobre o lab **com ALB** (ações `elasticloadbalancing:*` de create/describe/modify LB, TG, listener, register targets, etc.) além de VPC/ECS/ECR/logs.

### Criar / atualizar policy

```powershell
aws iam create-policy --policy-name EcsFargateAlbLearning --policy-document file://docs/ecs-fargate-alb-policy.json
```

```powershell
$arn = aws iam list-policies --scope Local --query "Policies[?PolicyName=='EcsFargateAlbLearning'].Arn" --output text
aws iam create-policy-version --policy-arn $arn --policy-document file://docs/ecs-fargate-alb-policy.json --set-as-default
```

---

## Processos da organização (placeholders)

| Tema | Nota |
|---|---|
| Change management | Processo formal da organização (TBD) |
| Incidentes | Processo existente da organização (TBD) |
| CI/CD | Fora de escopo — deploy manual |

---

## AI-DLC (breve)

Artefatos do fluxo em `aidlc-docs/`; código em `app/`, `infra/`, `scripts/`. Regras: `.cursor/rules/`, `.aidlc-rule-details/`.

Instalação do zero (Windows): pacote em `%USERPROFILE%\Downloads\aidlc-rules` — copie `core-workflow.md` para `.cursor/rules/ai-dlc-workflow.mdc` e os rule-details para `.aidlc-rule-details/`.

---

## Escopo fora deste lab

- HTTPS / certificado ACM
- NAT Gateway / tasks só privadas
- Autoscaling / multi-região
- Pipeline CI/CD
- Backend remoto de state (S3)
- Security Baseline AI-DLC (OFF neste projeto)
