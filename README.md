# Lab Hello World — FastAPI no ECS Fargate + ALB

Lab didático para aprender o fluxo **imagem → ECR → ECS Fargate → internet**, e depois o papel do **ECS Service** e do **Application Load Balancer (ALB)**.

API: **FastAPI** (`GET /` → Hello World, `GET /health` → status). Infra: **Terraform**. App não muda entre as fases.

**Custo:** enquanto existir, ALB + 2 tasks Fargate cobram. No fim: `terraform -chdir=infra destroy` (**obrigatório**).

---

## O que este lab ensina (2 objetivos)

### Objetivo 1 — Fluxo completo (ponto de partida)

Entender o caminho mínimo:

1. Empacotar a API em um **container**
2. Guardar a imagem no **ECR**
3. Descrever como rodar (CPU, memória, porta, roles) na **Task Definition**
4. Subir uma **Task** no **Fargate**
5. Acessar a API pela internet

Na prática deste repo a Fase 1 já usava um **ECS Service com `desired_count=1`** (não uma “task solta” no console). Isso prepara o Objetivo 2 sem mudar o modelo mental.

### Objetivo 2 — Service + ALB (estado atual do código)

Evolução: o **Service** mantém **2 tasks** em **2 AZs**, atrás de um **ALB**. Você sente:

- o Service como **guardião** (`desired` vs `running`)
- o ALB **distribuindo tráfego** e só mandando para targets **healthy**
- self-healing: matar 1 task → o Service sobe outra

**Critério de sucesso:** apply → push → `curl` no DNS do ALB (`/` e `/health`) → (opcional) self-healing → **destroy**.

---

## Glossário ECS (leia antes de clicar no console)

| Conceito | Analogia | Neste lab |
|---|---|---|
| **ECR** | “Depósito” de imagens Docker | Repositório `hello-fargate` |
| **Cluster** | “Sala” onde as tasks existem | Cluster `hello-fargate` |
| **Task Definition** | **Receita**: imagem, CPU/mem, porta, roles, logs | Família `hello-fargate` (256 CPU / 512 MB) |
| **Task** | **Uma execução** da receita (1 container FastAPI) | 2 tasks RUNNING (Fase 2) |
| **Service** | **Guardião**: “quero N tasks sempre”; redeploy; liga no ALB | Service `hello-fargate`, `desired_count=2` |
| **Fargate** | Capacidade gerenciada (você não administra EC2) | `launch_type = FARGATE` |
| **ALB** | Porta de entrada HTTP com DNS estável | `hello-fargate-alb` (porta **80**) |
| **Target Group** | Lista de IPs das tasks + health check | HC `GET /health` na porta **8000** |

### Task Definition × Task × Service

```text
Task Definition  =  receita (como deve ser)
       |
       v
     Task        =  uma execução concreta da receita
       ^
       |
   Service       =  "mantenha desired_count tasks dessa definição
                    e registre-as no Target Group do ALB"
```

- Sem Service: você sobe/para tasks na mão; se uma morrer, **nada** garante que outra nasça.
- Com Service: você diz `desired_count=2`; o ECS **recria** tasks até bater o desired. Esse é o “guardião”.

### Por que ALB e não o IP da task?

| Acesso | Fase 1 (estudo) | Fase 2 (atual) |
|---|---|---|
| URL | `http://<IP-da-task>:8000` | `http://<DNS-do-ALB>/` (porta **80**) |
| Problema do IP | Muda a cada task nova | DNS do ALB é estável |
| Escala | 1 task | 2 tasks; ALB escolhe target healthy |
| SG da app | 8000 aberto (lab) | 8000 **só** a partir do SG do ALB |

IP público na task ainda existe (`assign_public_ip=true`) para a task puxar imagem do ECR e enviar logs — o **tráfego HTTP do usuário** deve ir pelo ALB.

---

## Onde isso se usa na vida real (aplicações e situações)

Este lab é Hello World, mas o **mesmo padrão** (container + ECR + ECS Fargate + Service + ALB) aparece em APIs e backends HTTP de verdade. Use a tabela abaixo para decidir **quando** cada peça faz sentido.

