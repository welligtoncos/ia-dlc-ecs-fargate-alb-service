# Plano de Code Generation — `hello-app`

## Contexto
- Código em `app/` + testes em `tests/`
- Design: `/` text/plain Hello World; `/health` JSON com status+service; handler 500; non-root; uvicorn `main:app`
- Build context: `./app`

## Passos

### Passo 1 — Estrutura
- [x] Criar `app/` e `tests/`

### Passo 2 — `app/__init__.py`
- [x] Pacote vazio ou docstring mínima

### Passo 3 — `app/api.py`
- [x] Router: `GET /` PlainTextResponse `Hello World`; `GET /health` → `{"status":"ok","service":"hello-fargate"}`

### Passo 4 — `app/main.py`
- [x] FastAPI app, include router, exception handler 500 JSON

### Passo 5 — `app/requirements.txt`
- [x] `fastapi>=0.115,<1` e `uvicorn[standard]>=0.30,<1`
- [x] Deps de teste: `pytest`, `httpx` (ou o necessário ao TestClient)

### Passo 6 — `app/Dockerfile`
- [x] ARG PYTHON_VERSION=3.12, slim, non-root, EXPOSE 8000, CMD uvicorn main:app

### Passo 7 — `tests/test_api.py`
- [x] TestClient: assert `/` e `/health`

### Passo 8 — Resumo
- [x] `aidlc-docs/construction/hello-app/code/generation-summary.md`

### Passo 9 — Validação
- [x] Conferir alinhamento com functional/NFR/infra design

## Fora deste plano
- Terraform, scripts, README lab completo

## Compliance
| Extension | Status |
|---|---|
| PBT | N/A |
| Resiliency | `/health` |
| Security | N/A; non-root |
