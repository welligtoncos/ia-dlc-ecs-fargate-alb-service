# Plano de Code Generation — `hello-infra` Fase 2 (HA + ALB)

## Contexto
Evoluir Terraform in-place: 2 AZs, ALB+TG+HC, Service desired=2, SGs alb/task.  
App **intacta**. Prefixo `hello-fargate`.

## Passos

### Passo 1 — Variáveis
- [x] `variables.tf`: `public_subnet_cidr_b` (default `10.0.2.0/24`); manter `allowed_cidr` para ALB:80
- [x] Ajustar descrição de `public_subnet_cidr` (AZ-a `10.0.1.0/24`)

### Passo 2 — Rede (`network.tf`)
- [x] Segunda subnet pública AZ `names[1]`, CIDR b, `map_public_ip_on_launch=true`
- [x] Associação da 2ª subnet à route table pública
- [x] Remover/ajustar SG task antigo — movido para `alb.tf`

### Passo 3 — ALB (`alb.tf` novo)
- [x] SG `alb`: ingress 80 de `allowed_cidr`; egress adequado
- [x] SG `task`: ingress 8000 **somente** do SG alb; egress amplo
- [x] ALB internet-facing nas 2 subnets
- [x] Target Group type `ip`, port 8000, HC path `/health`, matcher 200
- [x] Listener HTTP :80 → TG
- [x] Nomes `hello-fargate-alb` / `hello-fargate-tg`
- [x] Deregistration delay: default AWS

### Passo 4 — ECS (`ecs.tf`)
- [x] Service: `desired_count = 2`
- [x] `network_configuration`: ambas subnets; SG task; `assign_public_ip = true`
- [x] Bloco `load_balancer` (TG + container name/port)
- [x] Manter `wait_for_steady_state = false`
- [x] Comentários didáticos pt-BR

### Passo 5 — Outputs (`outputs.tf`)
- [x] `alb_dns_name`, `alb_arn`, `target_group_arn`
- [x] Manter/adaptar ajuda de IP da task (oficial alternativo — Q5=B)
- [x] Atualizar `force_new_deployment_command` se necessário

### Passo 6 — Locals / versions
- [x] Garantir `container_port`, project_name; `moved.tf` para subnet

### Passo 7 — Resumo
- [x] `aidlc-docs/construction/hello-infra/code/generation-summary-fase2.md`

### Passo 8 — Validação
- [x] `terraform fmt` / `validate` (se possível no ambiente)

## Fora deste plano
- Mudanças em `app/`
- README completo (unidade `hello-tooling-docs`)
- `terraform apply` real

## Compliance
| Extension | Status |
|---|---|
| Resiliency | HA + TG HC |
| Security | OFF; SG alb→task |
| PBT | OFF |
