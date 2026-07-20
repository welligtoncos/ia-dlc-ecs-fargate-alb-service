# Infrastructure Design — `hello-app`

## Escopo
- **Cloud AWS nesta unidade**: N/A (provisionado em `hello-infra`)
- **Artefato de deploy**: imagem Docker construída a partir de `app/`

## Decisões

| # | Tema | Decisão |
|---|---|---|
| 1 | Cloud | Sem recursos AWS novos |
| 2 | CMD | `uvicorn main:app --host 0.0.0.0 --port 8000` (1 worker implícito) |
| 3 | HEALTHCHECK Docker | Não incluir |
| 4 | Build context | Pasta `app/` (`docker build -t <ecr>/hello-fargate:latest ./app`) |

## Nota sobre módulo Uvicorn
Com build context = `app/`, o código fica na raiz do container (ex. `/app/main.py`). Por isso o módulo é `main:app`, não `app.main:app`. Imports internos: `from api import ...`.

## Mapeamento
| Componente lógico | Infra de runtime |
|---|---|
| ContainerRuntime | Dockerfile + imagem ECR (repo criado pela infra) |
| FastApiApp / ApiRouter | Processo Uvicorn na task Fargate |
| ApiTests | Local (`pytest`); não vai na imagem de produção (opcional: não copiar tests) |

## Shared infrastructure
- N/A