### Tipos de aplicação que costumam ir para ECS Fargate + ALB

| Tipo de aplicação | Exemplos | Por que encaixa |
|---|---|---|
| **API HTTP / REST / JSON** | FastAPI, Flask, Express, Nest, Spring Boot | Entrada HTTP estável no ALB; várias réplicas atrás do TG |
| **BFF (Backend for Frontend)** | API que agrega microsserviços para o app web/mobile | Precisa DNS fixo, health check e redeploy sem mudar URL |
| **Portal / API interna** | CRUD, autenticação, integrações | Service mantém N tasks; logs no CloudWatch |
| **Webhook / callback** | Receber eventos de Stripe, GitHub, ERP | Endpoint público (ou via VPN) com URL estável |
| **Worker HTTP leve** | Serviço que processa jobs sob demanda via HTTP | Fargate evita gerenciar EC2; escale com desired/autoscaling |
| **Migração de VM → container** | App legado empacotado em Docker | Mesmo modelo de deploy (imagem → task) sem reescrever tudo |

### Em quais situações usar cada padrão

| Situação | O que usar | Por quê |
|---|---|---|
| Aprender o fluxo imagem → task → internet | **1 task** (ou Service desired=1), acesso direto / lab | Menos peças; foco em Task Definition e ECR |
| API que **precisa ficar no ar** e se recuperar sozinha | **ECS Service** (`desired_count` ≥ 1) | Guardião: se a task morrer, sobe outra |
| Vários clientes / DNS estável / não depender do IP da task | **ALB + Target Group** | IP da task muda; DNS do ALB não |
| Distribuir carga e tirar instância doente do ar | **ALB + HC** (`/health`) + ≥2 tasks | Só target **healthy** recebe tráfego |
| Sobreviver à queda de **uma AZ** (didático/produção básica) | **2 AZs** + desired ≥ 2 | Como neste lab |
| Time pequeno, sem querer gerenciar servidores | **Fargate** (não EC2 launch type) | AWS cuida da capacidade |
| Pico de tráfego previsível / sazonal | Service + **Application Auto Scaling** (fora deste lab) | Sobe/desce `desired_count` |
| Job batch que roda e termina (ETL, relatório noturno) | ECS **Scheduled Task** / Step Functions — **não** ALB contínuo | Não precisa Service+ALB 24×7 |
| Função curta, poucos ms, pouco estado | Avaliar **Lambda** (+ API Gateway) | Pode ser mais barato/simples que Fargate sempre ligado |
| Só site estático | **S3 + CloudFront** | ECS seria exagero |
| Precisa de GPU / kernel especial / custo EC2 otimizado | ECS no **EC2** ou outro serviço | Fargate tem limites e preço por vCPU/hora |

### Quando **não** começar pelo padrão deste lab

- Protótipo local: rode `uvicorn` / Docker na máquina (seção Validação local).
- Um webhook raro e barato: às vezes Lambda basta.
- App sem HTTP (só fila): considere workers com SQS + Service **sem** ALB, ou outros padrões.
- Produção séria ainda exige o que este lab **não** tem: HTTPS, rede privada/NAT ou endpoints VPC, autoscaling, alarmes, CI/CD, WAF, etc.

### Como ler este lab no mapa de decisão

```text
Tenho uma API em container?
  não → empacote (Dockerfile) primeiro
  sim → precisa ficar no ar sozinha?
         não → task manual / lab desired=1
         sim → ECS Service
                precisa URL estável + várias réplicas?
                  não → Service sem ALB (menos comum em API pública)
                  sim → Service + ALB + health check  ← você está aqui (Fase 2)
```

**Resumo:** use o padrão deste repositório quando tiver (ou for aprender) uma **API HTTP em container** que precisa de **disponibilidade**, **DNS estável** e **mais de uma réplica**. Use só a Fase 1 mental (1 task) quando o objetivo for entender o fluxo básico, sem ainda se preocupar com balanceamento.

---

## Arquitetura (Fase 2)

