# NFR Requirements — `hello-app`

## Decisões

| # | Tema | Decisão |
|---|---|---|
| 1 | Libs | `fastapi>=0.115,<1` e `uvicorn[standard]>=0.30,<1` |
| 2 | Base image | `python:${PYTHON_VERSION}-slim` com `ARG PYTHON_VERSION=3.12` |
| 3 | User | Usuário **não-root** no Dockerfile |
| 4 | Workers | **1** worker Uvicorn |
| 5 | Testes | TestClient mínimo para `/` e `/health` |
| 6 | Logging | Default Uvicorn/FastAPI → stdout |

## Categorias

### Performance
- 1 worker; envelope de capacidade definido na infra (256/512)
- Sem cache/CDN

### Segurança (lab)
- Security Baseline off; container non-root como boa prática mínima
- Sem auth na API

### Confiabilidade
- Handler 500 genérico (Functional Design)
- `/health` shallow

### Observabilidade
- Logs stdout → awslogs (infra)

### Testabilidade
- Example-based com TestClient; PBT N/A

## Compliance
| Extension | Status |
|---|---|
| Security | N/A (off); non-root consciente |
| Resiliency | `/health` |
| PBT | N/A documentado |
