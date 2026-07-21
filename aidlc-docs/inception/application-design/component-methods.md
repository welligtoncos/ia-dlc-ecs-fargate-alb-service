# Component Methods — Fase 2 (alto nível)

Detalhes de timeout HC / códigos HTTP finos ficam para **Infrastructure Design**. Aqui só contratos.

## ApiApp (inalterado)
| Método / rota | Descrição |
|---|---|
| `GET /` | Hello World text/plain |
| `GET /health` | JSON status ok — alvo do HC do TG |

## CloudInfra (conceitual)
| Contrato | Descrição |
|---|---|
| `provision_network_ha()` | VPC + 2 subnets públicas |
| `provision_alb()` | ALB público + listener :80 |
| `provision_target_group()` | TG ip:8000 + `health_check(/health)` |
| `register_service_with_tg()` | ECS Service anexa container ao TG |
| `maintain_desired_count(2)` | Service mantém 2 tasks; recreates |
| `expose_alb_dns()` | Output `alb_dns_name` |

## Tooling
| Contrato | Descrição |
|---|---|
| `build_and_push()` | ECR login, docker build/push, force-new-deployment |
| `print_alb_validation()` | Imprime `curl http://<alb_dns>/` e `/health` |
| `document_self_healing()` | Passos para encerrar 1 task e observar recuperação |
