# Esclarecimentos obrigatórios — Resiliency Baseline

Você habilitou a extensão **Resiliency**. Estas perguntas são obrigatórias antes de aprovar a Análise de Requisitos.
Opções já consideram que este é um **lab de estudo** (sem ALB, sem multi-AZ, sem CI/CD no escopo).

Preencha cada `[Answer]:` e avise no chat quando terminar.

---

## Question 1 — RTO/RPO e estratégia de DR

A) RPO/RTO: horas — Backup & Restore / recriar com Terraform (menor custo; adequado a estudo)

B) RPO/RTO: dezenas de minutos — Pilot Light

C) RPO/RTO: minutos — Warm Standby

D) Near real-time — Active/Active multi-site

E) N/A — single-region basta; sem DR cross-region (aceita 1 AZ neste lab)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 2 — Change management

A) Usar processo formal da organização (cite o nome/ferramenta após a resposta)

B) Propor processo leve (registro de mudança + aprovação + nota de rollback)

C) N/A — isento (lab de estudo individual); documentar isenção

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 3 — CI/CD

A) Usar pipeline existente (cite a ferramenta)

B) Pedir que o AI-DLC proponha pipeline (mesmo fora do escopo atual de implementação)

C) Other — deploy manual apenas (`scripts/build-and-push.ps1` + `terraform apply`); CI/CD permanece fora de escopo

X) Other (please describe after [Answer]: tag below)

[Answer]: C

## Question 4 — Mecanismo de rollback

A) Redeploy da versão anterior (imagem/tag + Terraform / re-apply)

B) Blue/green

C) Canary com rollback automático

D) Rollback com banco (N/A neste lab — sem banco)

E) Procedimento existente da organização

F) Other — `terraform destroy` + reapply / re-push da imagem boa (padrão estudo)

X) Other (please describe after [Answer]: tag below)

[Answer]: F

## Question 5 — Estilo de deploy

A) Direct / in-place (aceitável para lab não crítico)

B) Rolling

C) Blue/green

D) Canary

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 6 — Topologia regional

A) Single-region multi-AZ

B) Multi-region active-passive

C) Multi-region active-active

D) Other — **single-region, single-AZ** (alinhado ao escopo do lab; sem HA)

X) Other (please describe after [Answer]: tag below)

[Answer]: D

## Question 7 — Testes de resiliência / chaos

A) Usar prática existente da organização

B) Propor abordagem mínima

C) Adiar para Operations / fora deste lab (só documentar)

X) Other (please describe after [Answer]: tag below)

[Answer]: B

## Question 8 — Resposta a incidentes

A) Usar processo existente da organização

B) Propor processo leve para o lab

C) N/A — estudo individual; documentar isenção

X) Other (please describe after [Answer]: tag below)

[Answer]: A
