# Perguntas de verificação — Fase 2 (HA + ALB)

Preencha cada `[Answer]:` com a letra. Avise quando terminar.  
**Nenhuma implementação Terraform/app será feita até o plano de Workflow ser aprovado.**

---

## Question 1 — Framework da API

O pedido cita Flask; o código da Fase 1 é **FastAPI**. O que fazer?

A) Manter **FastAPI** sem mudanças significativas (recomendado)

B) Reescrever a API em Flask (fora do “sem alterações significativas”)

X) Other (please describe after [Answer]: tag below)

[Answer]: A 

---

## Question 2 — Disponibilidade de rede (AZs)

Para ALB + 2 tasks com HA didática:

A) **2 AZs** / 2 subnets públicas (boa prática AWS; recomendado)

B) Manter **1 AZ** (mais barato/simples; HA incompleta)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---



## Question 3 — HTTPS

A) Somente **HTTP** no ALB (porta 80) — lab didático

B) **HTTPS** com ACM (exige domínio/certificado)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---



## Question 4 — IP público nas Tasks (com ALB)

A) Subnets públicas + `assign_public_ip = true` (sem NAT; lab barato; acesso HTTP principal só via ALB)

B) Tasks privadas + **NAT Gateway** (mais “produção”, custo maior)

C) Manter também acesso direto por IP da task além do ALB (não recomendado didaticamente)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---



## Question 5 — Health check do Target Group

A) Path `/health`, porta **8000**, matcher 200 (usa endpoint atual)

B) Path `/` (Hello World)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---



## Question 6 — Desired count e self-healing

A) Confirmar **desired_count = 2** + teste: encerrar 1 task e observar recriação + TG

B) Começar com desired=2 mas **adiar** o exercício de matar task

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---



## Question 7 — Escopo de mudanças no repositório

A) Principalmente `infra/` + README/scripts/docs; app intacta

B) Também refatorar nomes/prefixo do projeto (ex.: `hello-fargate-alb`)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---



## Question 8 — Estratégia de apply sobre a Fase 1

A) Evoluir o Terraform **in-place** (atualizar stack existente; pode exigir destroy parcial)

B) Exigir `terraform destroy` **da Fase 1** e `apply` limpo da Fase 2 (mais previsível no lab)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---



## Question 9 — Security Extensions

Should security extension rules be enforced for this project?

A) Yes — enforce all SECURITY rules as blocking constraints (recommended for production-grade applications)

B) No — skip all SECURITY rules (suitable for PoCs, prototypes, and experimental projects)

X) Other (please describe after [Answer]: tag below)

[Answer]: B

---



## Question 10 — Resiliency Extensions

Should the resiliency baseline be applied to this project?

A) Yes — apply the resiliency baseline as directional best practices and design-time guidance (recommended — alinhado ao objetivo HA/self-healing)

B) No — skip the resiliency baseline

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---



## Question 11 — Property-Based Testing Extension

Should property-based testing (PBT) rules be enforced for this project?

A) Yes — enforce all PBT rules as blocking constraints

B) Partial — only for pure functions / serialization

C) No — skip all PBT rules (Hello World + infra; recomendado)

X) Other (please describe after [Answer]: tag below)

[Answer]: C