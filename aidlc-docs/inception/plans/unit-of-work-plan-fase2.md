# Plano de Units Generation — Fase 2 (HA + ALB)

Preencha cada `[Answer]:`. Avise quando terminar.  
**Sem geração dos `unit-of-work*.md` até aprovar este plano após as respostas.**

## Proposta (do execution-plan-fase2)
| Unidade | Papel na Fase 2 | Loop Construction |
|---|---|---|
| `hello-infra` | Terraform: 2 AZ, ALB, TG, Service desired=2, SGs | EXECUTAR |
| `hello-tooling-docs` | README/script/policy: DNS ALB + self-healing | EXECUTAR |
| `hello-app` | FastAPI intacta | **PULAR** code gen |

Ordem proposta: **infra → tooling-docs**

## Artefatos após aprovação do plano
- [x] Atualizar `unit-of-work.md` (Fase 2)
- [x] Atualizar `unit-of-work-dependency.md`
- [x] Atualizar `unit-of-work-story-map.md` (mapear RF-F2-*)
- [x] Validar fronteiras

---

## Question 1 — Confirmar unidades ativas
A) Confirmar: Construction só em `hello-infra` + `hello-tooling-docs`; `hello-app` SKIP

B) Incluir também um loop mínimo em `hello-app` (ex.: só validar HC)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 2 — Ordem de geração
A) `hello-infra` primeiro, depois `hello-tooling-docs` (recomendado)

B) `hello-tooling-docs` primeiro (docs antes da infra — não recomendado)

X) Other (please describe after [Answer]: tag below)

[Answer]: A
---

## Question 3 — Fronteira ALB/TG
A) **Tudo** ALB/TG/HC/Service/rede HA dentro de `hello-infra`

B) Separar uma unidade nova só para ALB (ex.: `hello-alb`) — mais granulado que o necessário

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 4 — Ownership do README / script na Fase 2
A) `hello-tooling-docs` atualiza README + ajustes mínimos no script (ex.: imprimir `alb_dns_name`)

B) Só README; script permanece 100% igual à Fase 1

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 5 — Mapeamento de requisitos
A) Mapear RF-F2-01..09 nas unidades (story-map por RF; sem User Stories)

B) Criar User Stories agora e mapear stories→units (reabre Stories)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 6 — Modelo das unidades
A) Continuar como **módulos do mesmo lab** (não microserviços deployáveis separados)

B) Tratar infra e tooling como “serviços” independentes com versionamento separado

X) Other (please describe after [Answer]: tag below)

[Answer]: A
