# Logical Components — `hello-app`

| Componente lógico | Responsabilidade | Materialização |
|---|---|---|
| **ApiRouter** | Rotas `GET /` e `GET /health` | `app/api.py` |
| **FastApiApp** | App factory, inclui router, exception handler 500 | `app/main.py` |
| **ContainerRuntime** | Imagem slim, non-root, Uvicorn 0.0.0.0:8000, 1 worker | `app/Dockerfile` |
| **Dependencies** | Pins FastAPI/Uvicorn | `app/requirements.txt` |
| **ApiTests** | TestClient `/` e `/health` | `tests/test_api.py` |

## Explicitamente fora
- Classes HelloService/HealthService
- Middleware de security headers / timeout
- Circuit breakers, filas, DB
- Provisionamento AWS
