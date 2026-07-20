# Plano NFR Requirements — `hello-app`

Preencha cada `[Answer]:`. Avise quando terminar.

Stack já direcionada: Python + FastAPI + Uvicorn, Docker (ARG Python 3.12), porta 8000. Infra AWS fica na unidade `hello-infra`.

---

## Question 1 — Versões das libs Python
A) `fastapi` e `uvicorn[standard]` sem pin estrito (faixas flexíveis no requirements, ex. mínimas recentes)

B) Pin aproximado didático: `fastapi>=0.115,<1` e `uvicorn[standard]>=0.30,<1`

X) Other (please describe after [Answer]: tag below)

[Answer]: B

## Question 2 — Imagem base Docker
A) `python:3.12-slim` via `ARG PYTHON_VERSION=3.12` (requisito)

B) `python:3.12-alpine` (menor, às vezes mais chata com wheels)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 3 — Usuário no container
A) Rodar como root (simples para lab)

B) Criar user não-root no Dockerfile (melhor hábito, um pouco mais de linhas)

X) Other (please describe after [Answer]: tag below)

[Answer]: B

## Question 4 — Performance / workers Uvicorn
A) 1 worker (default) — adequado ao Fargate 256/512

B) 2 workers (pode ser apertado em 512 MB)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 5 — Testes automatizados nesta unidade
A) Sem testes automatizados no Code Gen (validação via curl no lab) — alinhado a PBT N/A

B) Um teste example-based mínimo com `httpx`/`TestClient` para `/` e `/health`

X) Other (please describe after [Answer]: tag below)

[Answer]: B

## Question 6 — Logging na app
A) Logs default Uvicorn/FastAPI em stdout (infra captura awslogs)

B) Configurar logging JSON estruturado na app

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Artefatos após respostas
- [x] `nfr-requirements/nfr-requirements.md`
- [x] `nfr-requirements/tech-stack-decisions.md`
