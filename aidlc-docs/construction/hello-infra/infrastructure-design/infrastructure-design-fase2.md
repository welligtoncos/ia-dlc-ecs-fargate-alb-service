# Infrastructure Design — `hello-infra` Fase 2

## Decisões

| # | Tema | Decisão |
|---|---|---|
| 1 | Arquivos | `alb.tf` novo; evoluir `network.tf`, `ecs.tf`, `outputs.tf`, `variables.tf` |
| 2 | Subnets | AZ-a `10.0.1.0/24`, AZ-b `10.0.2.0/24` (VPC `10.0.0.0/16`) |
| 3 | HC TG | Path `/health`, port 8000, matcher 200; **defaults** de interval/threshold |
| 4 | Nomes | Prefixo `hello-fargate` (`hello-fargate-alb`, `hello-fargate-tg`) |
| 5 | Outputs | `alb_dns_name` (+ ARNs) **e** outputs de IP de task como oficiais iguais (Q5=B) |
| 6 | Deregistration | Default AWS (~300s) |

## Mapeamento de serviços

| Lógico | AWS / Terraform |
|---|---|
| NetworkHA | VPC, 2× subnet public, IGW, RT, associações |
| LoadBalancer | ALB internet-facing, listener :80, TG type `ip`, SG alb |
| EcsHaService | Service desired=2, subnets ambas AZs, `load_balancer {}`, SG task (8000 só do SG alb), `assign_public_ip=true` |
| Logging | Log group existente |
| Registry/IAM | ECR + roles (mantidos) |

## Security Groups
- **alb**: ingress TCP 80 de `allowed_cidr` (default `0.0.0.0/0` documentado); egress para tasks
- **task**: ingress TCP 8000 **somente** security_groups = [SG alb]; egress amplo (ECR/logs)

## Notas de apply in-place
- Subnet única Fase 1 → duas subnets pode **replace** recursos; documentar no README
- Service ganha `load_balancer`; SG task deixa de abrir 8000 ao mundo

## Shared infrastructure
- N/A (lab single-account)
