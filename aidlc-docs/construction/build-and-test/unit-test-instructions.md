# Unit Test Execution — Fase 2

App **intacta** (`hello-app` SKIP na Construction Fase 2). Testes unitários da API permanecem válidos.

## Run Unit Tests

```powershell
pip install -r app\requirements.txt
pytest -q
```

## Resultados esperados
| Item | Valor |
|---|---|
| Testes | `tests/test_api.py` (`/` e `/health`) |
| Esperado | **2 passed** |
| Execução neste stage | **2 passed** (2026-07-21) |

## Se falhar
1. Conferir venv / `requirements.txt`
2. Rodar `pytest -v` e corrigir apenas se a API tiver sido alterada (não deveria na Fase 2)
