# Build and Test Summary — Lab Hello Fargate

## Build Status
- **Ferramentas**: pip, Docker, Terraform, AWS CLI, PowerShell
- **Status**: Instruções geradas (execução AWS fica com o operador)
- **Artefatos principais**: `app/`, `infra/`, `scripts/build-and-push.ps1`, `README.md`, `.gitignore`, `docs/`

## Test Execution Summary

### Unit Tests (`hello-app`)
| Item | Valor |
|---|---|
| Comando | `pytest -q` |
| Esperado | 2 passed |
| Status | Operador deve executar localmente |

### Tooling / docs checklist
| Item | Esperado |
|---|---|
| Script, README, gitignore, policy em `docs/` | Presentes |
| Seção Validação local no README | Presente |

### Integration
| Cenário | Tipo |
|---|---|
| Docker local + curl | Sem AWS |
| `build-and-push.ps1` + outputs TF | Com AWS |
| apply → push → curl → destroy | E2E lab |

### Performance
- **Status**: N/A (lab didático)

### Adicionais
- Contract / Security automated: N/A
- E2E: checklist do README + integration Scenario 3

## Arquivos desta etapa
- `build-instructions.md`
- `unit-test-instructions.md`
- `integration-test-instructions.md`
- `performance-test-instructions.md`
- `build-and-test-summary.md`

## Status geral
- **Construction**: Build and Test documentado — aguardando aprovação do operador
- **Pronto para Operations**: Após aprovação explícita (Operations = placeholder)

## Compliance de Extensions
| Extension | Status |
|---|---|
| Security Baseline | N/A (desabilitada) |
| Resiliency Baseline | Compliant — smoke curl + destroy/recreate no README/instruções |
| PBT | N/A (Hello World fino) |
