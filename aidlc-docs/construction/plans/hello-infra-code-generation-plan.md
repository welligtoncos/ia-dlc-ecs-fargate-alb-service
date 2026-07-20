# Plano de Code Generation — `hello-infra`

## Contexto
- **Unidade**: `hello-infra`
- **Local do código**: `infra/` na raiz do workspace (NUNCA em aidlc-docs/)
- **Resumo de processo**: `aidlc-docs/construction/hello-infra/code/`
- **Idioma**: comentários Terraform em português (pt-BR)
- **Fontes**: infrastructure-design, nfr-design, requirements RF-04..06

## Escopo
Gerar todo o Terraform do lab Fargate. **Não** gerar app Python, Dockerfile, scripts ou README completo (outras unidades).

## Passos de geração

### Passo 1 — Estrutura
- [x] Criar diretório `infra/`

### Passo 2 — `infra/versions.tf`
- [x] Terraform `>= 1.5`, provider AWS `~> 5.0`

### Passo 3 — `infra/providers.tf`
- [x] Provider AWS com `var.aws_region`

### Passo 4 — `infra/variables.tf`
- [x] `aws_region` (default `us-east-1`)
- [x] `vpc_cidr` / `public_subnet_cidr` (defaults 10.0.0.0/16 e 10.0.1.0/24)
- [x] `allowed_cidr` (default `0.0.0.0/0`)
- [x] Prefixo/nome fixo documentado como `hello-fargate` (locals ou variável com default fixo)
- [x] Comentário sobre state local e migração futura S3

### Passo 5 — `infra/network.tf`
- [x] VPC, subnet pública (1 AZ via data source), IGW, route table, association
- [x] Security group: ingress TCP 8000 de `allowed_cidr`; egress adequado
- [x] Comentários didáticos (porquê de cada recurso)

### Passo 6 — `infra/ecr.tf`
- [x] Repositório ECR `hello-fargate`

### Passo 7 — `infra/iam.tf`
- [x] Execution role (ECR pull + logs) + task role mínima
- [x] Comentários didáticos

### Passo 8 — `infra/logs.tf`
- [x] Log group `/ecs/hello-fargate`, retention 7 dias

### Passo 9 — `infra/ecs.tf`
- [x] Cluster, task definition Fargate 256/512, port 8000, imagem `.../hello-fargate:latest`, awslogs
- [x] Service desired_count=1, assign_public_ip=true, sem load balancer
- [x] Comentários: dependency gap (imagem pode não existir no 1º apply)

### Passo 10 — `infra/outputs.tf`
- [x] ECR repository URL, cluster name, service name
- [x] Tentativa híbrida de `public_ip` (time_sleep curto + data sources) com nota de fallback CLI
- [x] Output auxiliar com comando CLI de fallback (como string/descrição)

### Passo 11 — Resumo da unidade
- [x] `aidlc-docs/construction/hello-infra/code/generation-summary.md`

### Passo 12 — Validação rápida
- [x] Conferir arquivos listados, prefixo, região, ausência de ALB/autoscaling

## Fora deste plano
- `app/`, `scripts/`, README lab completo, mover policy IAM
- `terraform apply` real na conta (fica para Build and Test / operador)

## Compliance
| Extension | Status |
|---|---|
| Security | N/A (off) |
| Resiliency | recreate, single-AZ, logs |
| PBT | N/A |

## Critério de conclusão da Parte 2
Todos os checkboxes `[x]` e arquivos em `infra/` + summary.
