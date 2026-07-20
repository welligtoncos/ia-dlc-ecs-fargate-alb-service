# Plano NFR Requirements — `hello-infra`

Preencha cada `[Answer]:`. Avise no chat quando terminar.

## Contexto da unidade
Terraform: VPC 1 AZ, ECR, IAM, ECS Fargate service (desired_count=1, IP público, sem ALB), CloudWatch Logs, outputs, destroy.

Decisões já fixadas nos requisitos (não reabrir, só confirmar NFR/ops):
- Região `us-east-1`, Fargate 256/512, prefixo `hello-fargate`, state local, single-AZ, Security Baseline off

---

## Question 1 — Escopo de logs CloudWatch
A) Criar log group dedicado Terraform (`/ecs/hello-fargate`) com retenção curta (ex.: 7 dias) para custo baixo

B) Usar awslogs sem retenção explícita (default da conta)

C) Sem log group gerenciado — só `awslogs` apontando para grupo criado automaticamente pelo ECS (se aplicável) / mínimo possível

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 2 — Tag da imagem ECR na task definition
A) Tag fixa `latest` (simples para o lab)

B) Tag `hello-fargate` (nome do projeto)

C) Variável Terraform `image_tag` com default `latest`

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 3 — Comportamento do service se a imagem ainda não existir no primeiro apply
A) Aceitar: service/tasks podem falhar até o `build-and-push`; documentar no README (ordem apply → push → redeploy)

B) Terraform cria só até ECR + rede + IAM no “primeiro passo”; ECS service em módulo/flag opcional (mais complexo)

C) Usar imagem pública placeholder temporária e depois trocar (menos didático / confuso)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 4 — Ingresso no security group (porta 8000)
A) `0.0.0.0/0` IPv4 (e opcionalmente `::/0`) — lab aberto; documentar risco

B) Variável `allowed_cidr` com default `0.0.0.0/0` (configurável)

C) Apenas o IP público atual do operador (menos prático; muda com frequência)

X) Other (please describe after [Answer]: tag below)

[Answer]: B

## Question 5 — Versão do provider Terraform AWS / Terraform
A) Terraform `>= 1.5`, AWS provider `~> 5.0` (faixas amplas)

B) Pinagem mais estrita (informe versões preferidas em Other)

C) Sem pinagem além do necessário para o lab funcionar; documentar versões testadas no README depois

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 6 — Nome do repositório ECR
A) `hello-fargate` (igual ao prefixo)

B) `hello-fargate/app`

C) Variável `ecr_repository_name` default `hello-fargate`

X) Other (please describe after [Answer]: tag below)

[Answer]: 
A
---

## Artefatos a gerar após respostas
- [x] `aidlc-docs/construction/hello-infra/nfr-requirements/nfr-requirements.md`
- [x] `aidlc-docs/construction/hello-infra/nfr-requirements/tech-stack-decisions.md`

## Compliance
| Extension | Status |
|---|---|
| Security | N/A (desabilitada) — SG aberto é consciente para lab |
| Resiliency | single-AZ, recover via destroy/reapply, logs |
| PBT | N/A nesta unidade |