```text
Você (curl / navegador)
        |
        v
   ALB :80  ---- listener ---->  Target Group
   (DNS estável)                 HC: GET /health :8000
                                      |
                 +--------------------+--------------------+
                 |                                         |
            Task A (AZ-a)                            Task B (AZ-b)
            FastAPI :8000                            FastAPI :8000
                 ^                                         ^
                 |                                         |
            ECS Service "hello-fargate"  desired_count = 2
            (recria task se uma cair)
```

**Fora de escopo (de propósito):** HTTPS/ACM, NAT, autoscaling, multi-região, CI/CD.

---

## Fluxo completo na AWS (copiar e colar)

Na **raiz do repositório**, Docker Desktop ligado e policy IAM ok:

```powershell
# 1) Auth
aws sso login
# ou: aws sso login --profile SEU_PERFIL

# 2) Infra (2 AZs + ALB + desired=2)
# Se vinha da Fase 1: leia o plan — pode haver replace de subnet/SG.
terraform -chdir=infra init
terraform -chdir=infra plan
terraform -chdir=infra apply

# 3) Imagem + redeploy (imprime DNS do ALB)
.\scripts\build-and-push.ps1
# ou: .\scripts\build-and-push.ps1 -AwsProfile SEU_PERFIL

# 4) Testar via ALB (porta 80 — SEM :8000 no host)
curl http://<ALB-DNS>/
curl http://<ALB-DNS>/health
# Esperado: Hello World  e  {"status":"ok","service":"hello-fargate"}

# 5) Self-healing (recomendado) — seção abaixo

# 6) Desligar (obrigatório)
terraform -chdir=infra destroy
```

DNS do ALB:

```powershell
terraform -chdir=infra output -raw alb_dns_name
```

**Alternativo (estudo de ENI):** `.\scripts\build-and-push.ps1 -ResolvePublicIp` — curl no IP `:8000` pode **falhar** porque o SG da task só aceita tráfego do ALB. Prefira o DNS.

**Ordem importante:** no 1º `apply`, o Service sobe, mas as tasks podem falhar até existir imagem `:latest` no ECR. Por isso o passo 3 (script) vem em seguida.

---

## Guia no console AWS — o que olhar e por quê

Com o lab no ar. Região: **us-east-1**. Objetivo: ligar cada tela a um conceito do glossário.

### 1) ECR — a imagem

**Console:** ECR → Repositories → `hello-fargate`  
**Pergunta:** sem imagem `:latest`, o que acontece com a task? → ImagePull / restart até o push.

### 2) ECS Cluster — a “sala”

**Console:** ECS → Clusters → `hello-fargate`  
**Pergunta:** o cluster sozinho serve tráfego? → Não. Cluster agrupa; quem mantém tasks é o **Service**.

### 3) Task Definition — a receita

**Console:** ECS → Task definitions → `hello-fargate`  
Olhe: imagem ECR, CPU/memória, porta **8000**, log group `/ecs/hello-fargate`, roles.  
**Pergunta:** editar a definição cria tasks novas sozinhas? → Só depois de um **novo deployment** do Service (o script faz `force-new-deployment`).

### 4) Service — o guardião

**Console:** Cluster → Services → `hello-fargate`  
Olhe: **Desired** = 2, **Running** = 2, launch type Fargate, load balancer apontando para o TG.  
**Pergunta:** se Running < Desired, o que o Service faz? → Lança tasks novas até igualar.

### 5) Tasks — as execuções

**Console:** Service → Tasks  
Duas tasks RUNNING, em geral em AZs diferentes. Clique numa: rede (ENI), logs, definição usada.  
**Pergunta:** o IP da task é o endereço estável da API? → Não na Fase 2; o estável é o **DNS do ALB**.

### 6) ALB + Target Group — a porta da frente

**Console:** EC2 → Load Balancers → `hello-fargate-alb`  
Listeners: **80** → forward para `hello-fargate-tg`.  
TG → Targets: dois IPs privados (`10.0.1.x` / `10.0.2.x`) **healthy**.  
**Pergunta:** por que o curl no ALB não usa `:8000`? → Cliente fala com o ALB na **80**; o ALB fala com a task na **8000**.

### 7) Security Groups — quem pode falar com quem

