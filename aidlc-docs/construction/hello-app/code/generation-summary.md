# Resumo da Geração — `hello-app`

## Arquivos criados

| Arquivo | Descrição |
|---|---|
| `app/__init__.py` | Pacote |
| `app/api.py` | Rotas `/` e `/health` |
| `app/main.py` | FastAPI + handler 500 |
| `app/requirements.txt` | FastAPI, Uvicorn, pytest, httpx |
| `app/Dockerfile` | slim 3.12, non-root, uvicorn main:app |
| `tests/conftest.py` | PYTHONPATH → app/ |
| `tests/test_api.py` | TestClient `/` e `/health` |

## Como validar localmente
```powershell
pip install -r app/requirements.txt
pytest tests -q
docker build -t hello-fargate:latest ./app
```

## Compliance
| Extension | Status |
|---|---|
| PBT | N/A |
| Resiliency | `/health` |
| Security | N/A; non-root |
