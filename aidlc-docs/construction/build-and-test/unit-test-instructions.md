# Instruções de Testes Unitários

## Contexto
Não há suíte automatizada de unit tests (sem código de aplicação nesta unidade). A verificação é **manual / checklist**, alinhada ao README.

## Executar verificações equivalentes a “unitários”

### 1. Checklist de conteúdo do README

Na raiz do repositório:

```powershell
$r = Get-Content ".\README.md" -Raw
@(
  @{ Nome = 'Pré-requisitos'; Ok = $r -match 'Pr[eé]-?requisitos' },
  @{ Nome = 'Caminho Downloads'; Ok = $r -match 'Downloads\\aidlc-rules' },
  @{ Nome = 'alwaysApply'; Ok = $r -match 'alwaysApply' },
  @{ Nome = 'core-workflow'; Ok = $r -match 'core-workflow' },
  @{ Nome = 'aidlc-rule-details'; Ok = $r -match 'aidlc-rule-details' },
  @{ Nome = 'Checklist'; Ok = $r -match 'Checklist' },
  @{ Nome = 'Troubleshooting'; Ok = $r -match 'Troubleshooting' },
  @{ Nome = 'Como começar'; Ok = $r -match 'Como começar' }
) | ForEach-Object { "{0}: {1}" -f $_.Nome, $_.Ok }
```

### 2. Revisar resultados
- **Esperado**: todos `True`
- **Cobertura**: RF-1 a RF-7 do documento de requisitos
- **Relatório**: anotar falhas e corrigir o README

### 3. Se alguma verificação falhar
1. Abra `README.md`
2. Compare com `aidlc-docs/inception/requirements/requirements.md`
3. Ajuste a seção faltante
4. Rode o script novamente
