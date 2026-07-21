# Application Design — Decisão Q5 (Fase 2)

## Situação
- **Q5 resposta do usuário**: B (app com tratamento especial de header/host do ALB)
- **Requirements aprovados**: app FastAPI **intacta**, sem mudanças significativas
- **Q5 opção A**: app não conhece o ALB

## Resolução de design
Adotado **A** (app não conhece o ALB). Opção B exigiria alteração de código e contradiz RF-F2-01.

Se a intenção real for B, use **Request Changes** neste gate e descreva o comportamento desejado.
