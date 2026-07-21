# Plano NFR Design — `hello-tooling-docs` Fase 2 (mínimo)

Preencha cada `[Answer]:`. Avise quando terminar.

Contexto NFR: script sempre imprime `alb_dns_name`; `-ResolvePublicIp` alternativo; README reescrito HA+ALB + exercício self-healing; destroy/custo; policy revisão mínima.

Infra Design desta unidade: **N/A** → após NFR Design: **Code Generation**.

---

## Question 1 — Resilience (documentação / runbook)
A) Padrão **LabOrchestration HA**: README + script orientam curl via ALB; exercício manual stop-task demonstra self-healing (ECS+TG) — sem automação de kill no script

B) Adicionar ao script um switch `-DemoSelfHealing` que para uma task via CLI

X) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 2 — Fail-fast / erros do script
A) Manter `$ErrorActionPreference = 'Stop'` + throws claros; se `alb_dns_name` falhar (sem apply), mensagem pedindo `terraform apply`

B) Soft-fail: se ALB output faltar, só avisar e continuar sem curls sugeridos

X) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 3 — Escalabilidade / Performance (docs)
A) **N/A** — unidade de docs/script; sem cache, filas ou SLOs; mencionar desired=2 fixo no README

B) Documentar “como adicionar autoscaling” (fora do escopo de implementação)

X) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 4 — Segurança (Security OFF — padrão docs)
A) Documentar risco `allowed_cidr` aberto + SG só ALB→task; não inventar auth no script

B) Exigir no README que o operador restrinja `allowed_cidr` antes do apply (bloqueante textual)

X) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 5 — Componentes lógicos Fase 2
A) Evoluir: **ScriptBuildPush** (sempre print ALB + opcional IP), **DocLabOrchestration** (HA/ALB/self-healing/destroy), **IamPolicyDoc** (revisão mínima); **GitIgnore** inalterado

B) Criar componente novo separado (ex.: DocSelfHealingGuide) além do README

X) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 6 — Ordem do runbook no README
A) SSO → plan/apply (aviso replace) → build-and-push → curl ALB → self-healing → destroy

B) Self-healing antes do primeiro curl (não recomendado)

X) Other (please describe after [Answer]: tag below)

[Answer]: 
