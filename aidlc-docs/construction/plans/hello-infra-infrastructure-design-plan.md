# Plano Infrastructure Design — `hello-infra`

Preencha cada `[Answer]:`. Avise quando terminar.

Muitos itens já estão fixos (AWS, Fargate, VPC 1 AZ, ECR, ECS service, sem ALB). As perguntas abaixo fecham detalhes de implementação Terraform.

---

## Question 1 — Ambiente / conta
A) Usar a conta/perfil SSO atual do operador; variável `aws_region` default `us-east-1` (sem workspaces)

B) Separar `dev` via Terraform workspace (desnecessário para lab)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 2 — CIDR da VPC / subnet
A) VPC `10.0.0.0/16`, subnet pública `10.0.1.0/24` (clássico didático)

B) VPC `10.10.0.0/16`, subnet `10.10.0.0/24`

C) Ambos via variáveis com esses defaults (A)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 3 — Seleção da AZ
A) Data source `aws_availability_zones` — pegar a primeira AZ disponível na região

B) Variável `availability_zone` explícita (ex. default `us-east-1a`)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 4 — Como obter o IP público no output Terraform
A) Data sources + `time_sleep` após o service estar up, ler ENI da task (pode deixar o apply mais lento/frágil)

B) Output “parcial”: IDs do cluster/service + instrução; script CLI no tooling faz o IP (Terraform não espera a task)

C) Híbrido: tentar A com timeout curto; se falhar, output documenta fallback CLI (alinhado a RF-06 “ambos”)

X) Other (please describe after [Answer]: tag below)

[Answer]: C

## Question 5 — Force new deployment após push da imagem
A) Fora do Terraform — documentar `aws ecs update-service --force-new-deployment` no README/script tooling

B) Incluir no script `build-and-push.ps1` o force-new-deployment ao final

C) Ambos A e B (script faz; README também explica)

X) Other (please describe after [Answer]: tag below)

[Answer]: C

## Question 6 — Storage / messaging / shared infra
A) **N/A** — sem banco, fila, EFS ou infra compartilhada com outros projetos

B) Other (please describe)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 7 — Arquivos Terraform (confirmação da estrutura)
A) Confirmar: `versions.tf`, `providers.tf`, `variables.tf`, `outputs.tf`, `network.tf`, `ecr.tf`, `iam.tf`, `ecs.tf` (+ `logs` dentro de ecs ou `logs.tf` separado)

B) Mesmos arquivos, mas log group em `logs.tf` separado (mais didático)

X) Other (please describe after [Answer]: tag below)

[Answer]: B

---

## Artefatos após respostas
- [x] `infrastructure-design/infrastructure-design.md`
- [x] `infrastructure-design/deployment-architecture.md`
- [x] Shared infra: N/A (salvo se Q6 disser o contrário)

## Compliance
| Extension | Nota |
|---|---|
| Resiliency | single-AZ, recreate, log group 7d |
| Security | SG + roles mínimas; CIDR variável |
| PBT | N/A |
