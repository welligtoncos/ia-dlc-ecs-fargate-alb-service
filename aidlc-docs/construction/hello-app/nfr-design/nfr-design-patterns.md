# NFR Design Patterns — `hello-app`

## Decisões

| # | Tema | Padrão |
|---|---|---|
| 1 | Resiliência | `/health` shallow + handler 500; sem retry/circuit breaker |
| 2 | Escalabilidade | **N/A** na app (stateless; escala = ECS na infra) |
| 3 | Segurança | Sem secrets na imagem; CORS default; non-root no container |
| 4 | Componentes | Router + app FastAPI + exception handler + container |
| 5 | Testes | `tests/test_api.py` com TestClient |

## Padrões aplicados
- **Health endpoint**: disponibilidade shallow para lab/ops
- **Fail-closed errors**: 500 JSON genérico sem vazar stack ao cliente
- **12-factor lite**: config via processo/container; logs stdout
- **Least privilege container**: user não-root
- **Example-based tests**: contratos `/` e `/health`; PBT N/A

## Compliance
| Extension | Status |
|---|---|
| Resiliency | `/health` |
| PBT | N/A |
| Security Baseline | N/A (off) |
