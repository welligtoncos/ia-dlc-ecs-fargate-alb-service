# NFR Design Patterns — `hello-infra`

## Decisões

| # | Tema | Padrão escolhido |
|---|---|---|
| 1 | Resiliência | **Recreate** — push/redeploy ou destroy+reapply pelo operador |
| 2 | Escalabilidade | **N/A** — `desired_count = 1` fixo |
| 3 | Performance | **Capacity pattern didático** — documentar 256 CPU / 512 MB |
| 4 | Segurança | SG + `allowed_cidr`; IAM execution/task roles com privilégio mínimo da task; documentar risco CIDR |
| 5 | Componentes extras | Nenhum além do conjunto mínimo |
| 6 | Imagem ausente | **Dependency gap** consciente (apply → push → redeploy) |

## Padrões aplicados

### Resilience — Recreate
- Sem Pilot Light / Warm Standby / multi-AZ
- Falha da task: operador recria via Terraform e/ou republica imagem
- ECS Service mantém `desired_count=1` (restart nativo da plataforma), mas o **DR explícito do lab** é recreate

### Scalability — Explicit non-goal
- Sem Application Auto Scaling
- Sem múltiplas tasks
- Valor fixo `1` no service (não variável, para deixar o N/A óbvio no código)

### Performance — Capacity documentation
- Task size fixa 256/512 como “envelope” de capacidade do lab
- Sem cache, CDN, connection pooling ou tuning de Uvicorn além do default

### Security — Lab-minimum perimeter
- Security group: porta 8000 de `var.allowed_cidr` (default aberto)
- Task execution role: pull ECR + awslogs
- Task role: mínima (sem permissões extras desnecessárias no Hello World)
- Sem VPC endpoints ECR (custo/complexidade)

### Dependency gap (imagem)
- Terraform sobe cluster/service mesmo sem imagem
- Saúde do runtime depende de `hello-tooling-docs` (push) — documentar no Infrastructure Design / README

## Compliance Extensions
| Extension | Status |
|---|---|
| Resiliency | Compliant com recreate + single-AZ + logs |
| Security Baseline | N/A (off); padrões mínimos conscientes |
| PBT | N/A |
