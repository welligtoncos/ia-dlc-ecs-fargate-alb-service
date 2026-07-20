# NFR Requirements — `hello-infra`

## Resumo
NFRs operacionais e de plataforma para a unidade Terraform do lab Fargate (criticidade **Low**).

## Decisões desta etapa

| # | Tema | Decisão |
|---|---|---|
| 1 | CloudWatch Logs | Log group `/ecs/hello-fargate`, retenção **7 dias** |
| 2 | Tag da imagem | Fixa `latest` |
| 3 | 1º apply sem imagem | Aceitar tasks falhando até push; documentar apply → push → redeploy |
| 4 | SG ingresso :8000 | Variável `allowed_cidr` default `0.0.0.0/0` |
| 5 | Tooling IaC | Terraform `>= 1.5`, AWS provider `~> 5.0` |
| 6 | ECR | Nome `hello-fargate` |

## Categorias NFR

### Custo
- Fargate 256 CPU / 512 MB, 1 task, 1 AZ
- Log retention 7 dias
- Destroy obrigatório no fluxo didático

### Disponibilidade / Resiliência
- Single-AZ (sem HA)
- RTO em horas: recreate via Terraform
- Service pode ficar unhealthy até existir imagem no ECR

### Observabilidade
- awslogs → log group dedicado gerenciado pelo Terraform
- Sem dashboard/ALB health check (fora de escopo)

### Segurança (lab)
- Security Baseline desabilitada
- Ingress configurável via `allowed_cidr` (default aberto) — risco documentado no README

### Performance
- Sem SLO formal; Hello World local/ lab

### Manutenibilidade
- Arquivos `.tf` por responsabilidade + comentários didáticos
- State local + comentário de migração S3

## Compliance Extensions
| Extension | Status |
|---|---|
| Security | N/A (off) |
| Resiliency | Alinhado (single-AZ, logs, recreate) |
| PBT | N/A |
