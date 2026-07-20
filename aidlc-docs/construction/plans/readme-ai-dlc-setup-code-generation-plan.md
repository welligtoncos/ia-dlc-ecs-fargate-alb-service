# Plano de Code Generation — `readme-ai-dlc-setup`

## Contexto da Unidade
- **Unidade**: `readme-ai-dlc-setup`
- **Tipo de projeto**: Greenfield (documentação)
- **Raiz do workspace**: `C:\welligton-aws\ia-dlc-ecs-fargate-alb-service\ia-dlc-ecs-fargate-alb-service`
- **Idioma**: Português (pt-BR)
- **Histórias**: N/A (User Stories pulado)
- **Dependências**: Nenhuma
- **Entregável principal**: `README.md` na raiz do workspace
- **Documentação de processo**: `aidlc-docs/construction/readme-ai-dlc-setup/code/`
- **Fonte de verdade dos requisitos**: `aidlc-docs/inception/requirements/requirements.md`
- **Fonte de verdade dos comandos**: sequência PowerShell fornecida pelo usuário no pedido inicial

## Abordagem
Gerar um único `README.md` completo em português cobrindo pré-requisitos, caminho do pacote `aidlc-rules`, setup no Cursor, checklist, troubleshooting e primeiro uso. Não alterar o conteúdo das regras AI-DLC já instaladas.

## Passos de Geração

### Passo 1 — Preparar estrutura de documentação da unidade
- [x] Garantir pasta `aidlc-docs/construction/readme-ai-dlc-setup/code/`

### Passo 2 — Criar `README.md` na raiz (conteúdo completo)
- [x] Criar/atualizar `README.md` na raiz do workspace em português, com as seções:
  1. Título e introdução ao AI-DLC neste repositório
  2. Pré-requisitos
  3. Estrutura esperada do pacote em `%USERPROFILE%\Downloads\aidlc-rules`
  4. Como adicionar o AI-DLC no Cursor (comandos PowerShell do usuário, claros e copiáveis)
  5. Checklist de verificação
  6. Troubleshooting
  7. Como começar a usar após a instalação
  8. Estrutura resultante esperada (`.cursor/rules/`, `.aidlc-rule-details/`)

### Passo 3 — Resumo da geração
- [x] Criar `aidlc-docs/construction/readme-ai-dlc-setup/code/generation-summary.md` em português descrevendo o que foi gerado e rastreabilidade aos RF-1..RF-8

### Passo 4 — Validação rápida de conteúdo
- [x] Conferir que o README:
  - Está em português
  - Usa o caminho `%USERPROFILE%\Downloads\aidlc-rules` (ou equivalente PowerShell `$env:USERPROFILE\Downloads\aidlc-rules`)
  - Inclui frontmatter, append do `core-workflow.md`, criação e cópia de `.aidlc-rule-details`
  - Inclui checklist e troubleshooting
  - Não duplica o texto completo de `core-workflow.md`

## Fora deste plano
- Alterar `.cursor/rules/ai-dlc-workflow.mdc` ou `.aidlc-rule-details/`
- Gerar código de aplicação, testes automatizados ou infraestrutura
- Etapas de API/repository/frontend (N/A)

## Compliance de Extensions
| Extension | Status |
|---|---|
| Security Baseline | N/A (desabilitada) |
| Resiliency Baseline | N/A (desabilitada) |
| PBT (Parcial) | N/A — sem funções puras/serialização |

## Critério de conclusão da Parte 2
Todos os checkboxes acima marcados `[x]` e arquivos gerados nos caminhos indicados.
