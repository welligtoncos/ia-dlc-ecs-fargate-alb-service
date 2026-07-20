# Plano Infrastructure Design — `hello-tooling-docs` (mínimo)

Preencha cada `[Answer]:`. Avise quando terminar.

Esta unidade **não** cria recursos AWS — só opera Docker/AWS CLI/Terraform CLI sobre a infra já existente.

---

## Question 1 — Escopo cloud
A) Confirmar **N/A**: nenhum recurso cloud novo; scripts/docs apenas

B) Outro (descrever)

X) Other (please describe after [Answer]: tag below)

[Answer]:  A

## Question 2 — Pré-requisitos de ferramentas no design
A) Documentar: AWS CLI v2, Docker Desktop/Engine, Terraform CLI, PowerShell, SSO configurado

B) Assumir que o leitor já tem tudo (só link genérico)

X) Other (please describe after [Answer]: tag below)

[Answer]:  A

## Question 3 — Caminho do diretório `infra/` no script
A) Relativo à raiz do repo (`./infra`) detectando a partir do script

B) Parâmetro `-InfraDir` com default `./infra`

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Artefatos após respostas
- [x] `infrastructure-design/infrastructure-design.md`
- [x] `infrastructure-design/deployment-architecture.md`
- [x] Shared infra: N/A
