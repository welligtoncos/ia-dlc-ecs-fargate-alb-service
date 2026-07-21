# Plano NFR Design — `hello-infra` Fase 2 (HA + ALB)

Preencha cada `[Answer]:`. Avise quando terminar.

Contexto NFR: 2 AZs, desired=2, ALB/TG HC `/health`, SG ALB→tasks, logs 7d, destroy obrigatório, apply in-place.

---

## Question 1 — Padrão de self-healing
A) **Service + TG**: ECS recria tasks; ALB/TG só envia tráfego a targets healthy (padrão lab)

B) Adicionar circuit breaker / retry na app (exige mudança de código — fora do escopo)

X) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 2 — Deployment / rolling do Service
A) Defaults ECS (`maximumPercent=200`, `minimumHealthyPercent=100`) — ok para desired=2

B) Relaxar `minimumHealthyPercent` (ex.: 50) para deploys mais agressivos no lab

X) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 3 — Escala
A) **N/A** — `desired_count=2` fixo; sem autoscaling (escopo Fase 2)

B) Incluir Application Auto Scaling (fora do pedido atual)

X) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 4 — Componentes lógicos no NFR Design
A) Documentar: NetworkHA, LoadBalancer (ALB+TG), EcsHaService, Logging (sem inventar app components)

B) Só uma lista flat de recursos AWS sem agrupamento lógico

X) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 5 — Resiliency test pattern
A) Padrão didático: curl DNS ALB → stop 1 task → observar nova task + TG → curl continua OK

B) Automatizar o teste com script PowerShell que mata a task via CLI

X) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 6 — Gap imagem ausente no 1º apply
A) Manter: service sobe; tasks podem falhar até push; documentar (como Fase 1)

B) Usar placeholder image pública até o primeiro push (mais complexo)

X) Other (please describe after [Answer]: tag below)

[Answer]: 
