# API Documentation — Fase 1

| Método | Path | Resposta |
|---|---|---|
| GET | `/` | `text/plain` → `Hello World` |
| GET | `/health` | JSON `{"status":"ok","service":"hello-fargate"}` |

- Runtime: Uvicorn `main:app`, porta **8000**
- Framework: **FastAPI** (não Flask)
- Health atual: shallow (processo vivo); adequado como candidato a health check do Target Group na Fase 2
