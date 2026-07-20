# Perguntas de Esclarecimento — FastAPI + Fargate + Terraform

Preencha cada `[Answer]:` com a letra da opção (ou `X` + descrição).
Quando terminar, responda no chat (ex.: **done** / **respondi**).

**Nenhum código nem plano de execução será gerado até estas respostas.**

---

## Question 1
Qual região AWS devemos usar?

A) `us-east-1` (N. Virginia)

B) `us-east-2` (Ohio)

C) `sa-east-1` (São Paulo)

D) `us-west-2` (Oregon)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 2
Como você autentica na AWS neste ambiente de estudo?

A) AWS CLI com perfil nomeado (informe o nome do perfil após a resposta, se não for `default`)

B) Variáveis de ambiente (`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` / `AWS_SESSION_TOKEN`)

C) SSO / `aws sso login` (perfil SSO)

D) Ainda não configurei — o README deve incluir o setup mínimo de credenciais antes do `terraform apply`

X) Other (please describe after [Answer]: tag below)

[Answer]: C

## Question 3
Sobre a rede (VPC/subnets) para o aprendizado, o que você prefere?

A) Criar VPC + subnet pública + Internet Gateway + route table via Terraform (mais didático: explica o “porquê” de cada recurso)

B) Usar a VPC default da conta/região (mais simples/barato em recursos, menos didático sobre networking)

C) Criar VPC mínima didática, mas reutilizar AZ única e o menor conjunto possível de recursos

X) Other (please describe after [Answer]: tag below)

[Answer]: C

## Question 4
Como a task deve ficar “rodando” no Fargate? (você pediu uma ÚNICA task com IP público, sem ALB)

A) `aws_ecs_service` com `desired_count = 1`, `assign_public_ip = true`, sem load balancer (task gerenciada; IP pode mudar se a task reiniciar)

B) Task avulsa (`RunTask` / recurso equivalente), sem ECS Service — uma execução única; documentar como obter o IP e que a task pode parar

C) ECS Service `desired_count = 1` + script/documentação para capturar o IP público atual da ENI após o apply

X) Other (please describe after [Answer]: tag below)

[Answer]: C

## Question 5
Como o IP público deve aparecer no output do Terraform?

A) Output automático no `terraform apply` (Terraform espera a task ficar RUNNING e resolve o IP da ENI — pode usar `time_sleep` / data sources)

B) Output com instruções: após apply, um comando AWS CLI/`aws ecs` para obter o IP (Terraform não bloqueia esperando a task)

C) Ambos: tentar output automático + documentar comando CLI de fallback

X) Other (please describe after [Answer]: tag below)

[Answer]: C

## Question 6
Onde fica o build e push da imagem Docker para o ECR?

A) Fora do Terraform: script (PowerShell/Make) documentado — `docker build` + `docker push` antes ou depois de criar o ECR

B) Terraform orquestra com `null_resource` / `local-exec` (build+push no apply; requer Docker local)

C) Separar: Terraform só cria ECR/infra; um script `scripts/build-and-push.ps1` é o caminho oficial (recomendado para clareza didática)

X) Other (please describe after [Answer]: tag below)

[Answer]: C

## Question 7
Qual tamanho Fargate (CPU/memória) usar? (impacto direto em custo)

A) Mínimo: `256` CPU / `512` MB (barato; suficiente para Hello World)

B) `512` CPU / `1024` MB (um pouco mais folgado)

C) Deixar configurável por variável Terraform, default `256`/`512`

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 8
Como organizar o repositório (código da app vs Terraform)?

A) `app/` (FastAPI + Dockerfile) e `infra/` (Terraform nos arquivos pedidos: ecr/ecs/iam/network/variables/outputs)

B) Raiz com app (`main.py`, `Dockerfile`, `requirements.txt`) e pasta `terraform/` com os `.tf`

