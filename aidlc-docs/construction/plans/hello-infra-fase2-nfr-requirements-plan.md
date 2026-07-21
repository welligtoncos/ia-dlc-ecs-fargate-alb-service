# Plano NFR Requirements — `hello-infra` Fase 2 (HA + ALB)

Preencha cada `[Answer]:`. Avise quando terminar.  
Security Baseline: **OFF**. Resiliency: **ON**. PBT: **OFF**.

---

## Question 1 — Disponibilidade / HA
A) Confirmar: 2 AZs + desired=2 + ALB/TG como postura HA didática (RTO estudo = recreate/redeploy; sem multi-região)

B) Exigir também multi-região (fora de escopo do lab)

X) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 2 — Health check do Target Group (parâmetros)
A) Path `/health`, port 8000, matcher 200; intervalos/defaults razoáveis do AWS provider (detalhe no Infra Design)

B) Definir já timeouts explícitos agora (ex.: interval 30s, healthy/unhealthy thresholds 2/3)

X) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 3 — Custo / destroy
A) Manter destroy obrigatório no README; alertar custo do ALB + 2 tasks

B) Sem ênfase em destroy (não recomendado)

X) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 4 — Logs / observabilidade
A) Manter CloudWatch Logs da task (retenção 7d); sem Container Insights

B) Habilitar Container Insights (custo extra)

X) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 5 — Segurança mínima (Security OFF)
A) SG tasks: 8000 só do SG ALB; ALB:80 com `allowed_cidr` (default aberto documentado)

B) Forçar `allowed_cidr` obrigatório sem default 0.0.0.0/0 (bloqueia apply até informar IP)

X) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 6 — Drift da stack Fase 1 (in-place)
A) Aceitar replace de recursos de rede/SG no apply; documentar no README que `plan` pode destruir/recriar subnet/SG

B) Exigir destroy completo antes de qualquer apply Fase 2 (contradiz Q8 Requirements = in-place, só se usuário mudar)

X) Other (please describe after [Answer]: tag below)

[Answer]: 
