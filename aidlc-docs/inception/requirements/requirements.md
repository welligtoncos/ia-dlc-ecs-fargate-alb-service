# Documento de Requisitos

## Resumo da Intenção
- **Pedido do usuário**: Adicionar um README com pré-requisitos e o passo a passo para adicionar AI-DLC ao projeto (Cursor), com base nos comandos PowerShell já executados.
- **Tipo de pedido**: Documentação (README do projeto)
- **Escopo**: Arquivo único — `README.md` na raiz do workspace
- **Complexidade**: Simples / Trivial
- **Profundidade**: Mínima
- **Idioma obrigatório**: Português (pt-BR) para **todos** os artefatos deste trabalho, incluindo `aidlc-docs/` e o `README.md`

## Decisões das Perguntas de Esclarecimento

| Tópico | Decisão |
|---|---|
| Idioma | Português (pt-BR) — inclusive documentos em `aidlc-docs/` |
| Cobertura | Guia completo: pré-requisitos, download de `aidlc-rules`, setup no Cursor, checklist de verificação e troubleshooting |
| Origem do `aidlc-rules` | Assumir pacote já baixado em `%USERPROFILE%\Downloads\aidlc-rules` |
| Security Baseline | Desabilitado (PoC / experimental) |
| Resiliency Baseline | Desabilitado (PoC / experimental) |
| Property-Based Testing | Parcial — apenas funções puras e round-trips de serialização |

## Requisitos Funcionais

### RF-1: README em português
O repositório deve conter um `README.md` na raiz, escrito em português (pt-BR).

### RF-2: Seção de pré-requisitos
Documentar os pré-requisitos para adicionar o AI-DLC, incluindo pelo menos:
- Cursor IDE (ou editor compatível que carregue regras do projeto)
- Acesso ao pacote local `aidlc-rules` em `%USERPROFILE%\Downloads\aidlc-rules`
- Estrutura esperada após o download:
  - `Downloads\aidlc-rules\aws-aidlc-rules\core-workflow.md`
  - `Downloads\aidlc-rules\aws-aidlc-rule-details\`
- PowerShell (Windows) como shell documentado para os comandos de setup
- Permissão de escrita na raiz do projeto

### RF-3: Localização do pacote
Documentar que o `aidlc-rules` é esperado em `%USERPROFILE%\Downloads\aidlc-rules` (mesmo caminho usado no setup do usuário). Não inventar URL de download diferente; focar em verificar se a pasta existe antes de copiar.

### RF-4: Passos de setup no Cursor
Documentar o fluxo exato usado pelo usuário:
1. Criar o frontmatter YAML de `.cursor\rules\ai-dlc-workflow.mdc` com `alwaysApply: true`
2. Gravar o frontmatter nesse arquivo
3. Anexar o conteúdo de `aws-aidlc-rules\core-workflow.md` ao arquivo de regra
4. Criar `.aidlc-rule-details`
5. Copiar recursivamente `aws-aidlc-rule-details\*` para `.aidlc-rule-details\`

### RF-5: Checklist de verificação
Incluir um checklist para confirmar que o AI-DLC foi instalado corretamente (arquivo de regra existe, frontmatter presente, pastas de rule details presentes, Cursor consegue carregar as regras do projeto).

### RF-6: Troubleshooting
Incluir falhas comuns (caminho Downloads ausente, arquivo de regra vazio, destino de cópia errado, Cursor não carregando regras) com remédios breves.

### RF-7: Como começar após a instalação
Incluir uma seção curta sobre como fazer o primeiro pedido de AI-DLC no Cursor após o setup (visão geral, sem tutorial completo do ciclo de vida).

### RF-8: Idioma dos artefatos AI-DLC deste trabalho
Todos os documentos gerados sob `aidlc-docs/` para este fluxo (requisitos, planos, resumos de código, build-and-test, etc.) devem ser escritos em português (pt-BR). Mensagens de checkpoint ao usuário também em português.

## Requisitos Não Funcionais

### RNF-1: Precisão
Os comandos no README devem corresponder à sequência PowerShell validada pelo usuário (adaptados apenas para clareza/legibilidade).

### RNF-2: Usabilidade
Um desenvolvedor novo no repositório deve conseguir seguir o README de forma linear, sem conhecimento prévio de AI-DLC além de instalar o Cursor.

### RNF-3: Manutenibilidade
Manter o README focado no setup; não duplicar o conteúdo completo das regras de `core-workflow.md`.

### RNF-4: Segurança operacional
Não instruir sobrescrita de arquivos não relacionados do projeto; limitar alterações a `.cursor/rules/` e `.aidlc-rule-details/`.

## Fora de Escopo
- Implementação de aplicação/serviço (ECS, ALB, etc.)
- Alteração do conteúdo das regras do AI-DLC em si
- Instruções primárias para shells que não sejam PowerShell/Windows (nota opcional breve, se necessário)
- Ativação das baselines de Security ou Resiliency nesta tarefa de documentação

## Configuração de Extensions (Projeto)
| Extension | Habilitada | Modo |
|---|---|---|
| Security Baseline | Não | Ignorada |
| Resiliency Baseline | Não | Ignorada |
| Property-Based Testing | Sim | Parcial (funções puras / round-trips de serialização) |

## Critérios de Sucesso
- Existe `README.md` na raiz do workspace em português
- Cobre pré-requisitos, caminho Downloads, setup no Cursor, verificação, troubleshooting e visão de primeiro uso
- Reflete os comandos PowerShell já validados pelo usuário
- Artefatos em `aidlc-docs/` deste fluxo estão em português
