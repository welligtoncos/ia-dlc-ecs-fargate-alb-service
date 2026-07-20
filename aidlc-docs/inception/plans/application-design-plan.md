# Plano de Application Design — Lab FastAPI + Fargate

Preencha cada `[Answer]:` abaixo. Quando terminar, avise no chat (ex.: **done**).
Só depois disso geramos os artefatos em `aidlc-docs/inception/application-design/`.

## Contexto
- Lab didático: Hello World FastAPI → Docker → ECR → ECS/Fargate (1 service, IP público, sem ALB)
- Layout: `app/`, `infra/`, `scripts/`
- Prefixo: `hello-fargate` · Região: `us-east-1`

---

## Parte A — Perguntas de design

### Question 1 — Fronteira dos componentes lógicos
Como agrupar os componentes neste lab?

A) Três componentes: **ApiApp** (FastAPI), **ContainerImage** (Dockerfile), **CloudInfra** (Terraform+AWS) + **Tooling** (scripts/README) como quarto

B) Dois componentes: **Application** (código+Docker) e **Platform** (Terraform+scripts)

C) Espelhar as unidades do plano: `hello-app`, `hello-infra`, `hello-tooling-docs` como componentes de design 1:1

X) Other (please describe after [Answer]: tag below)

[Answer]: A

### Question 2 — Onde vive a “orquestração” do deploy didático?
O fluxo sso → terraform apply → build/push → obter IP → curl → destroy é um “serviço” de orquestração?

A) Sim — documentar um **LabOrchestration** (conceitual): passos manuais + scripts; sem serviço runtime além do ECS Service

B) Não — só listar scripts como ferramentas; orquestração fica só no README (sem componente de serviço)

C) Orquestração parcial: script PowerShell é o único “orquestrador”; README descreve o restante

X) Other (please describe after [Answer]: tag below)

[Answer]: A

### Question 3 — Responsabilidade do output do IP público
Quem “possui” a obtenção do IP no design?

A) Componente **CloudInfra** (Terraform outputs) + fallback documentado em **Tooling** (CLI/script)

B) Apenas **Tooling** (script pós-apply); Terraform não tenta output automático

C) Apenas **CloudInfra** (output automático obrigatório); CLI só como nota menor

X) Other (please describe after [Answer]: tag below)

[Answer]: A

### Question 4 — Logging / observabilidade no design de componentes
Como modelar CloudWatch Logs?

A) Parte do componente **CloudInfra** (log group / awslogs na task definition); app só faz log stdout

B) Componente separado **Observability**

C) Só mencionar no README; não modelar como componente

X) Other (please describe after [Answer]: tag below)

[Answer]: A

### Question 5 — Nível de detalhe das “methods” da API
Para `component-methods.md` da API:

A) Apenas assinaturas de alto nível: `get_hello() -> str`, `get_health() -> dict`

B) Incluir também handlers FastAPI explícitos (`@app.get("/")`, `@app.get("/health")`) no design

C) Deixar métodos da API só para Functional Design; em Application Design listar só o componente ApiApp sem methods detalhados

X) Other (please describe after [Answer]: tag below)

[Answer]: B

### Question 6 — Dependência imagem ↔ ECS Service
Como documentar o acoplamento “task precisa da imagem no ECR”?

A) Dependência runtime: **CloudInfra** depende de imagem publicada por **Tooling** a partir de **ContainerImage/ApiApp** (ordem didática no dependency.md)

B) Tratar imagem como input externo; infra assume tag `latest` sem modelar o script no grafo

C) Um único componente “DeployableUnit” que une app+imagem+task (menos didático)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Parte B — Artefatos a gerar (após respostas + sua aprovação do plano)

- [x] Gerar `components.md` — componentes e responsabilidades
- [x] Gerar `component-methods.md` — assinaturas de alto nível
- [x] Gerar `services.md` — serviços/orquestração (incl. LabOrchestration se escolhido)
- [x] Gerar `component-dependency.md` — dependências e fluxo imagem→ECR→task→IP
- [x] Gerar `application-design.md` — consolidado
- [x] Validar consistência com `requirements.md` e compliance Resiliency/PBT (N/A onde couber)

## Compliance (nesta etapa)
| Extension | Status |
|---|---|
| Security | N/A (desabilitada) |
| Resiliency | Design deve refletir single-AZ, recover via recreate, `/health`, logs |
| PBT | Sem propriedades complexas na API; marcar N/A no design da app |
