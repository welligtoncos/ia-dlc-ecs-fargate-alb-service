# Instruções de Testes de Integração

## Propósito
Validar que o README descreve um fluxo que **integra** corretamente com os artefatos locais do AI-DLC (pacote em Downloads + pastas do projeto).

## Cenários

### Cenário 1: Pacote de origem ↔ comandos do README
- **Descrição**: Os caminhos citados no README existem na máquina de setup
- **Setup**: pacote em `%USERPROFILE%\Downloads\aidlc-rules`
- **Passos**:
  1. `Test-Path "$env:USERPROFILE\Downloads\aidlc-rules\aws-aidlc-rules\core-workflow.md"`
  2. `Test-Path "$env:USERPROFILE\Downloads\aidlc-rules\aws-aidlc-rule-details"`
- **Esperado**: ambos `True` em um ambiente onde o setup será repetido
- **Cleanup**: nenhum

### Cenário 2: Artefatos do projeto ↔ checklist do README
- **Descrição**: Após setup (já feito neste repo), os caminhos do checklist existem
- **Passos**:
  1. `Test-Path ".\.cursor\rules\ai-dlc-workflow.mdc"`
  2. `Test-Path ".\.aidlc-rule-details\common\process-overview.md"`
  3. `Get-Content ".\.cursor\rules\ai-dlc-workflow.mdc" -TotalCount 8`
- **Esperado**: arquivos existem; frontmatter com `alwaysApply: true` nas primeiras linhas
- **Cleanup**: nenhum

### Cenário 3: Sequência PowerShell do README é coerente
- **Descrição**: Ordem documentada = frontmatter → append → criar pasta → copiar
- **Passos**: leitura manual da seção “Como adicionar o AI-DLC no Cursor”
- **Esperado**: mesma ordem da sequência validada pelo usuário

## Ambiente
Não é necessário subir serviços, containers ou bancos.

## Status desta execução
Verificações do Cenário 2 foram executadas neste workspace com sucesso (artefatos presentes).
