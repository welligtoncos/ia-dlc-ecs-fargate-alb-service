# Plano NFR Requirements — `hello-tooling-docs`

Preencha cada `[Answer]:`. Avise quando terminar.

Escopo: `scripts/build-and-push.ps1`, helper de IP, README (AI-DLC breve + lab), `.gitignore`, mover policy para `docs/`.

---

## Question 1 — Shell do script oficial
A) PowerShell apenas (`build-and-push.ps1`) — alinhado ao lab Windows

B) PowerShell + nota bash equivalente no README (sem segundo script)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 2 — Helper de IP público
A) Função/seção no mesmo `build-and-push.ps1` opcional via parâmetro `-ResolvePublicIp`

B) Script separado `scripts/get-public-ip.ps1`

C) Só documentar comandos AWS CLI no README (sem script helper)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 3 — Conteúdo do README
A) Unificado: (1) AI-DLC breve no topo + (2) lab Fargate como conteúdo principal (requisito Q9=C)

B) README só do lab; AI-DLC só link para arquivo antigo

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 4 — `.gitignore`
A) Ignorar `.terraform/`, `*.tfstate*`, `.terraform.lock.hcl` opcional manter lock commitado, `__pycache__`, `.venv`, `.env`, IDE

B) Mínimo só Terraform state + Python cache

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 5 — Policy IAM
A) Mover `ecs-fargate-alb-policy.json` → `docs/ecs-fargate-alb-policy.json` e atualizar comandos no README

B) Copiar para `docs/` e manter na raiz também (duplicado — evitar)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 6 — Perfil AWS SSO no script
A) Variável/parâmetro `-AwsProfile` opcional (default do ambiente)

B) Sempre exigir `-AwsProfile`

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Artefatos após respostas
- [x] `nfr-requirements/nfr-requirements.md`
- [x] `nfr-requirements/tech-stack-decisions.md`
