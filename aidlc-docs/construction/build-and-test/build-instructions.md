# Instruções de Build

## Contexto
Este entregável é **documentação** (`README.md`). Não há compilação de aplicação, dependências de runtime nem artefatos binários.

## Pré-requisitos
- **Ferramenta**: PowerShell (Windows)
- **Dependências**: Nenhuma de build; o conteúdo é Markdown
- **Variáveis de ambiente**: Nenhuma obrigatória para “build”
- **Requisitos de sistema**: acesso de leitura à raiz do repositório

## Passos de “Build” (validação do artefato)

### 1. Confirmar que o README existe

```powershell
Test-Path ".\README.md"
```

Esperado: `True`

### 2. Conferir tamanho mínimo razoável

```powershell
(Get-Item ".\README.md").Length
```

Esperado: arquivo não vazio (na prática, alguns KB).

### 3. Conferir seções obrigatórias (busca rápida)

```powershell
Select-String -Path ".\README.md" -Pattern "Pré-requisitos|Downloads\\aidlc-rules|alwaysApply|Checklist|Troubleshooting|Como começar" 
```

Esperado: várias ocorrências cobrindo as seções do guia.

## Artefatos gerados
- `README.md` (raiz do workspace)
- Documentação de processo em `aidlc-docs/construction/readme-ai-dlc-setup/code/`

## Troubleshooting

### README.md não encontrado
- **Causa**: geração não executada ou workspace errado
- **Solução**: confirme que está na raiz do repositório e que Code Generation foi concluída

### Seções ausentes
- **Causa**: edição parcial do README
- **Solução**: compare com `aidlc-docs/inception/requirements/requirements.md` (RF-1 a RF-7)