| SG | Ingress | Ideia |
|---|---|---|
| `hello-fargate-alb-sg` | TCP 80 de `allowed_cidr` (default aberto no lab) | Internet → ALB |
| `hello-fargate-task-sg` | TCP 8000 **somente** do SG do ALB | ALB → app; não é “porta 8000 aberta pro mundo” |

### 8) Logs — quando algo falha

**Console:** CloudWatch → Log groups → `/ecs/hello-fargate`  
Se o TG está unhealthy, o log mostra se o uvicorn subiu ou se a imagem/config falhou.

### Lições-chave (resumo)

| Lição | Onde | Por quê importa |
|---|---|---|
| 2 AZs | VPC → subnets `...-a` / `...-b` | ALB exige ≥2 AZs; tasks distribuídas |
| Service desired=2 | ECS Service | Base do self-healing |
| TG healthy | Target Group | Só healthy recebe tráfego |
| SG em camadas | SG alb → SG task | Isolamento didático |
| Redeploy | Script / force-new-deployment | Nova imagem sem recriar o cluster |

---

## Exercício self-healing (sinta o Service)

Com `curl` no ALB OK e `desired_count=2`:

```powershell
$cluster = "hello-fargate"
$service = "hello-fargate"
$region  = "us-east-1"

# 1) Listar tasks RUNNING
aws ecs list-tasks --cluster $cluster --service-name $service --desired-status RUNNING --region $region

# 2) Parar UMA task (substitua o ARN)
aws ecs stop-task --cluster $cluster --task <TASK-ARN> --region $region

# 3) Observar o guardião: pending sobe, depois running volta a 2
aws ecs describe-services --cluster $cluster --services $service --region $region `
  --query "services[0].{desired:desiredCount,running:runningCount,pending:pendingCount}"

# 4) Targets no TG
aws elbv2 describe-target-health `
  --target-group-arn $(terraform -chdir=infra output -raw target_group_arn) `
  --region $region

