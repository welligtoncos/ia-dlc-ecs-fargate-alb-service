# Documento de Requisitos — Lab FastAPI + Fargate + Terraform

## Resumo da Intenção
- **Pedido**: Projeto de aprendizado para entender ponta a ponta o deploy de app containerizada no AWS Fargate, com infra 100% Terraform.
- **Tipo**: Novo projeto greenfield (aplicação) em workspace com AI-DLC já configurado.
- **Escopo**: Múltiplos componentes (app, Docker, ECR, rede, IAM, ECS/Fargate, scripts, docs).
- **Complexidade**: Moderada, com prioridade didática (explicar o “porquê”).
- **Profundidade**: Standard.
- **Idioma**: Português (pt-BR) em artefatos `aidlc-docs/`, README, comentários Terraform e documentação didática.

## Critério de Sucesso
1. Rodar `terraform apply` (após build/push da imagem conforme script).
2. Obter IP público (output Terraform e/ou comando CLI de fallback).
3. Acessar via navegador ou `curl` e ver Hello World (`/` texto; `/health` JSON).
4. Entender o papel de cada recurso AWS e bloco Terraform no caminho imagem → ECR → Task Definition → Task → IP público.
5. Executar checklist: validar → `terraform destroy` → confirmar remoção (custo ~zero).

## Decisões Confirmadas (perguntas 1–18)

| # | Tópico | Decisão |
|---|---|---|
| 1 | Região | `us-east-1` |
| 2 | Auth AWS | SSO (`aws sso login`) — perfil configurável; documentar passo no README |
| 3 | Rede | VPC mínima didática, **1 AZ**, menor conjunto de recursos (subnet pública + IGW + rotas) |
| 4 | Execução | `aws_ecs_service` com `desired_count = 1`, `assign_public_ip = true`, **sem ALB** + script/docs para IP da ENI |
| 5 | Output IP | Ambos: tentar output automático no apply **e** documentar CLI de fallback |
| 6 | Build/push | Terraform só ECR/infra; oficial: `scripts/build-and-push.ps1` |
| 7 | Fargate size | `256` CPU / `512` MB (fixo) |
| 8 | Layout repo | `app/` + `infra/` (ecr/ecs/iam/network/variables/outputs + providers) |
| 9 | README | Único: (1) AI-DLC breve + (2) lab Fargate como conteúdo principal |
| 10 | Idioma | Tudo em português (pt-BR) |
| 11 | State TF | Local agora + comentário de migração futura para S3 |
| 12 | Prefixo | Fixo `hello-fargate` |
| 13 | Python | `ARG` no Dockerfile com default **3.12** (slim) |
| 14 | HTTP | `/` → texto `Hello World`; `/health` → JSON simples |
| 15 | Destroy | Checklist **obrigatório** após validação |
| 16 | Security Baseline | **Desabilitada** |
| 17 | Resiliency Baseline | **Habilitada** (várias regras N/A ou “próximos passos” por escopo de estudo) |
| 18 | PBT | **Habilitada (completa)** — na prática, maior parte N/A para Hello World fino; aplicar onde houver propriedade identificável |

## Requisitos Funcionais

### RF-01 — API FastAPI
- App em Python + FastAPI + Uvicorn na porta **8000**.
- `GET /` retorna texto puro `Hello World`.
- `GET /health` retorna JSON simples (ex.: `{"status":"ok"}` ou equivalente didático).

### RF-02 — Container
- `Dockerfile` em `app/` com `ARG` de versão Python (default 3.12 slim).
- Imagem publicada no Amazon ECR (repositório criado via Terraform).

### RF-03 — Script de build/push
- `scripts/build-and-push.ps1` como caminho oficial (login ECR, build, tag, push).
- Terraform **não** faz build/push via `local-exec` como caminho principal.

### RF-04 — Infraestrutura Terraform (`infra/`)
Arquivos por responsabilidade, no mínimo:
- `network.tf` — VPC mínima, 1 AZ, subnet pública, IGW, route table
- `ecr.tf` — repositório ECR
- `iam.tf` — roles da task / execution role
- `ecs.tf` — cluster, task definition Fargate, service `desired_count = 1`, IP público, sem ALB
- `variables.tf`, `outputs.tf`, provider/backend (state local + comentário S3)
- Prefixo de nomes: `hello-fargate`
- Região default: `us-east-1`
- CPU/memória: 256/512

### RF-05 — Networking de acesso
- Security group permitindo ingresso na porta **8000** a partir da internet (estudo; documentar o risco didaticamente).
- Task com `assign_public_ip = true` em subnet pública.

### RF-06 — IP público
- Output Terraform tentando expor o IP público da task/ENI.
- Documentação + comando AWS CLI de fallback se o output automático falhar ou o IP mudar após restart.

### RF-07 — Validação
- Instruções para `curl`/navegador em `http://<IP>:8000/` e `/health`.
- Checklist pós-sucesso com `terraform destroy` e verificação de limpeza.

### RF-08 — Documentação didática
- README principal em português cobrindo setup AI-DLC (breve) + lab completo.
- Comentários no Terraform explicando o **porquê** de VPC, subnet, SG, IAM roles, ECR, task definition, service, etc.
- Política IAM de estudo existente (`ecs-fargate-alb-policy.json`) pode ser referenciada no README; **ALB permanece fora do escopo de provisionamento deste lab**.

