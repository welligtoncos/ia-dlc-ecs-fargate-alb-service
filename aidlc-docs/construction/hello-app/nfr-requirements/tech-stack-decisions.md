# Tech Stack Decisions — `hello-app`

| Camada | Escolha | Motivo |
|---|---|---|
| Linguagem | Python 3.12 (ARG no Docker) | Requisitos |
| Framework | FastAPI `>=0.115,<1` | API HTTP mínima |
| Server | Uvicorn `[standard]` `>=0.30,<1`, 1 worker | Adequado a Fargate pequeno |
| Container | `python:3.12-slim`, user não-root, porta 8000 | Lab + hábito seguro |
| Testes | `pytest` + Starlette/FastAPI `TestClient` (via httpx transitivo) | Cobrir `/` e `/health` |
| Logging | Default stdout | Simplifica; CW na infra |

## Fora desta unidade
- Terraform / ECR / ECS (hello-infra)
- Scripts de push / README lab (hello-tooling-docs)