# 5) API continua pelo DNS estável (pode falhar por poucos segundos)
curl http://$(terraform -chdir=infra output -raw alb_dns_name)/health
```

**O que você está aprendendo:**

1. **Service** — detecta task parada e lança outra até `running == desired`
2. **ALB/TG** — target antigo fica draining/unhealthy; o novo vira healthy
3. **DNS do ALB** — o cliente não precisa saber o IP novo da task

Isso é HA **didática** (1 região, 2 AZs) — não é multi-região de produção.

---

## Validar na AWS (CLI rápido)

```powershell
terraform -chdir=infra output
aws elbv2 describe-target-health --target-group-arn $(terraform -chdir=infra output -raw target_group_arn) --region us-east-1
aws ecs describe-services --cluster hello-fargate --services hello-fargate --region us-east-1 --query "services[0].{status:status,running:runningCount,desired:desiredCount}"
aws ecs list-tasks --cluster hello-fargate --service-name hello-fargate --desired-status RUNNING --region us-east-1
aws logs tail /ecs/hello-fargate --since 10m --region us-east-1
```

Interpretação do TG: **2 targets** em AZs diferentes com `State: healthy` = lab HA no ar.

---

## Pré-requisitos

| Ferramenta | Uso |
|---|---|
| **AWS CLI v2** + SSO | Auth, ECR, ECS, ELB, EC2 |
| **Docker** Desktop/Engine | `docker build` / `push` (precisa estar **Running**) |
| **Terraform** CLI | `apply` / `destroy` / `output` |
| **PowerShell** | Script oficial |
| Permissões IAM | Policy de estudo em `docs/` |

---

## Validação local (sem AWS)

Antes do `apply`, valide a API na máquina:

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

Com Docker:

```powershell
docker build -t hello-fargate:local ./app
docker run --rm -p 8000:8000 hello-fargate:local
```

---

## Passo a passo detalhado

### 1) Autenticar (SSO)

```powershell
aws sso login
# ou: aws sso login --profile SEU_PERFIL
```

Região do lab: **us-east-1**.  
Descobrir identidade: `aws sts get-caller-identity`.

### 2) Provisionar infraestrutura

```powershell
terraform -chdir=infra init
terraform -chdir=infra plan
terraform -chdir=infra apply
```

Sobe: VPC 2 AZs, SGs alb/task, ALB + listener :80 + TG, ECR, cluster, Service Fargate desired=2, logs. Sem autoscaling / HTTPS.

**Migração Fase 1 → 2:** o `plan` pode destruir/recriar SG (e às vezes travar se uma task ainda segura o SG antigo). Alternativa limpa: `destroy` + `apply`.  
Se interromper o apply no meio da criação do ALB, o ALB pode existir na AWS sem estar no state — use `terraform import` do `aws_lb.app` (veja troubleshooting) ou apague o ALB órfão e aplique de novo.

**State:** local (`.tfstate` no `.gitignore`).

**Risco de rede (estudo):** `allowed_cidr` default `0.0.0.0/0` no ALB:80. Restrinja ao seu IP quando possível:

```powershell
terraform -chdir=infra apply -var="allowed_cidr=SEU.IP.PUBLICO/32"
```

### 3) Build, push e redeploy

```powershell
.\scripts\build-and-push.ps1
```

O script: lê outputs Terraform → login ECR → `docker build ./app` → push `:latest` → `force-new-deployment` → imprime DNS do ALB.  
`-AwsProfile` e `-ResolvePublicIp` são opcionais.

### 4) Validar HTTP (ALB)

```powershell
curl http://<ALB-DNS>/
curl http://<ALB-DNS>/health
```

Sem `:8000` no host do ALB.

### 5) Destruir (checklist)

- [ ] `curl` no ALB `/` e `/health` OK  
- [ ] (Opcional) Self-healing feito — entendi o papel do Service  
- [ ] Entendi: Task Definition → Task → Service → ALB  
- [ ] Destroy:

```powershell
terraform -chdir=infra destroy
```

- [ ] Console: recursos `hello-fargate` sumiram (VPC/ALB/ECS/ECR)  
- [ ] Imagens órfãs no ECR: apague se necessário  

---

## Estrutura do repositório

```text
.
├── app/                 # FastAPI + Dockerfile
├── infra/               # Terraform (network, alb, ecs, ecr, iam, logs)
├── scripts/
│   └── build-and-push.ps1
├── docs/
│   └── ecs-fargate-alb-policy.json
├── tests/
├── aidlc-docs/          # processo AI-DLC (não é código da app)
├── .gitignore
└── README.md
```

Comentários didáticos também estão nos arquivos `infra/*.tf`.

---

## Troubleshooting

| Sintoma | Causa provável | Ação |
|---|---|---|
| `dockerDesktopLinuxEngine` / pipe not found | Docker Desktop parado | Abra o Docker e espere Running; `docker info` |
| Task não sobe / ImagePull | ECR sem `:latest` | `.\scripts\build-and-push.ps1` |
| Target unhealthy | App/HC/SG | `/health` local; path do TG; SG task←alb |
| `curl` ALB timeout | SG / DNS / ainda subindo | Aguarde healthy; confira `alb_dns_name` |
| SG “Still destroying...” no apply | Task/ENI ainda usa o SG antigo | `desired-count 0` + stop-task; espere ENI sumir; reapply |
| `Load Balancer already exists` | Apply interrompido; ALB órfão | `terraform import aws_lb.app <ARN>` ou delete o ALB e reapply |
| Curl no IP :8000 falha | Esperado na Fase 2 | Use DNS do ALB |
| `AccessDenied` | Policy IAM | Atualize `docs/ecs-fargate-alb-policy.json` na conta |
| `aws sso login usuario-dados` falha | Sintaxe errada | `aws sso login --profile NOME_DO_PERFIL` |

---

## Policy IAM de estudo

Arquivo: [`docs/ecs-fargate-alb-policy.json`](docs/ecs-fargate-alb-policy.json) — cobre VPC/ECS/ECR/logs e ações de ALB/ELB do lab.

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

---

## Escopo fora deste lab

- HTTPS / ACM  
- NAT Gateway / tasks só privadas  
- Autoscaling / multi-região  
- Pipeline CI/CD  
- Backend remoto de state (S3)  
- Security Baseline AI-DLC (OFF neste projeto)  