### RF-09 — Autenticação AWS no fluxo
- Documentar uso de AWS SSO (`aws sso login`) antes de Terraform/AWS CLI/Docker push.

## Requisitos Não Funcionais

### RNF-01 — Custo
- Preferir recursos mínimos; 1 task, 1 AZ, Fargate 256/512; destroy obrigatório no fluxo didático.

### RNF-02 — Clareza didática
- Priorizar compreensão do caminho ponta a ponta sobre padrões de produção.

### RNF-03 — Destruibilidade
- Tudo criado pelo lab deve ser removível com `terraform destroy` (+ limpeza de imagens ECR se necessário, documentada).

### RNF-04 — State
- Backend local; `.gitignore` para `*.tfstate*` / `.terraform/`; comentário sobre S3 no futuro.

### RNF-05 — Observabilidade mínima (Resiliency)
- Logs da task no CloudWatch Logs (padrão ECS/Fargate).
- Endpoint `/health` atende health check “shallow” (RESILIENCY-06 parcial; sem ALB — N/A integração com LB).

## Fora de Escopo (confirmado)
- Autoscaling / múltiplas tasks
- Application Load Balancer
- Pipeline de CI/CD (deploy manual: script + Terraform)
- Domínio próprio / HTTPS/TLS
- Alta disponibilidade / multi-AZ / multi-region
- Backend remoto S3 (apenas comentário futuro)

## Classificação de Workload (RESILIENCY-01 — preliminar)
| Componente | Criticidade | Impacto se indisponível |
|---|---|---|
| API Hello World no Fargate | **Low** (estudo individual) | Apenas aprendizado; sem receita/usuários reais |
| Infra Terraform | Low | Recriável via `terraform apply` |

Dependências: ECR (imagem) → Task Definition → ECS Service/Task → ENI/IP público → cliente HTTP.

## Extensions

| Extension | Status | Notas para este lab |
|---|---|---|
| Security Baseline | Desabilitada | PoC/estudo |
| Resiliency Baseline | Habilitada | Decisões abaixo; HA/ALB/autoscaling = N/A por escopo |
| Property-Based Testing | Habilitada (full) | App mínima: documentar propriedades N/A ou testes triviais se aplicável |

## Decisões Resiliency (esclarecimentos)

| # | Tema | Decisão |
|---|---|---|
| 1 | RTO/RPO / DR | **Horas** — Backup & Restore / recriar com Terraform (RESILIENCY-02 / 11) |
| 2 | Change management | Usar **processo formal da organização** (RESILIENCY-03). *Nome da ferramenta não informado — registrar no README quando conhecido* |
| 3 | CI/CD | **Deploy manual** (`scripts/build-and-push.ps1` + `terraform apply`); CI/CD fora de escopo |
| 4 | Rollback | `terraform destroy` + reapply / re-push da imagem boa |
| 5 | Estilo de deploy | **Direct / in-place** |
| 6 | Topologia | **Single-region, single-AZ** (sem HA) |
| 7 | Testes de resiliência | **Propor abordagem mínima** no lab (ex.: validar `/` e `/health`; exercício destroy/recreate) |
| 8 | Incidentes | Usar **processo existente da organização**. *Nome não informado — placeholder no README* |

### Compliance Resiliency (para este lab)
| Regra | Status |
|---|---|
| RESILIENCY-01 | Compliant — criticidade Low |
| RESILIENCY-02 / 11 | Compliant — RTO/RPO horas; recover via IaC recreate |
| RESILIENCY-12 / 13 | N/A — sem dados persistentes; recover = reapply |
| RESILIENCY-03 | Compliant com ressalva — processo org formal (ferramenta TBD no README) |
| RESILIENCY-04 | Compliant no escopo — sem pipeline; rollback destroy/reapply; deploy direct |
| RESILIENCY-05 | Parcial — CloudWatch Logs; dashboard/métricas avançadas N/A documentado |
| RESILIENCY-06 | Parcial — `/health` shallow; integração LB N/A |
| RESILIENCY-07–10 | N/A — sem HA, autoscaling, deps externas relevantes |
| RESILIENCY-08 | Compliant com decisão D — single-AZ explícito (fora de multi-AZ) |
| RESILIENCY-14 | Compliant — abordagem mínima proposta no README/lab |
| RESILIENCY-15 | Compliant com ressalva — processo org (ferramenta TBD) |

## Estrutura-alvo do repositório

```text
.
├── app/                 # FastAPI, requirements, Dockerfile
├── infra/               # Terraform (network, ecr, iam, ecs, variables, outputs, ...)
├── scripts/             # build-and-push.ps1 (+ helpers de IP se necessário)
├── ecs-fargate-alb-policy.json  # policy IAM de estudo (já existente)
├── README.md            # AI-DLC breve + lab principal
├── .aidlc-rule-details/
├── .cursor/rules/
└── aidlc-docs/
```

## Status da etapa
Análise de Requisitos **pronta para aprovação** (perguntas 1–18 + esclarecimentos Resiliency 1–8).
