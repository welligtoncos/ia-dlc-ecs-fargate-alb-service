# Plano Infrastructure Design — `hello-infra` Fase 2 (HA + ALB)

Preencha cada `[Answer]:`. Avise quando terminar.

Muitos itens já fixos (ALB HTTP :80, TG `/health` :8000, desired=2, 2 AZs, assign_public_ip=true).

---

## Question 1 — Estrutura de arquivos Terraform
A) Adicionar `alb.tf` (ALB+TG+listener+SGs relacionados) e evoluir `network.tf` / `ecs.tf` / `outputs.tf`

B) Colocar ALB+TG tudo dentro de `ecs.tf` (arquivo único maior)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 2 — CIDR da 2ª subnet
A) Subnet AZ-a `10.0.1.0/24`, AZ-b `10.0.2.0/24` (VPC `10.0.0.0/16`)

B) Subnets `10.0.10.0/24` e `10.0.20.0/24`

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 3 — Idle timeout / HC detalhe no design
A) Usar defaults do provider para HC interval/thresholds; documentar path/port/matcher

B) Fixar no Terraform: interval=30, healthy=2, unhealthy=3, timeout=5

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 4 — Nome dos recursos ALB/TG
A) Prefixo `hello-fargate` (ex.: `hello-fargate-alb`, `hello-fargate-tg`)

B) Sufixo `-fase2` nos nomes (ex.: `hello-fargate-alb-fase2`)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 5 — Outputs principais
A) `alb_dns_name` (+ `alb_arn` / `target_group_arn` úteis); IP da task deixa de ser fluxo principal

B) Manter também outputs de IP de task como oficiais iguais ao ALB

X) Other (please describe after [Answer]: tag below)

[Answer]: B

---

## Question 6 — Deregistration delay do TG
A) Default AWS (~300s) — simples

B) Reduzir para lab (ex.: 30s) para self-healing mais rápido na demo

X) Other (please describe after [Answer]: tag below)

[Answer]: A
