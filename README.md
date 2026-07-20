# AI-DLC — Como adicionar ao projeto (Cursor)

Este repositório usa o **AI-DLC (AI-Driven Development Life Cycle)**: um fluxo adaptativo de desenvolvimento guiado por regras no Cursor.

Este README explica **quais são os pré-requisitos** e **como instalar** o AI-DLC no projeto no Windows com PowerShell, no Cursor.

> Os comandos abaixo assumem que o pacote `aidlc-rules` já está em `%USERPROFILE%\Downloads\aidlc-rules`.

---

## Pré-requisitos

Antes de começar, confirme:

| Item | Detalhe |
|---|---|
| **Cursor** | Cursor IDE instalado (ou editor compatível que carregue regras do projeto em `.cursor/rules/`) |
| **PowerShell** | Terminal PowerShell no Windows |
| **Pacote `aidlc-rules`** | Já baixado em `%USERPROFILE%\Downloads\aidlc-rules` |
| **Permissão de escrita** | Você consegue criar pastas/arquivos na raiz deste repositório |
| **Projeto aberto no Cursor** | Abra a pasta raiz do repositório como workspace |

### Estrutura esperada do pacote baixado

Verifique se estes caminhos existem:

```text
%USERPROFILE%\Downloads\aidlc-rules\
├── aws-aidlc-rules\
│   └── core-workflow.md
└── aws-aidlc-rule-details\
    ├── common\
    ├── inception\
    ├── construction\
    ├── operations\
    └── extensions\
```

No PowerShell, você pode validar assim:

```powershell
Test-Path "$env:USERPROFILE\Downloads\aidlc-rules\aws-aidlc-rules\core-workflow.md"
Test-Path "$env:USERPROFILE\Downloads\aidlc-rules\aws-aidlc-rule-details"
```

Ambos devem retornar `True`. Se retornarem `False`, coloque o pacote no caminho acima antes de continuar.

---

## Como adicionar o AI-DLC no Cursor

Execute os comandos **na raiz do repositório** (a pasta do projeto aberta no Cursor).

### 1) Ir para a raiz do projeto

```powershell
cd C:\caminho\para\seu\repositorio
```

### 2) Criar o arquivo de regra do Cursor com frontmatter

```powershell
New-Item -ItemType Directory -Force -Path ".cursor\rules" | Out-Null

$frontmatter = @"
---
description: "AI-DLC (AI-Driven Development Life Cycle) adaptive workflow for software development"
alwaysApply: true
---

"@

$frontmatter | Out-File -FilePath ".cursor\rules\ai-dlc-workflow.mdc" -Encoding utf8
```

Isso cria `.cursor\rules\ai-dlc-workflow.mdc` com:
- `description` do workflow AI-DLC
- `alwaysApply: true` (a regra fica sempre ativa no projeto)

### 3) Anexar o conteúdo do workflow principal

```powershell
Get-Content "$env:USERPROFILE\Downloads\aidlc-rules\aws-aidlc-rules\core-workflow.md" |
  Add-Content ".cursor\rules\ai-dlc-workflow.mdc"
```

### 4) Criar a pasta de detalhes das regras

```powershell
New-Item -ItemType Directory -Force -Path ".aidlc-rule-details"
```

### 5) Copiar os detalhes das regras

```powershell
Copy-Item "$env:USERPROFILE\Downloads\aidlc-rules\aws-aidlc-rule-details\*" ".aidlc-rule-details\" -Recurse
```

### Sequência completa (copiar e colar)

```powershell
# Na raiz do repositório
New-Item -ItemType Directory -Force -Path ".cursor\rules" | Out-Null

$frontmatter = @"
---
description: "AI-DLC (AI-Driven Development Life Cycle) adaptive workflow for software development"
alwaysApply: true
---

"@

$frontmatter | Out-File -FilePath ".cursor\rules\ai-dlc-workflow.mdc" -Encoding utf8

Get-Content "$env:USERPROFILE\Downloads\aidlc-rules\aws-aidlc-rules\core-workflow.md" |
  Add-Content ".cursor\rules\ai-dlc-workflow.mdc"

New-Item -ItemType Directory -Force -Path ".aidlc-rule-details"

Copy-Item "$env:USERPROFILE\Downloads\aidlc-rules\aws-aidlc-rule-details\*" ".aidlc-rule-details\" -Recurse
```

---

## Estrutura resultante esperada

Após o setup, a raiz do projeto deve conter pelo menos:

