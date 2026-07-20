# Unit Test Execution — Lab Hello Fargate

## Run Unit Tests

### 1. Executar testes da API (`hello-app`)

Na raiz do repositório:

```powershell
pip install -r app\requirements.txt
pytest -q
```

### 2. Resultados esperados
- **Total**: 2 testes (`GET /`, `GET /health`)
- **Passed**: 2
- **Failed**: 0
- **Arquivos**: `tests/test_api.py`, `tests/conftest.py`

### 3. Se falhar
1. Conferir imports em `app/api.py` e `app/main.py`
2. Garantir que o cwd é a raiz do repo (pytest encontra `tests/`)
3. Reinstalar deps: `pip install -r app\requirements.txt`
4. Rodar `pytest -v` para detalhe

## Verificações manuais de tooling (`hello-tooling-docs`)

Não há pytest para o script PowerShell. Checklist:

```powershell
Test-Path .\scripts\build-and-push.ps1
Test-Path .\docs\ecs-fargate-alb-policy.json
Test-Path .\README.md
Test-Path .\.gitignore
Select-String -Path .\README.md -Pattern "Validação local|build-and-push|terraform destroy|allowed_cidr"
```

## Terraform (`hello-infra`)

Sem unit test automatizado. Validação estática:

```powershell
terraform -chdir=infra fmt -check
terraform -chdir=infra validate   # requer terraform init prévio
```