C) Monorepo didático: `app/`, `infra/`, `docs/` (explicações do fluxo imagem→ECR→task→IP)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 9
O `README.md` atual documenta só o setup do AI-DLC. O que fazer com a documentação deste lab Fargate?

A) Substituir o README atual por um guia do lab Fargate (mover o setup AI-DLC para `docs/aidlc-setup.md`)

B) Manter o README do AI-DLC e criar `docs/fargate-lab.md` (ou `LAB.md`) para o lab

C) README único cobrindo: (1) setup AI-DLC breve + (2) lab FastAPI/Fargate/Terraform como conteúdo principal

X) Other (please describe after [Answer]: tag below)

[Answer]: C

## Question 10
Idioma da documentação didática (comentários Terraform, README do lab, artefatos em `aidlc-docs/`)?

A) Tudo em português (pt-BR)

B) Código/identificadores em inglês; explicações e README em português

C) Tudo em inglês

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 11
Estado (state) do Terraform neste estudo:

A) Backend local (`terraform.tfstate` no disco) — simples; lembrar de não versionar o state

B) Backend S3 (+ DynamoDB lock) — mais “real”, mas foge um pouco do mínimo e gera custo/recursos extras

C) Local agora, com comentário no código sobre como migrar para S3 depois

X) Other (please describe after [Answer]: tag below)

[Answer]: C

## Question 12
Nome/prefixo dos recursos AWS (para facilitar achar e destruir)?

A) Prefixo fixo `hello-fargate` (ex.: `hello-fargate-ecr`, cluster `hello-fargate`)

B) Prefixo configurável via variável `project_name` (default `hello-fargate`)

C) Usar o nome do repositório `ia-dlc-ecs-fargate-alb-service` como prefixo (mesmo sem ALB neste escopo)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 13
Versão do Python na imagem Docker:

A) Python 3.12 (slim)

B) Python 3.11 (slim)

C) Deixar em variável/`ARG` no Dockerfile com default 3.12

X) Other (please describe after [Answer]: tag below)

[Answer]: C

## Question 14
Resposta HTTP da rota GET — formato exato do “Hello World”:

A) Texto puro: corpo `Hello World` (content-type text/plain)

B) JSON: `{ "message": "Hello World" }`

C) Ambos: `/` retorna texto e `/health` retorna JSON simples

X) Other (please describe after [Answer]: tag below)

[Answer]: C

## Question 15
Após validar o Hello World, o fluxo didático deve enfatizar o destroy?

A) Sim — checklist obrigatório: validar → `terraform destroy` → confirmar que recursos sumiram (foco em custo ~zero)

B) Sim, mas opcional: documentar destroy sem exigir como passo do critério de sucesso

C) Não priorizar destroy na documentação (só mencionar)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 16 — Security Extensions
Devemos aplicar as regras da extensão de Security neste projeto de estudo?

A) Yes — enforce all SECURITY rules as blocking constraints (recommended for production-grade applications)

B) No — skip all SECURITY rules (suitable for PoCs, prototypes, and experimental projects)

X) Other (please describe after [Answer]: tag below)

[Answer]: B

## Question 17 — Resiliency Extensions
Devemos aplicar o resiliency baseline neste projeto?

**Nota:** habilitar NÃO certifica prontidão para produção; é orientação de design. Seu escopo exclui HA/multi-AZ/ALB — se habilitar, várias práticas ficarão N/A ou só como “próximos passos”.

A) Yes — apply the resiliency baseline as directional best practices and design-time guidance

B) No — skip the resiliency baseline (suitable for PoCs, prototypes, and experimental projects)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 18 — Property-Based Testing Extension
Devemos aplicar Property-Based Testing (PBT)?

A) Yes — enforce all PBT rules as blocking constraints

B) Partial — enforce PBT rules only for pure functions and serialization round-trips

C) No — skip all PBT rules (suitable for simple Hello World / thin apps)

X) Other (please describe after [Answer]: tag below)

[Answer]: A
