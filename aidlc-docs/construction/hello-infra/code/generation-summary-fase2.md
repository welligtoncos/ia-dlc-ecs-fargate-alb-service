# Code Generation Summary — `hello-infra` Fase 2

## Artefatos
| Arquivo | Mudança |
|---|---|
| `infra/network.tf` | 2 subnets públicas (A/B), sem SG task |
| `infra/alb.tf` | **Novo** — SG alb/task, ALB, TG, listener :80 |
| `infra/ecs.tf` | desired=2, 2 subnets, `load_balancer` |
| `infra/variables.tf` | `public_subnet_cidr_b`; `allowed_cidr` = ALB:80 |
| `infra/outputs.tf` | `alb_dns_name`, `alb_arn`, `target_group_arn`, `alb_url` + IP CLI |
| `infra/moved.tf` | `subnet.public` → `public_a` |

## Comportamento
- HC TG: `/health` matcher 200
- Tasks: IP público mantido; HTTP principal via ALB
- SG task: 8000 só do SG ALB

## Apply
```powershell
terraform -chdir=infra plan
terraform -chdir=infra apply
.\scripts\build-and-push.ps1
curl http://$(terraform -chdir=infra output -raw alb_dns_name)/
curl http://$(terraform -chdir=infra output -raw alb_dns_name)/health
```

Esperado: plan cria ALB/TG/subnet-b e atualiza service (possível replace de SG task).

## Próximo
Unidade `hello-tooling-docs` — README (DNS ALB + self-healing).
