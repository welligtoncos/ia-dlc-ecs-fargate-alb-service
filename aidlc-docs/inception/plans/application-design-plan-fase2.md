# Plano de Application Design — Fase 2 (HA + ALB)

Preencha cada `[Answer]:`. Avise quando terminar (ex.: **preenchido**).  
Só depois geramos artefatos em `aidlc-docs/inception/application-design/` (Fase 2).  
**Sem implementação Terraform ainda.**

## Contexto
- Evolução: ALB público + TG + HC `/health` + Service `desired=2` + 2 AZs
- App FastAPI **intacta**; mudanças em CloudInfra + Tooling/docs
- Acesso principal: DNS do ALB (não IP da task)

## Artefatos a gerar (após respostas + aprovação)
- [x] `components.md`
- [x] `component-methods.md`
- [x] `services.md`
- [x] `component-dependency.md`
- [x] Validação de consistência (+ `q5-resolution.md`)

---

## Question 1 — Fronteira dos componentes (Fase 2)
Como modelar os componentes novos?

A) Manter ApiApp + ContainerImage + CloudInfra + Tooling; **dentro de CloudInfra** detalhar sub-responsabilidades ALB/TG/Service (recomendado)

B) Novo componente de primeiro nível **LoadBalancing** (ALB+TG) separado de CloudInfra

C) Espelhar 1:1 só as unidades ativas (`hello-infra`, `hello-tooling-docs`)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 2 — Quem “dona” o endpoint público
A) **ALB** é o endpoint estável; output `alb_dns_name`; IP da task deixa de ser o fluxo principal do README

B) Documentar ALB **e** IP da task como caminhos oficiais iguais

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 3 — Orquestração do lab (LabOrchestration)
A) Manter LabOrchestration conceitual: SSO → apply → build-and-push → curl **DNS ALB** → exercício self-healing → destroy

B) Só README, sem nomear LabOrchestration

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 4 — Métodos/contratos do Service + ALB (nível design)
O que documentar em `component-methods.md`?

A) Contratos de alto nível: `register_targets`, `health_check(/health)`, `desired_count=2`, `force_redeploy` (script) — sem lógica de negócio da app

B) Detalhar também códigos HTTP e timeouts do HC já no Application Design (pode ficar para Infra Design)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 5 — Dependências / comunicação
A) Cliente → ALB → TG → Tasks; Tooling → ECR/ECS; Terraform provisiona tudo; App não conhece o ALB

B) App deve receber header/host do ALB de forma especial (custom code) — **não** recomendado neste lab

X) Other (please describe after [Answer]: tag below)

[Answer]: B

---

## Question 6 — Padrão de Security Groups no design
A) Dois SGs: **alb** (80 in) e **task** (8000 in **somente** do SG alb)

B) Um único SG compartilhado ALB+tasks (mais simples, pior isolamento)

X) Other (please describe after [Answer]: tag below)

[Answer]: A
