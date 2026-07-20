# Resumo da Geração — `hello-infra`

## Arquivos criados (workspace)

| Arquivo | Descrição |
|---|---|
| `infra/versions.tf` | Terraform >= 1.5, AWS ~> 5.0, time ~> 0.9; locals do projeto |
| `infra/providers.tf` | Provider AWS + default_tags |
| `infra/variables.tf` | region, CIDRs, allowed_cidr |
| `infra/network.tf` | VPC, subnet, IGW, rotas, SG |
| `infra/ecr.tf` | Repositório ECR `hello-fargate` |
| `infra/iam.tf` | Execution + task roles |
| `infra/logs.tf` | Log group `/ecs/hello-fargate` (7 dias) |
| `infra/ecs.tf` | Cluster, task definition, service (desired_count=1, IP público, sem ALB) |
| `infra/outputs.tf` | ECR/cluster/service + public_ip híbrido + fallbacks CLI |

## Rastreabilidade
- RF-04, RF-05, RF-06 (parcial — fallback CLI completo no tooling)
- NFR: 256/512, latest, allowed_cidr, logs 7d, wait_for_steady_state=false
- Infra design: CIDR 10.0.0.0/16 / 10.0.1.0/24, AZ data source, logs.tf separado

## Não feito nesta unidade
- App/Dockerfile, scripts, README lab, `terraform apply` real

## Compliance
| Extension | Status |
|---|---|
| Security | N/A |
| Resiliency | single-AZ, recreate, logs |
| PBT | N/A |
