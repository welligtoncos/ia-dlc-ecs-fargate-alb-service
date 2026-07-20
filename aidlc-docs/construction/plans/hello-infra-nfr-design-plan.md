# Plano NFR Design — `hello-infra`

Preencha cada `[Answer]:`. Avise quando terminar.

Contexto: lab single-AZ, 1 task Fargate, sem ALB/autoscaling; recover = destroy/reapply; logs CW 7 dias; SG via `allowed_cidr`.

---

## Question 1 — Padrão de resiliência / falha da task
A) **Recreate**: se a task/serviço falhar, operador faz push/redeploy ou `terraform apply`/`destroy`+reapply (padrão estudo)

B) Adicionar health check ECS + restart automático da task apenas (já padrão do service; sem lógica extra)

C) Ambos A + B (service mantém desired_count; operador usa recreate para “DR”)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 2 — Escalabilidade
A) **N/A explícito** — `desired_count = 1` fixo; sem autoscaling (fora de escopo)

B) Variável `desired_count` default 1 (ainda sem autoscaling policy)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 3 — Performance
A) **N/A** — sem cache/CDN/tuning; Fargate 256/512 suficiente para Hello World

B) Documentar apenas limites (CPU/memória) como “capacity pattern” didático

X) Other (please describe after [Answer]: tag below)

[Answer]: B

## Question 4 — Segurança (padrões lógicos, Security Baseline off)
A) Mínimo lab: SG com `allowed_cidr`, roles IAM least-privilege *para a task* (execution + task role básicas), documentar risco do CIDR aberto

B) Adicionar VPC endpoints para ECR (mais custo/complexidade — não recomendado neste lab)

C) Somente SG aberto + roles default AWS; sem effort de least-privilege

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 5 — Componentes lógicos além dos já planejados
Além de VPC, subnet, IGW, SG, ECR, IAM roles, ECS cluster/task/service, log group — incluir algum extra?

A) Não — só o conjunto mínimo já definido nos requisitos

B) Sim: Elastic IP dedicado para a task (geralmente **não** se aplica bem a Fargate ENI efêmera — evitar)

C) Sim: NACLs customizadas (desnecessário para lab)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 6 — Padrão de “imagem ausente” no design
A) Documentar como **dependency gap** consciente: infra sobe; runtime saudável só após Tooling push + eventual force deployment

B) Introduir null_resource/local-exec no TF para build (rejeitado nos requisitos — não escolher)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Artefatos após respostas
- [x] `nfr-design/nfr-design-patterns.md`
- [x] `nfr-design/logical-components.md`

## Compliance
| Extension | Nota |
|---|---|
| Resiliency | Padrões alinhados a recreate + single-AZ + logs |
| Security | N/A baseline; padrões mínimos conscientes |
| PBT | N/A |