```text
.
├── .cursor\
│   └── rules\
│       └── ai-dlc-workflow.mdc
├── .aidlc-rule-details\
│   ├── common\
│   ├── inception\
│   ├── construction\
│   ├── operations\
│   └── extensions\
└── README.md
```

Durante o uso do AI-DLC, também será criada a pasta `aidlc-docs/` com estado, auditoria e artefatos das fases.

---

## Checklist de verificação

Marque cada item após o setup:

- [ ] Existe `.cursor\rules\ai-dlc-workflow.mdc`
- [ ] O arquivo começa com frontmatter YAML (`---` / `description` / `alwaysApply: true` / `---`)
- [ ] O arquivo contém o conteúdo de `core-workflow.md` (não está só com o frontmatter)
- [ ] Existe a pasta `.aidlc-rule-details\`
- [ ] Existem subpastas como `.aidlc-rule-details\common\` e `.aidlc-rule-details\inception\`
- [ ] No Cursor, as regras do projeto estão ativas (regra com `alwaysApply: true`)
- [ ] Ao pedir desenvolvimento no chat do Cursor, o assistente inicia o fluxo AI-DLC (welcome / workspace detection)

Comandos úteis de verificação:

```powershell
Test-Path ".cursor\rules\ai-dlc-workflow.mdc"
Test-Path ".aidlc-rule-details\common\process-overview.md"
Get-Content ".cursor\rules\ai-dlc-workflow.mdc" -TotalCount 20
(Get-Item ".cursor\rules\ai-dlc-workflow.mdc").Length
```

O tamanho do arquivo de regra deve ser claramente maior que só o frontmatter (na prática, dezenas de KB).

---

## Troubleshooting

| Problema | Possível causa | O que fazer |
|---|---|---|
| `Test-Path` do `core-workflow.md` retorna `False` | Pacote não está em Downloads ou pasta com nome diferente | Confirme `%USERPROFILE%\Downloads\aidlc-rules\aws-aidlc-rules\core-workflow.md` |
| `.mdc` quase vazio | `Add-Content` não rodou ou caminho de origem errado | Rode de novo o passo 3; confira o caminho de `Get-Content` |
| Pasta `.aidlc-rule-details` vazia | `Copy-Item` apontou para o lugar errado | Confirme origem `...\aws-aidlc-rule-details\*` e destino `.aidlc-rule-details\` |
| Cursor não parece usar o AI-DLC | Workspace aberto na pasta errada, ou regra sem `alwaysApply` | Abra a raiz do repo; confira o frontmatter; recarregue a janela do Cursor |
| Erro de encoding / caracteres estranhos | Encoding do arquivo | Use `-Encoding utf8` no `Out-File` como no passo 2 |
| Comando falha por caminho | Você não está na raiz do projeto | `cd` para a raiz antes de criar `.cursor` e `.aidlc-rule-details` |

Se precisar **refazer do zero** apenas o AI-DLC (cuidado: apaga a configuração local do AI-DLC):

```powershell
Remove-Item -Recurse -Force ".cursor\rules\ai-dlc-workflow.mdc" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force ".aidlc-rule-details" -ErrorAction SilentlyContinue
# Em seguida, execute novamente a sequência completa de instalação
```

---

## Como começar a usar depois da instalação

1. Abra o projeto no **Cursor**.
2. No chat do Agent, faça um pedido de desenvolvimento em linguagem natural, por exemplo:
   - `Adicione um endpoint de health check`
   - `Crie a infraestrutura ECS Fargate com ALB`
3. O assistente deve seguir o fluxo AI-DLC (Inception → Construction → …), com checkpoints de aprovação.
4. Artefatos do processo ficam em `aidlc-docs/` (não misturar com código da aplicação).
5. Código da aplicação fica na **raiz do workspace** (ou estrutura do projeto), nunca dentro de `aidlc-docs/`.

### Fases (visão rápida)

| Fase | Foco |
|---|---|
| **Inception** | Entender o pedido, requisitos e plano |
| **Construction** | Design (quando necessário), geração de código e testes |
| **Operations** | Placeholder futuro (deploy/monitoramento) |

O fluxo é **adaptativo**: etapas condicionais podem ser puladas em mudanças simples.

---

## Observações

- Este guia documenta o setup no **Windows + PowerShell + Cursor**.
- Não é necessário copiar o conteúdo completo de `core-workflow.md` para este README; o arquivo de regra do Cursor já o contém.
- Alterações do setup AI-DLC devem ficar limitadas a `.cursor/rules/` e `.aidlc-rule-details/`.
