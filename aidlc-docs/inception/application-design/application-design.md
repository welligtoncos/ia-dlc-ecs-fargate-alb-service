# Application Design Consolidado — Lab FastAPI + Fargate

## Decisões do plano (respostas)
| # | Decisão |
|---|---|
| 1 | Componentes: **ApiApp**, **ContainerImage**, **CloudInfra**, **Tooling** |
| 2 | Serviço conceitual **LabOrchestration** (passos + scripts) |
| 3 | IP: output **CloudInfra** + fallback **Tooling** |
| 4 | Logs: **CloudInfra** (awslogs); app só stdout |
| 5 | Methods: handlers FastAPI explícitos `/` e `/health` |
| 6 | Dependência runtime: imagem publicada via Tooling antes da task saudável |

## Artefatos
- [components.md](./components.md)
- [component-methods.md](./component-methods.md)
- [services.md](./services.md)
- [component-dependency.md](./component-dependency.md)

## Mapa para unidades (próxima etapa)
| Componente | Unidade sugerida |
|---|---|
| ApiApp + ContainerImage | `hello-app` |
| CloudInfra | `hello-infra` |
| Tooling + README (LabOrchestration docs) | `hello-tooling-docs` |

## Alinhamento a requisitos
- RF-01..RF-09 cobertos na divisão de responsabilidades
- Sem ALB / multi-AZ / CI-CD
- Destroy e validação curl no LabOrchestration / Tooling

## Compliance Extensions
| Extension | Status nesta etapa |
|---|---|
| Security | N/A (desabilitada) |
| Resiliency | Compliant com decisões: single-AZ, `/health`, logs CW, recover recreate |
| PBT | N/A na ApiApp (sem propriedades significativas) — revalidar no Functional Design |
