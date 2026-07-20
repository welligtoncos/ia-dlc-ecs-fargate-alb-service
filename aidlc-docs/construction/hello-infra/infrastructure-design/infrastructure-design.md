# Infrastructure Design — `hello-infra`

## Decisões desta etapa

| # | Tema | Decisão |
|---|---|---|
| 1 | Ambiente | Conta/perfil SSO do operador; `aws_region` default `us-east-1`; sem workspaces |
| 2 | CIDR | VPC `10.0.0.0/16`, subnet pública `10.0.1.0/24` |
| 3 | AZ | Data source `aws_availability_zones` → primeira AZ |
| 4 | IP público | Híbrido: tentar output via ENI/`time_sleep` curto + fallback CLI documentado |
| 5 | Redeploy pós-push | Script `build-and-push.ps1` **e** README (`force-new-deployment`) |
| 6 | Storage/messaging/shared | **N/A** |
| 7 | Layout TF | `logs.tf` separado (didático) + demais arquivos por responsabilidade |

## Mapeamento lógico → AWS

| Componente lógico | Serviço / recurso AWS |
|---|---|
| VPC + subnet pública + IGW + rotas | VPC, Subnet, IGW, Route Table |
| Security Group | EC2 Security Group (ingress 8000 / `allowed_cidr`) |
| Repositório de imagem | Amazon ECR (`hello-fargate`) |
| Cluster / Task / Service | Amazon ECS (Fargate) |
| IAM execution + task | IAM Roles + policies anexadas |
| Logs | CloudWatch Log Group `/ecs/hello-fargate` (7 dias) |
| DNS/LB | **N/A** (IP público da ENI) |

## Arquivos Terraform previstos (`infra/`)

| Arquivo | Conteúdo |
|---|---|
| `versions.tf` | `required_version >= 1.5`, provider AWS `~> 5.0` |
| `providers.tf` | provider `aws` (region) |
| `variables.tf` | region, cidrs, `allowed_cidr`, project prefix, etc. |
| `outputs.tf` | ECR URL, cluster/service, tentativa de `public_ip`, notas de fallback |
| `network.tf` | VPC, subnet, IGW, routes, SG |
| `ecr.tf` | repositório ECR |
| `iam.tf` | execution role + task role |
| `logs.tf` | log group |
| `ecs.tf` | cluster, task definition, service |

## Variáveis-chave (previstas)
- `aws_region` (default `us-east-1`)
- `project_name` / prefixo fixo `hello-fargate` (conforme requisitos — prefixo fixo)
- `vpc_cidr` = `10.0.0.0/16`, `public_subnet_cidr` = `10.0.1.0/24`
- `allowed_cidr` (default `0.0.0.0/0`)
- CPU/memória fixos 256/512; image tag `latest`

## Compliance
| Extension | Status |
|---|---|
| Resiliency | single-AZ, recreate, logs 7d |
| Security Baseline | N/A; SG+IAM mínimos |
| PBT | N/A |
| Shared infrastructure doc | N/A |
