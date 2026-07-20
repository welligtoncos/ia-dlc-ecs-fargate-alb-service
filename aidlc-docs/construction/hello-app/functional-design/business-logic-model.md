# Business Logic Model — `hello-app`

## Visão
API HTTP mínima sem estado e sem persistência. Dois endpoints; um handler de erro 500 genérico.

## Fluxos

### GET `/`
1. Cliente solicita `/`
2. Handler `get_hello` retorna texto `Hello World` (`text/plain`)
3. Sem validação de entrada; sem efeitos colaterais

### GET `/health`
1. Cliente solicita `/health`
2. Handler `get_health` retorna JSON `{"status":"ok","service":"hello-fargate"}`
3. Health check **shallow** (processo vivo) — sem checagem de dependências externas

### Erro não tratado
1. Exceção não capturada no request
2. Handler genérico 500 retorna JSON simples (ex. `{"detail":"internal_error"}`)

## Estrutura de código (decisão Q3=B)
```text
app/
  __init__.py
  api.py          # rotas / handlers
  main.py         # cria FastAPI app, inclui router, exception handler
  requirements.txt
  Dockerfile
```

## Runtime
- Uvicorn: `0.0.0.0:8000`
- Logs: stdout (CloudWatch via awslogs na infra)

## PBT
- **N/A** — respostas constantes; sem propriedades de transformação/estado
