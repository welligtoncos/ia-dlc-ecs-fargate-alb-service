# Plano de Units Generation — Lab FastAPI + Fargate

Preencha cada `[Answer]:`. Quando terminar, avise no chat.
**Não geramos** `unit-of-work*.md` até você aprovar este plano após as respostas.

## Proposta inicial (do execution-plan / application-design)
| Unidade | Escopo | Componentes |
|---|---|---|
| `hello-app` | FastAPI + Dockerfile + requirements | ApiApp, ContainerImage |
| `hello-infra` | Terraform em `infra/` | CloudInfra |
| `hello-tooling-docs` | scripts + README + .gitignore | Tooling, docs LabOrchestration |

---

## Parte A — Perguntas

### Question 1 — Confirmar decomposição em 3 unidades
A) Confirmar as 3 unidades acima (`hello-app`, `hello-infra`, `hello-tooling-docs`)

B) Fundir app+Docker+scripts em uma unidade e deixar só `infra` separada (2 unidades)

C) Uma única unidade monolítica (tudo gerado junto)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

### Question 2 — Ordem de Code Generation / Construction
A) `hello-app` → `hello-infra` → `hello-tooling-docs` (código primeiro, depois IaC, depois scripts/docs)

B) `hello-infra` → `hello-app` → `hello-tooling-docs` (ECR/rede primeiro)

C) `hello-app` e `hello-infra` em paralelo conceitual, depois tooling (na prática sequencial app→infra→tooling)

X) Other (please describe after [Answer]: tag below)

[Answer]: B

### Question 3 — Ownership de `.gitignore` e arquivos na raiz
A) Unidade `hello-tooling-docs` possui `.gitignore`, README e `scripts/`

B) Cada unidade cuida do seu ignore parcial; README na tooling

C) `.gitignore` na unidade `hello-infra` (tfstate); README/scripts na tooling

X) Other (please describe after [Answer]: tag below)

[Answer]: A
### Question 4 — Política IAM `ecs-fargate-alb-policy.json` já existente
A) Permanecer na raiz; documentada pela unidade `hello-tooling-docs` (não regenerar conteúdo salvo referência)

B) Mover para `docs/` ou `scripts/` na unidade tooling

C) Fora das unidades — ignorar no UOW (só nota no README)

X) Other (please describe after [Answer]: tag below)

[Answer]: B

### Question 5 — Story map (User Stories foi pulado)
Como mapear “stories” às unidades?

A) Usar requisitos RF-01..RF-09 como “stories” sintéticas no `unit-of-work-story-map.md`

B) Usar critérios de sucesso (1–5) como stories sintéticas

C) Ambos: RFs + critérios de sucesso mapeados às unidades

X) Other (please describe after [Answer]: tag below)

[Answer]: C

### Question 6 — Modelo de deploy das unidades
A) Unidades são **módulos do mesmo lab** (não microserviços independentes); só a app vira container; infra é Terraform; tooling é scripts

B) Tratar cada unidade como “serviço” deployável separado (mesmo sendo lab)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Parte B — Artefatos a gerar (após aprovação do plano)

- [x] Gerar `aidlc-docs/inception/application-design/unit-of-work.md`
- [x] Gerar `aidlc-docs/inception/application-design/unit-of-work-dependency.md`
- [x] Gerar `aidlc-docs/inception/application-design/unit-of-work-story-map.md`
- [x] Documentar organização de código greenfield em `unit-of-work.md`
- [x] Validar fronteiras e dependências
- [x] Garantir que todos os RF/critérios estejam atribuídos a unidades

## Compliance
| Extension | Nesta etapa |
|---|---|
| Security | N/A |
| Resiliency | Unidades devem permitir destroy/recreate e single-AZ |
| PBT | Escopo PBT fica na unidade `hello-app` (provável N/A) |
