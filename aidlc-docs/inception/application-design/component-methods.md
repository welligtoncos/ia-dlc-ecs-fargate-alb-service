# Métodos / Interfaces dos Componentes

> Regras de negócio detalhadas ficam para Functional Design. Aqui: assinaturas e contratos de alto nível.

## ApiApp

### Handlers HTTP (FastAPI)
| Handler | Método HTTP | Path | Entrada | Saída |
|---|---|---|---|---|
| `get_hello` | GET | `/` | — | `str` — corpo texto `Hello World` (text/plain ou equivalente) |
| `get_health` | GET | `/health` | — | `dict` — JSON simples, ex. `{"status": "ok"}` |

### Funções de domínio (alto nível)
```text
get_hello() -> str
get_health() -> dict[str, str]
```

### Runtime
- Processo: Uvicorn servindo a app FastAPI em `0.0.0.0:8000`.

## ContainerImage
| Operação conceitual | Descrição |
|---|---|
| `build(python_version=3.12)` | Constrói imagem a partir do Dockerfile |
| `expose_port(8000)` | Container escuta 8000 |
| `entrypoint_uvicorn()` | Sobe a ApiApp |

## CloudInfra (Terraform — operações conceituais)
| Operação | Descrição |
|---|---|
| `apply()` | Cria/atualiza rede, ECR, IAM, ECS, logs |
| `destroy()` | Remove recursos do lab |
| `output_public_ip()` | Tenta expor IP público da task/ENI |
| `configure_awslogs()` | Task envia logs ao CloudWatch |

## Tooling
| Operação | Descrição |
|---|---|
| `build_and_push(ecr_url, tag)` | Login ECR + docker build/tag/push (`scripts/build-and-push.ps1`) |
| `resolve_public_ip_fallback()` | Obtém IP via AWS CLI se output TF falhar/mudar |
| `print_validation_commands(ip)` | Documenta/curl de validação (README) |

## PBT (Application Design)
- Propriedades identificáveis na ApiApp: **N/A** (respostas constantes; sem transformações/estado). Documentar no Functional Design.
